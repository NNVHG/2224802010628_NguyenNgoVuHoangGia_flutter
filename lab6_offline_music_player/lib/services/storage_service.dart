import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/playlist_model.dart';

class StorageService {
  static const String _playlistsKey  = 'playlists';
  static const String _lastPlayedKey = 'last_played';
  static const String _shuffleKey    = 'shuffle_enabled';
  static const String _repeatKey     = 'repeat_mode';
  static const String _volumeKey     = 'volume';
  static const String _volumeSyncKey = 'volume_sync';
  static const String _recentPlayedKey = 'recent_played_list';

  Future<void> savePlaylists(List<PlaylistModel> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    final json  = playlists.map((p) => p.toJson()).toList();
    await prefs.setString(_playlistsKey, jsonEncode(json));
  }

  Future<List<PlaylistModel>> getPlaylists() async {
    final prefs  = await SharedPreferences.getInstance();
    final string = prefs.getString(_playlistsKey);
    if (string == null) return [];
    final List<dynamic> list = jsonDecode(string);
    return list
        .map((j) => PlaylistModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void>    saveLastPlayed(String id)    async => (await SharedPreferences.getInstance()).setString(_lastPlayedKey, id);
  Future<String?> getLastPlayed()              async => (await SharedPreferences.getInstance()).getString(_lastPlayedKey);
  Future<void>    saveShuffleState(bool on)    async => (await SharedPreferences.getInstance()).setBool(_shuffleKey, on);
  Future<bool>    getShuffleState()            async => (await SharedPreferences.getInstance()).getBool(_shuffleKey) ?? false;
  Future<void>    saveRepeatMode(int mode)     async => (await SharedPreferences.getInstance()).setInt(_repeatKey, mode);
  Future<int>     getRepeatMode()              async => (await SharedPreferences.getInstance()).getInt(_repeatKey) ?? 0;
  Future<void>    saveVolume(double v)         async => (await SharedPreferences.getInstance()).setDouble(_volumeKey, v);
  Future<double>  getVolume()                  async => (await SharedPreferences.getInstance()).getDouble(_volumeKey) ?? 1.0;
  Future<void>    saveVolumeSyncState(bool on) async => (await SharedPreferences.getInstance()).setBool(_volumeSyncKey, on);
  Future<bool>    getVolumeSyncState()         async => (await SharedPreferences.getInstance()).getBool(_volumeSyncKey) ?? true;

  Future<void> saveRecentlyPlayed(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentPlayedKey, ids);
  }

  Future<List<String>> getRecentlyPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentPlayedKey) ?? [];
  }
}