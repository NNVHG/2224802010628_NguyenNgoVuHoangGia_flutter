# 🎵 lab6_Offline Music Player
Một ứng dụng nghe nhạc offline mạnh mẽ được xây dựng bằng Flutter, hoàn thiện đầy đủ các yêu cầu của Lab 6.

## ✨ Tính năng nổi bật (Features)
- Quét và hiển thị toàn bộ nhạc có sẵn trên thiết bị bằng `on_audio_query`.
- Đọc siêu dữ liệu (Metadata) chuẩn xác: Tên bài hát, Nghệ sĩ, Ảnh bìa Album gốc.
- Tính năng phát nhạc: Play, Pause, Next, Previous, Tua nhạc (Seek).
- Quản lý chế độ lặp (Repeat One, Repeat All) và Trộn bài (Shuffle).
- Chạy nhạc dưới nền (Background Playback) với thanh điều khiển trên Notification.
- Quản lý Playlist: Tạo, Xóa, Gộp, Đổi tên và Xóa bài hát khỏi playlist bằng cử chỉ (Swipe).
- Trạng thái lưu trữ (Persistence): Lưu lại Playlist, Lịch sử nghe gần đây, Mức âm lượng, Cấu hình phát và **Khôi phục vị trí bài hát đang nghe dở**.
- Tìm kiếm bài hát và Sắp xếp thông minh (Theo Tên, Nghệ sĩ, Album, Ngày thêm).
- Đồng bộ âm lượng thông minh với phím cứng vật lý của thiết bị.

## 🛠️ Công nghệ sử dụng (Technologies)
- **Framework**: Flutter / Dart
- **State Management**: Provider
- **Local Storage**: Shared Preferences
- **Audio Engine**: `just_audio`, `just_audio_background`
- **Metadata**: `on_audio_query`
- **Permissions**: `permission_handler`

## 🚀 Hướng dẫn cài đặt (Setup Instructions)
1. Clone dự án về máy.
2. Chạy lệnh `flutter pub get` để tải các thư viện.
3. Kết nối thiết bị thật (Android 10+ hoặc iOS) hoặc máy ảo.
4. Chạy dự án bằng lệnh `flutter run`.
5. Khi mở ứng dụng, cấp quyền truy cập bộ nhớ (Storage/Media) để ứng dụng có thể quét nhạc.

## 📌 Hướng dẫn test (How to test)
- Tải các file MP3/M4A mẫu từ Free Music Archive hoặc các nguồn nhạc miễn phí và đưa vào thư mục `Download` hoặc `Music` trên điện thoại/máy ảo.
- Mở ứng dụng, vuốt xuống hoặc bấm nút quét để nạp thư viện nhạc.
- Thoát ứng dụng ra Home Screen để test tính năng nhạc chạy nền.
- Nghe dở 1 bài hát, tắt hẳn app (Kill app) rồi mở lại để test tính năng khôi phục vị trí bài hát.

## ⚠️ Hạn chế hiện tại (Known Limitations)
- Hiện tại tính năng đồng bộ âm lượng (`perfect_volume_control`) chỉ được tối ưu hóa mạnh nhất trên nền tảng Android.
- Chưa hỗ trợ đọc lời bài hát (Lyrics) nhúng bên trong file MP3.

## 💡 Hướng phát triển tương lai (Future Improvements)
- Hỗ trợ Equalizer (Tùy chỉnh âm thanh).
- Chế độ hẹn giờ tắt nhạc (Sleep Timer).
- Thêm các Animation động dựa trên tông màu chính của ảnh bìa (Palette Generator).