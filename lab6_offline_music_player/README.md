# 🎵 lab6_Offline Music Player - Flutter

Một ứng dụng nghe nhạc offline mạnh mẽ, giao diện hiện đại được xây dựng bằng Flutter.

## ✨ Tính năng nổi bật (Features)

Ứng dụng được thiết kế với đầy đủ các tính năng của một trình phát nhạc:

* **Thư viện nhạc thông minh**: Tự động quét toàn bộ bộ nhớ thiết bị để tìm file âm thanh (.mp3, .m4a, .flac, .ogg...) bằng thư viện `on_audio_query`.
* **Trích xuất Metadata**: Hiển thị chính xác tên bài hát, nghệ sĩ, album và ảnh bìa (Album Art) gốc được nhúng trong file nhạc.
* **Điều khiển phát nhạc toàn diện**: Hỗ trợ Phát, Tạm dừng, Chuyển bài (Next/Previous), Tua nhanh (Seek), Trộn bài (Shuffle) và các chế độ Lặp lại (Repeat One/All).
* **Phát nhạc dưới nền (Background Playback)**: Nhạc vẫn tiếp tục phát khi thoát ứng dụng hoặc tắt màn hình, tích hợp bảng điều khiển trên thanh thông báo hệ thống.
* **Quản lý Playlist**: Tạo mới, xóa, đổi tên playlist và gộp các playlist lại với nhau. Hỗ trợ xóa nhanh bài hát khỏi playlist bằng cử chỉ vuốt (Swipe to remove).
* **Lịch sử nghe (Recently Played)**: Ghi nhớ các bài hát đã nghe gần đây ngay trên màn hình chính.
* **Tìm kiếm & Sắp xếp**: Tìm kiếm bài hát theo tên hoặc nghệ sĩ. Sắp xếp danh sách theo Tên, Nghệ sĩ, Album hoặc Ngày thêm mới nhất.
* **Đồng bộ âm lượng**: Tính năng đặc biệt cho phép đồng bộ thanh trượt âm lượng trong ứng dụng với phím cứng vật lý của điện thoại.
* **Lưu trữ trạng thái (Persistence)**: Tự động khôi phục bài hát đang nghe dở và vị trí (giây) đang phát khi mở lại ứng dụng.

## 📸 Ảnh chụp màn hình (Screenshots)

