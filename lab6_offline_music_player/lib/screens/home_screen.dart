import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../widgets/song_tile.dart';
import '../widgets/mini_player.dart';
import '../utils/constants.dart';
import '../models/song_model.dart';
import 'now_playing_screen.dart';
import 'playlist_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  String _sortOption = 'Mặc định';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              child: Row(
                children: [
                  if (!_isSearching) ...[
                    const Expanded(
                      child: Text('🎵 My Music',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () => setState(() => _isSearching = true),
                    ),
                    IconButton(
                      icon: const Icon(Icons.queue_music, color: Colors.white),
                      tooltip: 'Playlist',
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const PlaylistScreen())),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen())),
                    ),
                  ] else ...[
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Tìm bài hát...',
                          hintStyle: TextStyle(color: AppColors.textGrey),
                          border: InputBorder.none,
                        ),
                        onChanged: (v) => setState(() => _searchQuery = v),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() {
                          _isSearching = false;
                          _searchQuery = '';
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),

            Expanded(
              child: Consumer<AudioProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  List<MusicTrack> displaySongs = _searchQuery.isEmpty
                      ? List.from(provider.songs)
                      : provider.songs.where((s) {
                    final q = _searchQuery.toLowerCase();
                    return s.title.toLowerCase().contains(q) ||
                        s.artist.toLowerCase().contains(q);
                  }).toList();

                  if (_sortOption == 'A-Z') {
                    displaySongs.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
                  } else if (_sortOption == 'Z-A') {
                    displaySongs.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
                  }

                  if (displaySongs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.music_note, size: 80, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('Không tìm thấy bài hát nào',
                              style: TextStyle(color: Colors.white, fontSize: 20)),
                          const SizedBox(height: 8),
                          if (_searchQuery.isEmpty) ...[
                            const Text('Vuốt xuống để tải lại',
                                style: TextStyle(color: AppColors.textGrey)),
                          ]
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng cộng: ${displaySongs.length} bài hát',
                              style: const TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.sort, color: Colors.white),
                              color: AppColors.cardBg,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              tooltip: 'Sắp xếp',
                              onSelected: (value) {
                                setState(() {
                                  _sortOption = value;
                                });
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'Mặc định',
                                  child: Text('Mặc định',
                                      style: TextStyle(color: _sortOption == 'Mặc định' ? AppColors.primary : Colors.white)),
                                ),
                                PopupMenuItem(
                                  value: 'A-Z',
                                  child: Text('Tên: A - Z',
                                      style: TextStyle(color: _sortOption == 'A-Z' ? AppColors.primary : Colors.white)),
                                ),
                                PopupMenuItem(
                                  value: 'Z-A',
                                  child: Text('Tên: Z - A',
                                      style: TextStyle(color: _sortOption == 'Z-A' ? AppColors.primary : Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () async => await provider.scanAndAddSongs(),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 8),
                            itemCount: displaySongs.length,
                            itemBuilder: (context, index) {
                              final song = displaySongs[index];
                              final isCurrent = provider.currentSong?.id == song.id;

                              return SongTile(
                                song: song,
                                isPlaying: isCurrent,
                                onTap: () {
                                  provider.setPlaylist(displaySongs, index);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const NowPlayingScreen()),
                                  );
                                },
                              );
                            },
                          ),
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
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
}