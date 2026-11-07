# Flutter frontend

Frontend Flutter untuk aplikasi mobile banking. Panduan setup lengkap, termasuk persiapan backend dan konfigurasi alamat API, tersedia di [README utama](../README.md).

## Menjalankan aplikasi

Pastikan backend sudah berjalan di `http://localhost:8080`, lalu dari folder `frontend`:

```bash
flutter pub get
flutter devices
flutter run
```

Android Emulator menggunakan URL API default `http://10.0.2.2:8080/api`. Untuk perangkat Android fisik, ubah base URL di `lib/config/api_config.dart` ke alamat IP LAN komputer yang menjalankan backend.

## Build APK

```bash
flutter build apk --release
```

APK release tersedia di `build/app/outputs/flutter-apk/app-release.apk`. Build release membutuhkan endpoint HTTPS dan signing key sendiri untuk distribusi; konfigurasi signing debug yang ada hanya untuk pengujian.
