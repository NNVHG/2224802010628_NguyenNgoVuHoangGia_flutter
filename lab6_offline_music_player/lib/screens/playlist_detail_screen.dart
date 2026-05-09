import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/playlist_model.dart';
import '../providers/audio_provider.dart';
import '../utils/constants.dart';
import '../widgets/song_tile.dart';
import '../widgets/mini_player.dart';
import 'now_playing_screen.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final PlaylistModel playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(playlist.name, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AudioProvider>(
              builder: (context, provider, _) {
                final currentPlaylist = provider.playlists.firstWhere(
                        (p) => p.id == playlist.id,
                    orElse: () => playlist);

                final playlistSongs = provider.songs
                    .where((song) => currentPlaylist.songIds.contains(song.id))
                    .toList();

                if (playlistSongs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.music_off, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Playlist trống', style: TextStyle(color: Colors.white, fontSize: 18)),
                        SizedBox(height: 8),
                        Text('Hãy thêm bài hát từ màn hình chính', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                      child: Text(
                        'Tổng cộng: ${playlistSongs.length} bài hát',
                        style: const TextStyle(color: AppColors.textGrey, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        icon: const Icon(Icons.play_arrow, size: 28),
                        label: const Text('Phát danh sách', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          provider.setPlaylist(playlistSongs, 0);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const NowPlayingScreen()));
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 8),
                        itemCount: playlistSongs.length,
                        itemBuilder: (context, index) {
                          final song = playlistSongs[index];
                          final isCurrent = provider.currentSong?.id == song.id;

                          return Dismissible(
                            key: Key('${playlist.id}_${song.id}'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              color: Colors.redAccent,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              provider.removeSongFromPlaylist(playlist.id, song.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Đã xóa khỏi playlist')),
                              );
                            },
                            child: SongTile(
                              song: song,
                              isPlaying: isCurrent,
                              onTap: () {
                                provider.setPlaylist(playlistSongs, index);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const NowPlayingScreen()));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Consumer<AudioProvider>(
            builder: (_, provider, __) => provider.currentSong != null
                ? const MiniPlayer()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}