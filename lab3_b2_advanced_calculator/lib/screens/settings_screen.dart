// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../models/calculator_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Cài đặt',
            style: TextStyle(fontFamily: 'Inter', color: Colors.white)),
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final settings = themeProvider.settings;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              // --- Giao diện (Theme) ---
              _buildSectionTitle('Giao diện (Theme)'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _themeChip(context, themeProvider, 'Sáng',
                      AppThemeMode.light, settings),
                  _themeChip(context, themeProvider, 'Tối',
                      AppThemeMode.dark, settings),
                  _themeChip(context, themeProvider, 'Hệ thống',
                      AppThemeMode.system, settings),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(color: Colors.blueGrey),

              // --- Độ chính xác thập phân (Decimal Precision) ---
              _buildSectionTitle(
                  'Độ chính xác thập phân: ${settings.decimalPrecision} chữ số'),
              Slider(
                min: 2,
                max: 10,
                divisions: 8,
                value: settings.decimalPrecision.toDouble(),
                label: '${settings.decimalPrecision}',
                activeColor: const Color(0xFF4ECDC4),
                onChanged: (v) =>
                    themeProvider.setDecimalPrecision(v.round()),
              ),

              const Divider(color: Colors.blueGrey),

              // --- Số lượng lịch sử (History Size) ---
              _buildSectionTitle('Số lượng lịch sử lưu'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [25, 50, 100].map((size) {
                  final selected = settings.historySize == size;
                  return FilterChip(
                    label: Text(
                      '$size',
                      style: TextStyle(
                        color: selected ? Colors.black : Colors.white,
                      ),
                    ),
                    selected: selected,
                    selectedColor: const Color(0xFF4ECDC4),
                    backgroundColor: const Color(0xFF2C2C2C),
                    checkmarkColor: Colors.black,
                    onSelected: (_) => themeProvider.setHistorySize(size),
                  );
                }).toList(),
              ),

              const Divider(color: Colors.blueGrey),

              // --- Phản hồi rung (Haptic Feedback) ---
              SwitchListTile(
                title: const Text(
                  'Phản hồi rung (Haptic Feedback)',
                  style: TextStyle(color: Colors.white),
                ),
                value: settings.hapticFeedback,
                activeColor: const Color(0xFF4ECDC4),
                onChanged: (v) => themeProvider.setHaptic(v),
              ),

              const Divider(color: Colors.blueGrey),

              // --- Xóa toàn bộ lịch sử ---
              ListTile(
                leading:
                const Icon(Icons.delete_forever, color: Colors.redAccent),
                title: const Text(
                  'Xóa toàn bộ lịch sử',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () => _showClearHistoryDialog(context),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF4ECDC4),
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _themeChip(
      BuildContext context,
      ThemeProvider provider,
      String label,
      AppThemeMode mode,
      CalculatorSettings settings,
      ) {
    final selected = settings.themeMode == mode;
    return FilterChip(                      // ← Dùng FilterChip thay ChoiceChip
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
        ),
      ),
      selected: selected,
      selectedColor: const Color(0xFF4ECDC4),
      backgroundColor: const Color(0xFF2C2C2C),
      checkmarkColor: Colors.black,
      onSelected: (_) => provider.setTheme(mode),   // ← onSelected thay onChanged
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1C),
        title: const Text(
          'Xóa toàn bộ lịch sử?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Hành động này không thể hoàn tác.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy',
                style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              context.read<CalculatorProvider>().clearAllHistory();
              Navigator.pop(ctx);
            },
            child: const Text('Xóa',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}