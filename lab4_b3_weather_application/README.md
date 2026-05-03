# 🌤️ Lab 4 B3 - Ứng dụng Thời Tiết (Weather Application)
link video demo: https://drive.google.com/file/d/1j39W07o2AAdoSdz7jX5Jj6z4HdkYE4GA/view?usp=sharing
## 🚀 Các chức năng chính (Key Features)

*   📍 **Định vị tự động (Auto-location):** Tự động phát hiện vị trí GPS hiện tại của người dùng để hiển thị thời tiết khu vực đó.
*   <img width="399" height="846" alt="image" src="https://github.com/user-attachments/assets/d5d069ac-5a70-40e7-99ed-635e7fdfe421" />

*   🔍 **Tìm kiếm thành phố (City Search):** Cho phép người dùng nhập tên thành phố bất kỳ (hỗ trợ cả tên không dấu) để tra cứu tình trạng thời tiết.
*   <img width="388" height="837" alt="image" src="https://github.com/user-attachments/assets/6f0a01cb-4eae-4ac1-9432-985e07447836" />

*   📊 **Hiển thị thời tiết chi tiết (Detailed Weather):** Cung cấp các thông số như nhiệt độ, nhiệt độ cảm nhận (feels like), độ ẩm (humidity), tốc độ gió (wind speed) và mô tả thời tiết bằng tiếng Việt.
*   <img width="396" height="822" alt="image" src="https://github.com/user-attachments/assets/86423e55-9197-4496-826f-33b361fd4300" />

*   📅 **Dự báo thời tiết (Weather Forecast):** Trình bày danh sách dự báo thời tiết theo từng mốc 3 giờ trong những ngày tới bằng cuộn ngang (horizontal scroll).
*   🎨 **Giao diện thay đổi theo thời tiết (Dynamic Background):** Hình nền (gradient background) của thẻ thời tiết sẽ tự động đổi màu tương ứng với điều kiện thời tiết (trời quang, mây mù, mưa...).
*   <img width="390" height="830" alt="image" src="https://github.com/user-attachments/assets/9225c364-1565-44e4-8bd3-9afe83ca362b" />

## 📁 Cấu trúc thư mục (Folder Structure)
```text
lib/
├── config/             # Cấu hình hệ thống (URL, endpoints)
├── models/             # Các lớp định nghĩa dữ liệu (WeatherModel, ForecastModel)
├── providers/          # Logic quản lý trạng thái (WeatherProvider)
├── screens/            # Các giao diện màn hình (HomeScreen, SearchScreen...)
├── services/           # Xử lý tác vụ nền (LocationService, WeatherService, StorageService)
├── widgets/            # Các thành phần giao diện dùng chung (CurrentWeatherCard)
└── main.dart           # Điểm khởi chạy của ứng dụng (Entry point)
