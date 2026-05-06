# 📝 Simple Note App

> **Lab 5 — Simple Note App**  
> Sinh viên: Nguyễn Ngô Vũ Hoàng Gia — MSSV: 2224802010628

---

## 📖 Mô tả dự án

**Simple Note App** là ứng dụng ghi chú đơn giản được xây dựng bằng **Flutter**, cho phép người dùng tạo, xem, chỉnh sửa và xóa ghi chú. Dữ liệu được lưu trữ cục bộ trên thiết bị thông qua cơ sở dữ liệu **SQLite** (sqflite), đảm bảo ghi chú luôn được giữ lại ngay cả khi tắt ứng dụng.

---

## ✨ Tính năng

| Tính năng | Mô tả |
|-----------|-------|
| ➕ Tạo ghi chú | Thêm ghi chú mới với tiêu đề và nội dung |
| 📋 Xem danh sách | Hiển thị tất cả ghi chú theo thứ tự mới nhất |
| ✏️ Chỉnh sửa | Cập nhật nội dung ghi chú đã có |
| 🗑️ Xóa | Xóa ghi chú với hộp thoại xác nhận |
| 💾 Lưu trữ cục bộ | Dữ liệu được lưu bằng SQLite, không cần internet |
| 🕐 Theo dõi thời gian | Hiển thị thời gian tạo và cập nhật ghi chú |

## Hình ảnh demo ✨
# Trang chủ 
<img width="390" height="815" alt="image" src="https://github.com/user-attachments/assets/f4e8b8d5-f443-4a82-a3a4-40473d54186b" />

# Tạo ghi chú
<img width="388" height="821" alt="image" src="https://github.com/user-attachments/assets/b585a0c0-93d4-44bd-a7d0-01491c36f989" />

<img width="378" height="823" alt="image" src="https://github.com/user-attachments/assets/a223973f-92ea-4c8a-870c-5aca24b79409" />

# Xem xem danh sách
<img width="386" height="837" alt="image" src="https://github.com/user-attachments/assets/cb052b56-4292-4e7a-a623-08e2c63755c3" />

<img width="389" height="842" alt="image" src="https://github.com/user-attachments/assets/8c86ba02-4917-42c0-9367-6160ceedb588" />

# Thoát app vào lại
<img width="381" height="826" alt="image" src="https://github.com/user-attachments/assets/3b89a2f7-9f25-489a-b424-d29ffc584f0c" />

<img width="379" height="833" alt="image" src="https://github.com/user-attachments/assets/d9f1dd4a-a0fa-4e8c-90ec-34313eefe24a" />

# Xóa ghi chú
<img width="381" height="825" alt="image" src="https://github.com/user-attachments/assets/cbac943d-d1fc-464c-9db6-79d513757b23" />

# Sữa ghi chú
<img width="389" height="822" alt="image" src="https://github.com/user-attachments/assets/022fa17d-4ca6-4931-aece-c64f1f2219c9" />

<img width="394" height="812" alt="image" src="https://github.com/user-attachments/assets/e13593a5-b29b-4025-aa6b-63a6ab715bee" />

## 🏗️ Kiến trúc dự án

```
lib/
├── main.dart                     # Điểm khởi động ứng dụng
├── models/
│   └── note.dart                 # Model dữ liệu ghi chú
├── database/
│   └── db_helper.dart            # Singleton Database Helper (SQLite)
├── providers/
│   └── note_provider.dart        # Quản lý trạng thái với Provider
├── screens/
│   ├── home_page.dart            # Màn hình danh sách ghi chú
│   └── note_editor_screen.dart   # Màn hình soạn thảo / chỉnh sửa
└── widgets/
    └── note_card.dart            # Widget hiển thị từng ghi chú
```

---

## 🔄 Luồng hoạt động

```
main.dart
  └── ChangeNotifierProvider(NoteProvider)
        └── HomePage
              ├── initState → loadNotes() từ SQLite
              ├── ListView  → NoteCard (hiển thị danh sách)
              │     ├── onTap    → NoteEditorScreen(note) → updateNote()
              │     └── onDelete → confirmDelete()        → deleteNote()
              └── FAB (+)  → NoteEditorScreen(null)       → addNote()
```

---

## 📄 Giấy phép

Dự án được thực hiện phục vụ mục đích học tập tại Đại học Thủ Dầu Một.  
© 2026 Nguyễn Ngô Vũ Hoàng Gia. All rights reserved.