| Màn hình chính ( chưa có nhạc) | Màn hình chính ( có nhạc) | nhạc có sẵn trong máy |
|:---:|:---:|:---:|
| <img width="392" height="825" alt="image" src="https://github.com/user-attachments/assets/747db0e2-b85f-4713-98ab-a85d7c438a80" /> | <img width="418" height="911" alt="image" src="https://github.com/user-attachments/assets/4207e08d-fbbf-4785-a5b4-d7d4dc20703d" /> | <img width="414" height="888" alt="image" src="https://github.com/user-attachments/assets/b7be2445-a64d-4756-a0d8-8d2c513c135f" /> |
|chú thích: vì chưa reload nên nhạc chưa cập nhật| chú thích: nhạc có ảnh là nhạc tải từ trên mạng về máy còn lại là nhạc từ assets đẩy lên |:---:|
| tùy chọn của bài hát | hiện thông tin bài hát | Danh sách Playlist (chưa có Playlist) |
| <img width="425" height="901" alt="image" src="https://github.com/user-attachments/assets/caad1664-db28-41f0-8039-0e945fb90a79" /> | <img width="420" height="915" alt="image" src="https://github.com/user-attachments/assets/0af08552-9855-4794-b157-c001ca06c9fb" /> | <img width="412" height="898" alt="image" src="https://github.com/user-attachments/assets/e54766b7-6a6b-48c4-b702-47912daf78e7" /> |
| tạo Playlist | Playlist đã tạo | Danh sách Playlist |
| <img width="418" height="911" alt="image" src="https://github.com/user-attachments/assets/8f521eec-4ada-4af7-ae0f-eeb5f2d2e7e6" /> | <img width="432" height="903" alt="image" src="https://github.com/user-attachments/assets/0ed66c57-9bd7-42f1-8e35-4e9756e916b1" /> | <img width="428" height="913" alt="image" src="https://github.com/user-attachments/assets/86618234-d7a4-4edf-bf27-3eb0bee8701c" /> |
| thêm nhạc vào Playlist | Danh sách Playlist (khi đã có nhạc) | tùy chọn Playlist |
| <img width="418" height="904" alt="image" src="https://github.com/user-attachments/assets/d4f61704-9f8a-4447-89d8-3aff0be2607e" /> | <img width="414" height="900" alt="image" src="https://github.com/user-attachments/assets/42f376e1-583e-4239-bc1c-bce6eb06205c" /> | <img width="421" height="896" alt="image" src="https://github.com/user-attachments/assets/e09242d1-ed78-4f0a-9946-a8fa840c06db" /> |
| đổi tên Playlist | xem Playlist (khi đã có nhạc) | xem Playlist (khi chưa có nhạc) |
| <img width="416" height="896" alt="image" src="https://github.com/user-attachments/assets/c69c7360-da1b-4980-94b8-f251c4d54d34" /> | <img width="430" height="917" alt="image" src="https://github.com/user-attachments/assets/850f4bad-4d79-4d15-9f58-e9ca528a5012" /> | <img width="435" height="909" alt="image" src="https://github.com/user-attachments/assets/2f12d838-2c6f-483e-9de7-dbc0d8b49343" /> |
| trước khi gộp Playlist | trước khi gộp Playlist | chọn Playlist để gộp |
| <img width="420" height="899" alt="image" src="https://github.com/user-attachments/assets/88853b24-d6e5-463b-8670-9c40f772ed5d" /> | <img width="414" height="901" alt="image" src="https://github.com/user-attachments/assets/2b44dd6f-29a8-4259-abd2-4aeeb2dcdde1" /> | <img width="413" height="899" alt="image" src="https://github.com/user-attachments/assets/1540295e-1163-4fb8-b7cd-ed3c83c889e0" /> |
| đã gộp Playlist | sau khi gộp Playlist | xóa nhạc khỏi Playlist |
| <img width="426" height="906" alt="image" src="https://github.com/user-attachments/assets/f55fa4f6-1e39-4731-9db1-8dfe6844ca74" /> | <img width="419" height="913" alt="image" src="https://github.com/user-attachments/assets/75d8ce67-f52a-4861-b84e-711d0f1518f3" /> | <img width="413" height="901" alt="image" src="https://github.com/user-attachments/assets/99a0f131-4f68-492e-87a8-fc96471bb3a6" /> |
| sau khi xóa nhạc khỏi Playlist | sau khi xóa nhạc khỏi Playlist | xóa Playlist |
| <img width="415" height="902" alt="image" src="https://github.com/user-attachments/assets/08a61004-21eb-41ad-ad65-b04796786ae6" /> | <img width="422" height="901" alt="image" src="https://github.com/user-attachments/assets/2e46e630-38ff-434b-b323-cf71f33efa1c" /> | <img width="416" height="887" alt="image" src="https://github.com/user-attachments/assets/b2652da4-86bd-42e0-91c1-f13ea321ef94" /> |
| quét tìm nhạc | tìm kiếm | tìm kiếm |
| <img width="418" height="893" alt="image" src="https://github.com/user-attachments/assets/2d66dbb8-d6e6-49a1-9f40-106b29248a80" /> | <img width="426" height="895" alt="image" src="https://github.com/user-attachments/assets/f50d570e-7a71-4208-9c4f-629d85adaf10" /> | <img width="418" height="893" alt="image" src="https://github.com/user-attachments/assets/cc9119ce-3681-4804-ab0a-f96fe1917327" /> |
| tìm kiếm | bộ lọc | lọc theo tên |
| <img width="421" height="900" alt="image" src="https://github.com/user-attachments/assets/7d28674a-7fd4-4d49-9950-811460005401" /> | <img width="423" height="911" alt="image" src="https://github.com/user-attachments/assets/3ffad5af-1097-489b-a75d-2b14420a16be" /> | <img width="415" height="901" alt="image" src="https://github.com/user-attachments/assets/da6dcdf4-fa99-4920-a88b-298e8c74fdbc" /> |
| cài đặt | đồng bộ âm thanh với thiết bị | cài đặt |
| <img width="416" height="905" alt="image" src="https://github.com/user-attachments/assets/b758127d-13c1-4f21-9ca3-3f2b72769415" /> | <img width="425" height="894" alt="image" src="https://github.com/user-attachments/assets/fe159c0a-664c-4437-ba7c-49079f173b98" /> | <img width="421" height="911" alt="image" src="https://github.com/user-attachments/assets/f14b6df9-05d6-424a-94bb-7a7d0605d2ea" /> |
| tắt đồng bộ âm thanh với thiết bị | trang chủ sau khi phát nhạc | --- |
| <img width="416" height="898" alt="image" src="https://github.com/user-attachments/assets/5b9a85b6-21f3-4e61-972b-b24e26545013" /> | <img width="424" height="904" alt="image" src="https://github.com/user-attachments/assets/ec92fe11-f80b-45dc-8779-6fa439765ced" /> | --- |

