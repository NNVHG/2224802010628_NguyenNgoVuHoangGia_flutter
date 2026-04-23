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

#### Demo:
##Basic
<img width="409" height="866" alt="image" src="https://github.com/user-attachments/assets/f34b8e0f-a803-4bb8-9764-647d9c547cf9" />

##Scientific
<img width="413" height="880" alt="image" src="https://github.com/user-attachments/assets/453b8587-13e7-4a87-bdb6-0a3ea17e15f6" />

##Programmer
<img width="414" height="866" alt="image" src="https://github.com/user-attachments/assets/5875e450-0dd8-40db-ac6a-7894dccec7ed" />

##Settings
<img width="408" height="869" alt="image" src="https://github.com/user-attachments/assets/37c89b1c-9321-47ff-b5f0-4761b0c5024b" />

##History
<img width="414" height="883" alt="image" src="https://github.com/user-attachments/assets/3767d31b-4cfa-4311-90e8-a0ca8a1fe308" />






