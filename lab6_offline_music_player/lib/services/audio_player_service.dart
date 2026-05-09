import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../models/song_model.dart';

class PlaybackStateModel {
  final Duration position;
  final Duration duration;
  final bool isPlaying;

  PlaybackStateModel({
    required this.position,
    required this.duration,
    required this.isPlaying,
  });

  double get progress {
    if (duration.inMilliseconds > 0) {
      return position.inMilliseconds / duration.inMilliseconds;
    }
    return 0.0;
  }
}

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  Stream<Duration>    get positionStream    => _player.positionStream;
  Stream<Duration?>   get durationStream    => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<bool>        get playingStream     => _player.playingStream;

  Duration  get currentPosition => _player.position;
  Duration? get currentDuration => _player.duration;
  bool      get isPlaying       => _player.playing;

  Stream<PlaybackStateModel> get playbackStateStream {
    return Rx.combineLatest3<Duration, Duration?, bool, PlaybackStateModel>(
      positionStream,
      durationStream,
      playingStream,
          (position, duration, isPlaying) => PlaybackStateModel(
        position:  position,
        duration:  duration ?? Duration.zero,
        isPlaying: isPlaying,
      ),
    );
  }

  Future<void> loadAudio(MusicTrack song) async {
    try {
      final audioSource = AudioSource.uri(
        Uri.file(song.filePath),
        tag: MediaItem(
          id: song.id,
          album: song.album ?? 'Unknown Album',
          title: song.title,
          artist: song.artist,
          artUri: song.albumArt != null ? Uri.file(song.albumArt!) : null,
        ),
      );
      await _player.setAudioSource(audioSource);
    } catch (e) {
      throw Exception('Lỗi tải file: $e');
    }
  }

  Future<void> loadAsset(MusicTrack song) async {
    try {
      final audioSource = AudioSource.uri(
        Uri.parse('asset:///${song.filePath}'),
        tag: MediaItem(
          id: song.id,
          album: song.album ?? 'Sample Songs',
          title: song.title,
          artist: song.artist,
        ),
      );
      await _player.setAudioSource(audioSource);
    } catch (e) {
      throw Exception('Lỗi tải asset: $e');
    }
  }

  Future<void> play()                         async => await _player.play();
  Future<void> pause()                        async => await _player.pause();
  Future<void> stop()                         async => await _player.stop();
  Future<void> seek(Duration position)        async => await _player.seek(position);
  Future<void> setVolume(double volume)       async => await _player.setVolume(volume);
  Future<void> setSpeed(double speed)         async => await _player.setSpeed(speed);
  Future<void> setLoopMode(LoopMode loopMode) async => await _player.setLoopMode(loopMode);

  void dispose() => _player.dispose();
}