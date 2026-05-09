import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import '../models/song_model.dart';
import '../models/playlist_model.dart';
import '../services/audio_player_service.dart';
import '../services/storage_service.dart';
import '../services/playlist_service.dart';
import 'package:flutter/foundation.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayerService _audioService   = AudioPlayerService();
  final StorageService     _storageService = StorageService();
  final PlaylistService    _playlistService = PlaylistService();

  List<MusicTrack>    _songs              = [];
  List<MusicTrack>    _playlist           = [];
  List<PlaylistModel> _playlists          = [];
  List<MusicTrack>    _recentlyPlayed     = [];

  int                 _currentIndex = 0;
  bool                _isShuffle    = false;
  LoopMode            _loopMode     = LoopMode.off;
  bool                _isLoading    = false;
  bool                _isHandlingNext = false;
  bool                _isVolumeSyncEnabled = true;
  double              _volume       = 1.0;

  List<MusicTrack>    get songs         => _songs;
  List<MusicTrack>    get playlist      => _playlist;
  List<PlaylistModel> get playlists     => _playlists;
  List<MusicTrack>    get recentlyPlayed  => _recentlyPlayed;
  int                 get currentIndex  => _currentIndex;
  bool                get isLoading     => _isLoading;
  MusicTrack?         get currentSong   =>
      _playlist.isEmpty ? null : _playlist[_currentIndex];
  bool                get isShuffle     => _isShuffle;
  LoopMode            get loopMode      => _loopMode;
  double              get volume        => _volume;
  bool                get isVolumeSyncEnabled => _isVolumeSyncEnabled;

  Stream<Duration>           get positionStream      => _audioService.positionStream;
  Stream<Duration?>          get durationStream      => _audioService.durationStream;
  Stream<bool>               get playingStream       => _audioService.playingStream;
  Stream<PlaybackStateModel> get playbackStateStream => _audioService.playbackStateStream;

  AudioProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    _isShuffle = await _storageService.getShuffleState();
    final repeatIdx = await _storageService.getRepeatMode();
    _loopMode = LoopMode.values[repeatIdx];

    _isVolumeSyncEnabled = await _storageService.getVolumeSyncState();

    await _audioService.setLoopMode(_loopMode == LoopMode.one ? LoopMode.one : LoopMode.off);

    PerfectVolumeControl.hideUI = false;
    if (_isVolumeSyncEnabled) {
      _volume = await PerfectVolumeControl.getVolume();
    } else {
      _volume = await _storageService.getVolume();
    }
    await _audioService.setVolume(_volume);

    PerfectVolumeControl.stream.listen((newVolume) {
      if (_isVolumeSyncEnabled && _volume != newVolume) {
        _volume = newVolume;
        _audioService.setVolume(newVolume);
        notifyListeners();
      }
    });

    _playlists = await _storageService.getPlaylists();

    final saved = await _playlistService.getSavedSongs();
    final existing = await _playlistService.filterExistingFiles(saved);
    if (existing.isNotEmpty) {
      _songs = existing;
    } else {
      await _loadAssetsMusic();
    }

    final recentIds = await _storageService.getRecentlyPlayed();
    _recentlyPlayed = [];
    for (String id in recentIds) {
      try {
        final song = _songs.firstWhere((s) => s.id == id);
        _recentlyPlayed.add(song);
      } catch (e) {
        debugPrint('Bỏ qua bài hát không tồn tại: $id');
      }
    }

    _audioService.playerStateStream.listen((state) async {
      if (state.processingState == ProcessingState.completed) {
        if (_isHandlingNext) return;
        _isHandlingNext = true;

        if (_loopMode != LoopMode.one) {
          if (_loopMode == LoopMode.off && _currentIndex == _playlist.length - 1) {
            _audioService.stop();
            _audioService.seek(Duration.zero);
          } else {
            await next();
          }
        }

        await Future.delayed(const Duration(milliseconds: 500));
        _isHandlingNext = false;
      }
    });

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadAssetsMusic() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assetKeys = manifest.listAssets();

      final audioExtensions = {'.mp3', '.m4a', '.wav', '.flac', '.ogg', '.aac'};

      final assetSongs = assetKeys
          .where((key) {
        final lower = key.toLowerCase();
        return lower.startsWith('assets/audio/') &&
            audioExtensions.any((ext) => lower.endsWith(ext));
      })
          .map((assetPath) {
        final fileName = assetPath.split('/').last;
        final title = fileName.contains('.')
            ? fileName.substring(0, fileName.lastIndexOf('.'))
            : fileName;
        return MusicTrack(
          id:       assetPath.hashCode.toString(),
          title:    title,
          artist:   'Sample Artist',
          filePath: assetPath,
          album:    'Sample Songs',
        );
      })
          .toList();

      if (assetSongs.isNotEmpty) {
        _songs = assetSongs;
        await _playlistService.saveSongs(_songs);
        debugPrint('Loaded ${assetSongs.length} songs from assets');
      }
    } catch (e) {
      debugPrint('Error loading assets: $e');
    }
  }

  Future<void> scanAndAddSongs() async {
    _isLoading = true;
    notifyListeners();

    final found = await _playlistService.scanMusicDirectory();
    final existingPaths = _songs.map((s) => s.filePath).toSet();
    final newSongs = found
        .where((s) => !existingPaths.contains(s.filePath))
        .toList();

    _songs = [..._songs, ...newSongs];
    await _playlistService.saveSongs(_songs);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeSong(String songId) async {
    _songs = await _playlistService.removeSong(_songs, songId);
    notifyListeners();
  }

  Future<void> setPlaylist(List<MusicTrack> songs, int startIndex) async {
    _playlist     = songs;
    _currentIndex = startIndex;
    await _playSongAtIndex(_currentIndex);
    notifyListeners();
  }

  Future<void> _playSongAtIndex(int index) async {
    if (index < 0 || index >= _playlist.length) return;
    _currentIndex = index;
    final song = _playlist[index];

    if (song.filePath.startsWith('assets/')) {
      await _audioService.loadAsset(song);
    } else {
      await _audioService.loadAudio(song);
    }

    await _audioService.play();

    _recentlyPlayed.removeWhere((s) => s.id == song.id);
    _recentlyPlayed.insert(0, song);
    if (_recentlyPlayed.length > 15) {
      _recentlyPlayed.removeLast();
    }
    await _storageService.saveRecentlyPlayed(_recentlyPlayed.map((s) => s.id).toList());

    await _storageService.saveLastPlayed(song.id);
    notifyListeners();
  }

  Future<void> playPause() async {
    if (_audioService.isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.play();
    }
    notifyListeners();
  }

  Future<void> next() async {
    if (_playlist.isEmpty) return;
    _currentIndex = _isShuffle
        ? _randomIndex()
        : (_currentIndex + 1) % _playlist.length;
    await _playSongAtIndex(_currentIndex);
  }

  Future<void> previous() async {
    if (_playlist.isEmpty) return;
    if (_audioService.currentPosition.inSeconds > 3) {
      await _audioService.seek(Duration.zero);
    } else {
      _currentIndex = _isShuffle
          ? _randomIndex()
          : (_currentIndex - 1 + _playlist.length) % _playlist.length;
      await _playSongAtIndex(_currentIndex);
    }
  }

  Future<void> seek(Duration pos) async => await _audioService.seek(pos);

  Future<void> toggleShuffle() async {
    _isShuffle = !_isShuffle;
    await _storageService.saveShuffleState(_isShuffle);
    notifyListeners();
  }

  Future<void> toggleRepeat() async {
    switch (_loopMode) {
      case LoopMode.off: _loopMode = LoopMode.all; break;
      case LoopMode.all: _loopMode = LoopMode.one;  break;
      case LoopMode.one: _loopMode = LoopMode.off;  break;
    }

    await _audioService.setLoopMode(_loopMode == LoopMode.one ? LoopMode.one : LoopMode.off);

    await _storageService.saveRepeatMode(_loopMode.index);
    notifyListeners();
  }

  Future<void> setVolume(double v) async {
    _volume = v;
    await _audioService.setVolume(v);

    if (_isVolumeSyncEnabled) {
      await PerfectVolumeControl.setVolume(v);
    }

    await _storageService.saveVolume(v);
    notifyListeners();
  }

  Future<void> toggleVolumeSync(bool value) async {
    _isVolumeSyncEnabled = value;
    await _storageService.saveVolumeSyncState(value);

    if (value) {
      _volume = await PerfectVolumeControl.getVolume();
      await _audioService.setVolume(_volume);
    }
    notifyListeners();
  }

  Future<void> createPlaylist(String name) async {
    _playlists.add(PlaylistModel(
      id:        DateTime.now().millisecondsSinceEpoch.toString(),
      name:      name,
      songIds:   [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    await _storageService.savePlaylists(_playlists);
    notifyListeners();
  }

  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    final idx = _playlists.indexWhere((p) => p.id == playlistId);
    if (idx == -1) return;
    if (!_playlists[idx].songIds.contains(songId)) {
      final updated = _playlists[idx].copyWith(
        songIds: [..._playlists[idx].songIds, songId],
      );
      _playlists[idx] = updated;
      await _storageService.savePlaylists(_playlists);
      notifyListeners();
    }
  }

  Future<void> deletePlaylist(String id) async {
    _playlists.removeWhere((p) => p.id == id);
    await _storageService.savePlaylists(_playlists);
    notifyListeners();
  }

  Future<void> renamePlaylist(String id, String newName) async {
    final idx = _playlists.indexWhere((p) => p.id == id);
    if (idx == -1) return;

    final updated = _playlists[idx].copyWith(
        name: newName,
    );
    _playlists[idx] = updated;
    await _storageService.savePlaylists(_playlists);
    notifyListeners();
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    final idx = _playlists.indexWhere((p) => p.id == playlistId);
    if (idx == -1) return;

    final updatedSongIds = List<String>.from(_playlists[idx].songIds);
    updatedSongIds.remove(songId);

    final updated = _playlists[idx].copyWith(
        songIds: updatedSongIds,
    );
    _playlists[idx] = updated;
    await _storageService.savePlaylists(_playlists);
    notifyListeners();
  }

  int _randomIndex() =>
      DateTime.now().millisecondsSinceEpoch % _playlist.length;

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}