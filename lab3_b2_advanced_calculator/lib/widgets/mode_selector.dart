import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../models/calculator_mode.dart';
import '../screens/history_screen.dart';
import '../screens/settings_screen.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.history, color: Color(0xFF4ECDC4)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
          ),
          if (provider.mode == CalculatorMode.scientific)
            _buildAngleToggle(provider),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.settings, color: Color(0xFF4ECDC4)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
              ),
              TextButton(
                onPressed: () => provider.toggleMode(),
                child: Text(provider.mode.name.toUpperCase(), style: const TextStyle(color: Color(0xFF4ECDC4), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAngleToggle(CalculatorProvider provider) {
    return GestureDetector(
      onTap: () => provider.toggleAngleMode(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF4ECDC4)), borderRadius: BorderRadius.circular(8)),
        child: Text(provider.angleMode == AngleMode.degrees ? 'DEG' : 'RAD', style: const TextStyle(color: Color(0xFF4ECDC4), fontSize: 12)),
      ),
    );
  }
}