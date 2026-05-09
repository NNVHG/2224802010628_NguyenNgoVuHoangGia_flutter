import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Function(Duration) onSeek;

  const ProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  String _format(Duration d) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${pad(d.inMinutes.remainder(60))}:${pad(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    final maxVal = duration.inMilliseconds.toDouble();
    final curVal = position.inMilliseconds
        .toDouble()
        .clamp(0.0, maxVal > 0 ? maxVal : 1.0);

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight:  3,
            thumbShape:   const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor:   AppColors.primary,
            inactiveTrackColor: Colors.grey[800],
            thumbColor:         Colors.white,
            overlayColor:       AppColors.primary.withOpacity(0.3),
          ),
          child: Slider(
            value: curVal,
            min:   0.0,
            max:   maxVal > 0 ? maxVal : 1.0,
            onChanged: (value) =>
                onSeek(Duration(milliseconds: value.toInt())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_format(position),
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
              Text(_format(duration),
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}