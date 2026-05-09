import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cài đặt',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.info_outline, color: AppColors.textGrey),
            title: Text('Phiên bản', style: TextStyle(color: Colors.white)),
            subtitle: Text('1.0.0', style: TextStyle(color: AppColors.textGrey)),
          ),
          ListTile(
            leading: Icon(Icons.music_note, color: AppColors.textGrey),
            title: Text('Định dạng hỗ trợ',
                style: TextStyle(color: Colors.white)),
            subtitle: Text('MP3, M4A, WAV, FLAC, OGG, AAC',
                style: TextStyle(color: AppColors.textGrey)),
          ),
        ],
      ),
    );
  }
}