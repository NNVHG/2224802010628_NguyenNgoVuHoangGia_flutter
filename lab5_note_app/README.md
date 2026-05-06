# 📝 Simple Note App

> **Lab 5 — Flutter Mobile Development**  
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