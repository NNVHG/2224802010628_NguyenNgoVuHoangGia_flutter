import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../utils/constants.dart';
import 'artwork_widget.dart';

class SongTile extends StatelessWidget {
  final MusicTrack   song;
  final VoidCallback onTap;
  final bool         isPlaying;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _buildAlbumArt(),
      title: Text(
        song.title,
        style: TextStyle(
          color:      isPlaying ? AppColors.primary : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist,
        style: const TextStyle(color: AppColors.textGrey),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, color: AppColors.textGrey),
        onPressed: () => _showOptions(context),
      ),
      onTap: onTap,
    );
  }

  Widget _buildAlbumArt() {
    return ArtworkWidget(
      artworkId: song.albumArt,
      size: 50.0,
      borderRadius: 4.0,
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context:         context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width:  40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color:        Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.playlist_add, color: Colors.white),
            title: const Text('Thêm vào playlist',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(sheetCtx);
              _showAddToPlaylistDialog(context);
            },
          ),


          ListTile(
            leading: const Icon(Icons.delete_outline,
                color: Colors.redAccent),
            title: const Text('Xóa khỏi thư viện',
                style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(sheetCtx);
              context.read<AudioProvider>().removeSong(song.id);
            },
          ),

          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: const Text('Thông tin bài hát',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(sheetCtx);
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppColors.cardBg,
                  title: const Text('Thông tin',
                      style: TextStyle(color: Colors.white)),
                  content: Text(
                    'Tiêu đề: ${song.title}\n'
                        'Nghệ sĩ: ${song.artist}\n'
                        'Album: ${song.album ?? "Không rõ"}\n'
                        'Thời lượng: ${_formatDuration(song.duration)}',
                    style: const TextStyle(
                        color: AppColors.textGrey, height: 1.6),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Đóng',
                          style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _showAddToPlaylistDialog(BuildContext context) {
    final provider = context.read<AudioProvider>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text('Chọn playlist',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provider.playlists.length,
              itemBuilder: (ctx, i) {
                final pl = provider.playlists[i];
                return ListTile(
                  leading: const Icon(Icons.queue_music, color: AppColors.textGrey),
                  title: Text(pl.name,
                      style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    provider.addSongToPlaylist(pl.id, song.id);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã thêm vào ${pl.name}')),
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
            child: const Text('Hủy',
                style: TextStyle(color: AppColors.textGrey)),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '--:--';
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${pad(d.inMinutes.remainder(60))}:${pad(d.inSeconds.remainder(60))}';
  }
}