import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/song_model.dart';

class PlaylistService {
  static const String _songsKey = 'saved_songs';

  Future<List<MusicTrack>> scanMusicDirectory() async {
    final List<MusicTrack> tracks = [];

    final List<String> musicPaths = [
      '/storage/emulated/0/Music',
      '/storage/emulated/0/Download',
      '/storage/emulated/0/Downloads',
      '/storage/emulated/0/DCIM',
      '/sdcard/Music',
      '/sdcard/Download',
    ];

    const supportedExtensions = {
      '.mp3', '.m4a', '.wav', '.flac', '.ogg', '.aac'
    };

    for (final path in musicPaths) {
      final dir = Directory(path);
      if (!await dir.exists()) continue;

      try {
        await for (final entity in dir.list(recursive: true)) {
          if (entity is File) {
            final lower = entity.path.toLowerCase();
            final ext   = lower.contains('.')
                ? '.${lower.split('.').last}'
                : '';
            if (supportedExtensions.contains(ext)) {
              tracks.add(MusicTrack.fromFilePath(entity.path));
            }
          }
        }
      } catch (_) {
        continue;
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