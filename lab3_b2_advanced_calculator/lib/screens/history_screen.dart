import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import 'package:intl/intl.dart'; // Đảm bảo đã thêm intl vào pubspec.yaml [cite: 53]

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Màu nền Dark Theme [cite: 29]
      appBar: AppBar(
        title: const Text('Lịch sử tính toán', style: TextStyle(fontFamily: 'Inter')),
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              // Thêm hàm xóa toàn bộ lịch sử nếu cần (Step 6)
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Xóa lịch sử?'),
                  content: const Text('Bạn có chắc chắn muốn xóa toàn bộ lịch sử tính toán?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
                    TextButton(
                        onPressed: () {
                          // Gọi hàm clearHistory trong Provider (cần định nghĩa thêm)
                          Navigator.pop(context);
                        },
                        child: const Text('Xóa')
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Consumer<CalculatorProvider>(
        builder: (context, provider, child) {
          if (provider.history.isEmpty) {
            return const Center(
              child: Text('Chưa có dữ liệu lịch sử', style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.builder(
            itemCount: provider.history.length,
            itemBuilder: (context, index) {
              final item = provider.history[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                title: Text(
                  item.expression,
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                  textAlign: TextAlign.right,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '= ${item.result}',
                      style: const TextStyle(color: Color(0xFF4ECDC4), fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('HH:mm - dd/MM/yyyy').format(item.timestamp),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                onTap: () {
                  // Chạm để dùng lại kết quả (Step 3: History Preview) [cite: 94]
                  provider.onButtonPressed(item.result);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}