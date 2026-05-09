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
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const PlaylistScreen())),
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
                          hintText: 'Tìm bài hát, nghệ sĩ...',
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
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }

                  List<MusicTrack> displaySongs = _searchQuery.isEmpty
                      ? List.from(provider.songs)
                      : provider.songs.where((s) {
                    final q = _searchQuery.toLowerCase();
                    return s.title.toLowerCase().contains(q) ||
                        s.artist.toLowerCase().contains(q);
                  }).toList();

                  if (_sortOption == 'Tên (A-Z)') {
                    displaySongs.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
                  } else if (_sortOption == 'Nghệ sĩ (A-Z)') {
                    displaySongs.sort((a, b) => a.artist.toLowerCase().compareTo(b.artist.toLowerCase()));
                  } else if (_sortOption == 'Album (A-Z)') {
                    displaySongs.sort((a, b) => (a.album ?? '').toLowerCase().compareTo((b.album ?? '').toLowerCase()));
                  }

                  if (displaySongs.isEmpty) {
                    return const Center(
                      child: Text('Không tìm thấy bài hát nào',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      if (!_isSearching && provider.recentlyPlayed.isNotEmpty) ...[
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
                            child: Text('⏱ Nghe gần đây',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 140,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: provider.recentlyPlayed.length,
                              itemBuilder: (context, index) {
                                final song = provider.recentlyPlayed[index];
                                return GestureDetector(
                                  onTap: () {
                                    provider.setPlaylist(provider.recentlyPlayed, index);
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NowPlayingScreen()));
                                  },
                                  child: Container(
                                    width: 110,
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 110, height: 110,
                                          decoration: BoxDecoration(
                                            color: AppColors.cardBg,
                                            borderRadius: BorderRadius.circular(12),
                                            image: song.albumArt != null
                                                ? DecorationImage(image: AssetImage(song.albumArt!), fit: BoxFit.cover)
                                                : null,
                                          ),
                                          child: song.albumArt == null
                                              ? const Icon(Icons.music_note, color: AppColors.primary, size: 40) : null,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(song.title,
                                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                            maxLines: 1, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      ],

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tất cả: ${displaySongs.length} bài hát',
                                style: const TextStyle(color: AppColors.textGrey, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.sort, color: Colors.white),
                                color: AppColors.cardBg,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                onSelected: (value) => setState(() => _sortOption = value),
                                itemBuilder: (context) => [
                                  _buildSortItem('Mặc định'),
                                  _buildSortItem('Tên (A-Z)'),
                                  _buildSortItem('Nghệ sĩ (A-Z)'),
                                  _buildSortItem('Album (A-Z)'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final song = displaySongs[index];
                            final isCurrent = provider.currentSong?.id == song.id;
                            return SongTile(
                              song: song,
                              isPlaying: isCurrent,
                              onTap: () {
                                provider.setPlaylist(displaySongs, index);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const NowPlayingScreen()));
                              },
                            );
                          },
                          childCount: displaySongs.length,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 80)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Consumer<AudioProvider>(
        builder: (_, provider, __) => provider.currentSong != null
            ? const MiniPlayer()
            : const SizedBox.shrink(),
      ),
    );
  }

  PopupMenuItem<String> _buildSortItem(String value) {
    return PopupMenuItem(
      value: value,
      child: Text(value,
          style: TextStyle(color: _sortOption == value ? AppColors.primary : Colors.white,
              fontWeight: _sortOption == value ? FontWeight.bold : FontWeight.normal)),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
}