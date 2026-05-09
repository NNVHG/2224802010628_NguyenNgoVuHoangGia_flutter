import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/song_model.dart';
import 'package:on_audio_query/on_audio_query.dart' as oq;

class PlaylistService {
  static const String _songsKey = 'saved_songs';
  final oq.OnAudioQuery _audioQuery = oq.OnAudioQuery();

  Future<List<MusicTrack>> scanMusicDirectory() async {
    final List<MusicTrack> tracks = [];
    bool hasPermission = await _audioQuery.checkAndRequest(retryRequest: true);
    if (!hasPermission) return [];

    List<oq.SongModel> songs = await _audioQuery.querySongs(
      sortType: null,
      orderType: oq.OrderType.ASC_OR_SMALLER,
      uriType: oq.UriType.EXTERNAL,
      ignoreCase: true,
    );

    for (var song in songs) {
      if (song.isMusic == true && (song.duration ?? 0) > 10000) {
        tracks.add(MusicTrack(
          id: song.data.hashCode.toString(),
          title: song.title,
          artist: song.artist == '<unknown>' ? 'Unknown Artist' : (song.artist ?? 'Unknown Artist'),
          album: song.album == '<unknown>' ? 'Unknown Album' : song.album,
          filePath: song.data,
          albumArt: song.id.toString(),
        ));
      }
    }
    return tracks;
  }

  Future<void> saveSongs(List<MusicTrack> songs) async {
    final prefs = await SharedPreferences.getInstance();
    final json  = songs.map((s) => s.toJson()).toList();
    await prefs.setString(_songsKey, jsonEncode(json));
  }

  Future<List<MusicTrack>> getSavedSongs() async {
    final prefs  = await SharedPreferences.getInstance();
    final string = prefs.getString(_songsKey);
    if (string == null) return [];
    final List<dynamic> list = jsonDecode(string);
    return list
        .map((j) => MusicTrack.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<MusicTrack>> removeSong(
      List<MusicTrack> songs, String songId) async {
    final updated = songs.where((s) => s.id != songId).toList();
    await saveSongs(updated);
    return updated;
  }

  Future<List<MusicTrack>> filterExistingFiles(
      List<MusicTrack> songs) async {
    final result = <MusicTrack>[];
    for (final song in songs) {
      if (await File(song.filePath).exists()) {
        result.add(song);
      }
    }
    return result;
  }
}