## 📸 Ảnh chụp màn hình các chức năng nhạc (Screenshots)

| trình phát | tự chuyển bài | trang chủ |
|:---:|:---:|:---:|
| <img width="417" height="895" alt="image" src="https://github.com/user-attachments/assets/657a4c0b-dc45-4dc8-b0a7-aee10f6b5eee" /> | <img width="423" height="899" alt="image" src="https://github.com/user-attachments/assets/ea5ad3a2-eb60-4a2b-bc39-29a7be9f3d7c" /> | <img width="412" height="901" alt="image" src="https://github.com/user-attachments/assets/93871e25-e321-4e00-9247-46a631b4d939" /> |
| phát trộn bài | trang chủ | phát trong nền |
| <img width="418" height="912" alt="image" src="https://github.com/user-attachments/assets/255b99c4-53c5-4bf4-92c0-2d8579479705" /> | <img width="414" height="912" alt="image" src="https://github.com/user-attachments/assets/a33a337b-6fa0-4c48-b246-fbe7d52b0038" /> | <img width="418" height="893" alt="image" src="https://github.com/user-attachments/assets/ff39d0b8-2634-498d-94c4-b0fb619d89f6" /> |


## 🎥 Video Demo

Xem video giới thiệu các tính năng và trải nghiệm thực tế của ứng dụng tại đây:
👉 **[Link Video Demo](https://drive.google.com/file/d/1_Be_q4IHbEDs0kH6FV0HypJv_4Vxj_tI/view?usp=sharing)**

## 🛠️ Công nghệ sử dụng (Technologies)

* **Ngôn ngữ**: Dart
* **Framework**: Flutter
* **Quản lý trạng thái**: Provider (v6.1.1)
* **Phát nhạc**: `just_audio` & `just_audio_background`
* **Truy vấn dữ liệu**: `on_audio_query`
* **Lưu trữ cục bộ**: `shared_preferences`
* **Xử lý quyền**: `permission_handler`

## 🚀 Hướng dẫn cài đặt (Setup Instructions)

1.  **Tải mã nguồn**: Clone project hoặc tải file zip về máy.
2.  **Cài đặt thư viện**: Mở terminal tại thư mục gốc và chạy:
    ```bash
    flutter pub get
    ```
3.  **Cấu hình quyền**: Đảm bảo đã cấp quyền `READ_EXTERNAL_STORAGE` (Android) hoặc `NSAppleMusicUsageDescription` (iOS) trong file cấu hình hệ thống.
4.  **Chạy ứng dụng**: Kết nối thiết bị và chạy lệnh:
    ```bash
    flutter run
    ```

## 📌 Cách thêm nhạc để Test

Để ứng dụng hiển thị nhạc trên máy ảo hoặc thiết bị thật:
1.  Tải các file nhạc mẫu (.mp3).
2.  Đưa nhạc vào thư mục `Download` hoặc `Music` của thiết bị.
3.  Mở ứng dụng, nhấn vào nút **Quét nhạc (Icon Sync)** ở góc trên màn hình để cập nhật thư viện.

## ⚠️ Hạn chế (Known Limitations)

* Tính năng đồng bộ Volume hệ thống hoạt động tối ưu nhất trên nền tảng Android.
* Chưa hỗ trợ hiển thị lời bài hát (Lyrics).

## 💡 Hướng phát triển tương lai

* Tích hợp bộ chỉnh âm (Equalizer).
* Chế độ Hẹn giờ tắt nhạc (Sleep Timer).
* Chủ đề ứng dụng thay đổi linh hoạt theo màu sắc ảnh bìa bài hát.
