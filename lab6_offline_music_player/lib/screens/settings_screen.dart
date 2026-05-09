import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
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
      body: Consumer<AudioProvider>(
          builder: (context, provider, _) {
            return ListView(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline, color: AppColors.textGrey),
                  title: Text('Phiên bản', style: TextStyle(color: Colors.white)),
                  subtitle: Text('1.0.0', style: TextStyle(color: AppColors.textGrey)),
                ),
                const ListTile(
                  leading: Icon(Icons.music_note, color: AppColors.textGrey),
                  title: Text('Định dạng hỗ trợ',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text('MP3, M4A, WAV, FLAC, OGG, AAC',
                      style: TextStyle(color: AppColors.textGrey)),
                ),
                const Divider(color: Colors.grey),

                SwitchListTile(
                  activeThumbColor: AppColors.primary,
                  secondary: const Icon(Icons.sync, color: AppColors.textGrey),
                  title: const Text('Đồng bộ âm lượng hệ thống',
                      style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Đồng bộ thanh trượt trong app với phím cứng thiết bị',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  value: provider.isVolumeSyncEnabled,
                  onChanged: (bool value) {
                    provider.toggleVolumeSync(value);
                  },
                ),
              ],
            );
          }
      ),
    );
  }
}