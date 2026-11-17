# Warisan Kating

> Platform jual-beli & barter barang bekas antar mahasiswa — dibangun dengan Flutter + Firebase.

## 📱 Deskripsi

**Warisan Kating** adalah aplikasi mobile e-commerce / barter yang memungkinkan mahasiswa untuk menjual, membeli, atau menukarkan barang bekas (buku, elektronik, pakaian, dll.) secara langsung dengan sesama mahasiswa. Aplikasi ini dibangun menggunakan Flutter (Dart) dan Firebase sebagai backend.

## ✨ 3 Fitur Utama

### 1. 📦 Jual & Barter Barang
Pasang barang dengan foto langsung dari kamera atau galeri. Gambar otomatis dikompresi ke ≤ 300 KB sebelum diunggah ke Firebase Storage. Dukung harga reguler (Rp) maupun barter/gratis.

### 2. 💬 Chat Real-Time
Chat langsung antara pembeli dan penjual menggunakan Firestore subcollection (`chats/{chatId}/messages`). Pesan muncul secara real-time dengan auto-scroll dan bubble design.

### 3. 🔄 Sistem Barter
Ajukan permintaan barter langsung dari halaman produk. Status barter terlacak (pending → accepted/rejected → completed) melalui Firestore.

## 🏗️ Arsitektur

```
lib/
├── main.dart                            # Entry point
├── app.dart                             # MaterialApp + MultiProvider
├── core/
│   ├── constants/app_constants.dart      # Collection names, app-wide constants
│   ├── router/app_router.dart            # Centralized named routing
│   └── theme/app_theme.dart              # Material 3 theme
├── features/
│   ├── home/screens/                     # Product feed (StreamBuilder grid)
│   ├── add_product/screens/              # Add item form + image picker
│   ├── item_detail/screens/              # Product detail + barter/chat actions
│   ├── chat/screens/                     # Chat list + chat room
│   ├── main_shell/screens/               # BottomNavigationBar shell
│   └── profile/screens/                  # Profile placeholder
├── services/
│   ├── firestore/                        # Live Firebase implementations
│   ├── mock/                             # In-memory mocks for testing
│   ├── item_service.dart                 # Abstract item CRUD + stream
│   ├── chat_service.dart                 # Abstract chat operations
│   ├── barter_service.dart               # Abstract barter flow
│   ├── user_service.dart                 # Abstract user CRUD
│   └── image_picker_service.dart         # Abstract pick + compress
└── shared/
    ├── models/                           # Data models (toMap/fromMap)
    └── widgets/                          # Reusable UI components
```

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x (Dart) |
| Backend | Firebase (Firestore, Storage) |
| State Management | Provider |
| Image Handling | image_picker + flutter_image_compress |
| ID Generation | uuid |

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK ≥ 3.13.0
- Firebase CLI (`firebase-tools`)
- Android Studio / VS Code
- A Firebase project

### 1. Clone the repository
```bash
git clone https://github.com/<your-username>/warisan_kating.git
cd warisan_kating
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Configure Firebase
1. Create a project at [Firebase Console](https://console.firebase.google.com/).
2. Add an **Android** app → download `google-services.json` → place in `android/app/`.
3. *(Optional)* Add an **iOS** app → download `GoogleService-Info.plist` → place in `ios/Runner/`.
4. Enable **Cloud Firestore** and **Firebase Storage** in the console.

### 4. Run the app
```bash
flutter run
```

## 📋 Firestore Collections

| Collection | Fields |
|------------|--------|
| `products` | id, title, description, price, condition, imageUrl, sellerId, timestamp |
| `users` | id, name, contact |
| `barters` | id, itemId, offerItemId, requesterId, ownerId, message, status, createdAt |
| `chats` | id, itemId, participants[], lastMessage, updatedAt |
| `chats/{id}/messages` | id, senderId, receiverId, text, timestamp |

## 👥 Tim

Warisan Kating — Pemrograman Perangkat Bergerak, Semester 5.

## 📄 License

This project is for educational purposes.
