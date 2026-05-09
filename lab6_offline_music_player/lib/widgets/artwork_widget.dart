import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../utils/constants.dart';

class ArtworkWidget extends StatelessWidget {
  final String? artworkId;
  final double size;
  final double borderRadius;

  const ArtworkWidget({
    super.key,
    required this.artworkId,
    required this.size,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    int? id = artworkId != null ? int.tryParse(artworkId!) : null;

    if (id == null) return _buildPlaceholder();

    return QueryArtworkWidget(
      id: id,
      type: ArtworkType.AUDIO,
      artworkWidth: size,
      artworkHeight: size,
      artworkBorder: BorderRadius.circular(borderRadius),
      keepOldArtwork: true,
      nullArtworkWidget: _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(Icons.music_note, color: AppColors.primary, size: size * 0.5),
    );
  }
}