# 🧮 Advanced Mobile Calculator - Lab 3

Một ứng dụng Máy tính Đa năng được phát triển bằng Flutter, hỗ trợ đầy đủ các tính năng toán học từ cơ bản đến phức tạp, đi kèm với giao diện hiện đại, responsive và hệ thống quản lý bộ nhớ thông minh.

## ✨ Tính năng nổi bật (Features)

* **Đa chế độ (Multiple Modes):** Chuyển đổi linh hoạt giữa Basic (Cơ bản), Scientific (Khoa học) và Programmer (Lập trình viên).
* **Toán học nâng cao:** Hỗ trợ tính toán lượng giác (Sin, Cos, Tan), Logarit, căn bậc hai, và hệ cơ số (BIN, OCT, HEX).
* **Cử chỉ thông minh (Advanced Gestures):** * Vuốt ngang vùng hiển thị để xóa ký tự cuối.
    * Vuốt lên để xem Lịch sử.
    * Chụm 2 ngón tay (Pinch to zoom) để thay đổi kích thước chữ. (lỗi)
    * Nhấn giữ (Long press) nút 'C' để xóa toàn bộ lịch sử.
* **Lịch sử & Bộ nhớ (History & Memory):** Lưu trữ các phép tính bằng `SharedPreferences`. Hỗ trợ các biến nhớ M+, M-, MR, MC.
* **Giao diện Tương thích (Responsive UI):** Giao diện tự động tối ưu hóa cho màn hình dọc (Mobile) và tự động mở rộng bàn phím khi xoay ngang (Landscape/Tablet).
* **Cài đặt (Settings):** Hỗ trợ Dark/Light Theme (lỗi nhẹ), Haptic Feedback (rung) và Sound Effects (âm thanh).

## 🏗️ Kiến trúc & Công nghệ (Architecture)

* **Framework:** Flutter (Dart)
* **State Management:** Provider (Quản lý trạng thái tính toán và giao diện độc lập).
* **Packages sử dụng:**
    * `math_expressions`: Phân tích và giải quyết các chuỗi biểu thức toán học (PEMDAS).
    * `shared_preferences`: Lưu trữ dữ liệu cục bộ (Lịch sử, Cài đặt theme, Âm thanh).

### Cấu trúc thư mục (Folder Structure)
```text
lib/
├── models/         # Định nghĩa cấu trúc dữ liệu (History, Settings, Modes)
├── providers/      # Chứa logic nghiệp vụ (CalculatorProvider, ThemeProvider)
├── screens/        # Các màn hình chính (Calculator, Settings, History)
├── widgets/        # Các UI component có thể tái sử dụng (CalculatorButton)
└── main.dart       # Điểm khởi chạy của ứng dụng

#### Demo:
