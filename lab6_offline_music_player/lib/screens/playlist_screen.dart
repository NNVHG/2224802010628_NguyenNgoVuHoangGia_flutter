import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/playlist_model.dart';
import '../providers/audio_provider.dart';
import '../utils/constants.dart';
import 'playlist_detail_screen.dart';
import 'now_playing_screen.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Playlist', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<AudioProvider>(
        builder: (context, provider, _) {
          if (provider.playlists.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.queue_music, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Chưa có playlist nào',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Nhấn + để tạo playlist mới',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Tổng cộng: ${provider.playlists.length} playlist',
                  style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.playlists.length,
                  itemBuilder: (context, index) {
                    final pl = provider.playlists[index];
                    return ListTile(
                      leading: Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.queue_music, color: AppColors.primary),
                      ),
                      title: Text(pl.name, style: const TextStyle(color: Colors.white)),
                      subtitle: Text('${pl.songIds.length} bài hát',
                          style: const TextStyle(color: AppColors.textGrey)),

                      trailing: PopupMenuButton<int>(
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        color: AppColors.cardBg,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        onSelected: (value) {
                          if (value == 1) {
                            final playlistSongs = provider.songs
                                .where((song) => pl.songIds.contains(song.id))
                                .toList();
                            if (playlistSongs.isNotEmpty) {
                              provider.setPlaylist(playlistSongs, 0);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const NowPlayingScreen()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Playlist hiện đang trống')),
                              );
                            }
                          } else if (value == 2) {
                            _showMergeDialog(context, pl, provider);
                          } else if (value == 4) {
                            _showRenameDialog(context, pl, provider);
                          } else if (value == 3) {
                            provider.deletePlaylist(pl.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đã xóa playlist ${pl.name}')),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 1,
                            child: Row(children: [
                              Icon(Icons.play_arrow, color: Colors.white), SizedBox(width: 12),
                              Text('Phát playlist', style: TextStyle(color: Colors.white)),
                            ]),
                          ),
                          const PopupMenuItem(
                            value: 2,
                            child: Row(children: [
                              Icon(Icons.call_merge, color: Colors.white), SizedBox(width: 12),
                              Text('Gộp playlist', style: TextStyle(color: Colors.white)),
                            ]),
                          ),
                          const PopupMenuItem(
                            value: 4,
                            child: Row(children: [
                              Icon(Icons.edit, color: Colors.white), SizedBox(width: 12),
                              Text('Đổi tên', style: TextStyle(color: Colors.white)),
                            ]),
                          ),
                          const PopupMenuItem(
                            value: 3,
                            child: Row(children: [
                              Icon(Icons.delete_outline, color: Colors.redAccent), SizedBox(width: 12),
                              Text('Xóa playlist', style: TextStyle(color: Colors.redAccent)),
                            ]),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PlaylistDetailScreen(playlist: pl)),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('Tạo playlist mới', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Tên playlist...',
            hintStyle: TextStyle(color: AppColors.textGrey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<AudioProvider>().createPlaylist(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Tạo', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context, PlaylistModel playlist, AudioProvider provider) {
    final controller = TextEditingController(text: playlist.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('Đổi tên playlist', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Tên mới...',
            hintStyle: TextStyle(color: AppColors.textGrey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.renamePlaylist(playlist.id, controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Lưu', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showMergeDialog(BuildContext context, PlaylistModel currentPlaylist, AudioProvider provider) {
    final otherPlaylists = provider.playlists.where((p) => p.id != currentPlaylist.id).toList();

    if (otherPlaylists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không có playlist khác để gộp')));
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Gộp vào playlist...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: otherPlaylists.length,
              itemBuilder: (ctx, i) {
                final pl = otherPlaylists[i];
                return ListTile(
                  leading: const Icon(Icons.queue_music, color: AppColors.textGrey),
                  title: Text(pl.name, style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    for (final songId in pl.songIds) {
                      provider.addSongToPlaylist(currentPlaylist.id, songId);
                    }
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã gộp ${pl.name} vào ${currentPlaylist.name}')),
                    );
                  },
                );
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng', style: TextStyle(color: AppColors.textGrey)),
          ),
        ],
      ),
    );
  }
}