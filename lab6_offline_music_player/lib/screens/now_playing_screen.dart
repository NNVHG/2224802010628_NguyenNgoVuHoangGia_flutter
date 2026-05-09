import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../services/audio_player_service.dart';
import '../widgets/player_controls.dart';
import '../widgets/progress_bar.dart';
import '../utils/constants.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<AudioProvider>(
        builder: (context, provider, _) {
          final song = provider.currentSong;
          if (song == null) {
            return const Center(
              child: Text('Không có bài nào đang phát',
                  style: TextStyle(color: Colors.white)),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white, size: 32),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text('Đang phát',
                          style: TextStyle(
                              color: Colors.white, fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.more_vert,
                            color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width:  MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color:      Colors.black.withOpacity(0.5),
                                blurRadius: 20,
                                offset:     const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: song.albumArt != null
                                ? Image.file(File(song.albumArt!),
                                fit: BoxFit.cover)
                                : Container(
                              color: AppColors.cardBg,
                              child: const Icon(Icons.music_note,
                                  size: 100,
                                  color: AppColors.textGrey),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(song.title,
                            style: const TextStyle(
                              color:      Colors.white,
                              fontSize:   24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines:  2,
                            overflow:  TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Text(song.artist,
                            style: const TextStyle(
                              color:    AppColors.textGrey,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center),

                        const SizedBox(height: 20),

                        StreamBuilder<PlaybackStateModel>(
                          stream: provider.playbackStateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            return ProgressBar(
                              position: state?.position ?? Duration.zero,
                              duration: state?.duration ?? Duration.zero,
                              onSeek:   (pos) => provider.seek(pos),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        PlayerControls(provider: provider),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Icon(Icons.volume_down,
                                color: AppColors.textGrey),
                            Expanded(
                              child: Slider(
                                value:       provider.volume,
                                min:         0.0,
                                max:         1.0,
                                activeColor: AppColors.primary,
                                onChanged:   (v) => provider.setVolume(v),
                              ),
                            ),
                            const Icon(Icons.volume_up,
                                color: AppColors.textGrey),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}