# Mobile Banking Coding Test — Backend Spring Boot + Frontend Flutter

Implementasi berdasarkan `ITOBC_Full_Stack_Engineer_Coding_Test_Mobile_Apps.pdf`.

## Fitur yang dibuat

- Login username/password dengan JWT.
- Saldo rekening milik user yang sedang login.
- Transfer antar rekening dalam bank yang sama (`transfer-overbooking`).
- Riwayat transaksi dan detail transaksi.
- Validasi input, pengecekan saldo, rekening tujuan, dan penanganan error.
- Database H2 in-memory dengan data demo.
- Flutter UI: Login, Home, Transfer, Transaction History, Transaction Detail.
- Integrasi API nyata dari Flutter ke Spring Boot; tidak menggunakan mock data di frontend.

> Catatan: ini adalah starter project untuk coding test, bukan sistem perbankan produksi. Sebelum produksi perlu menambahkan audit trail, idempotency key, rate limiting, pengamanan secret, observability, dan kontrol keamanan tambahan.

## Struktur project

```text
mobile-banking-test-khoerul/
├── backend/     # Java 17, Spring Boot, Spring Security, H2
└── frontend/    # Flutter
```

## 1. Persyaratan perangkat

- Java JDK 17+
- Maven 3.9+ (atau gunakan Maven Wrapper jika ditambahkan)
- Flutter SDK stable
- Android Studio + Android SDK untuk menjalankan Android emulator/device
- Git (opsional)

Verifikasi instalasi:

```bash
java -version
mvn -version
flutter --version
flutter doctor
```

## 2. Menjalankan backend

Masuk ke folder backend:

```bash
cd backend
mvn spring-boot:run
```

Backend berjalan di `http://localhost:8080`.

H2 Console (development only): `http://localhost:8080/h2-console`
- JDBC URL: `jdbc:h2:mem:bankdb`
- Username: `sa`
- Password: kosong

### Build dan test backend

```bash
cd backend
mvn test
mvn clean package
java -jar target/mobile-banking-backend-1.0.0.jar
```

### Akun demo

| Username | Password | Rekening | Saldo awal |
|---|---|---|---:|
| `umam` | `Password123!` | `1000000001` | Rp10.000.000 |
| `siti` | `Password123!` | `1000000002` | Rp5.000.000 |

Data demo diinisialisasi otomatis saat aplikasi backend mulai. Karena menggunakan H2 in-memory, data akan kembali ke saldo awal setelah backend restart.

## 3. Menjalankan frontend Flutter

Buka terminal kedua:

```bash
cd frontend
flutter pub get
flutter run
```

### Konfigurasi base URL API

Edit `frontend/lib/config/api_config.dart`:

- Android Emulator: `http://10.0.2.2:8080/api`
- iOS Simulator: `http://localhost:8080/api`
- Flutter Web / desktop pada komputer yang sama: `http://localhost:8080/api`
- Perangkat Android fisik: gunakan IP LAN komputer yang menjalankan backend, misalnya `http://192.168.1.10:8080/api`. Pastikan kedua perangkat di jaringan yang sama dan firewall mengizinkan port `8080`.

Backend memakai HTTP untuk development. Untuk perangkat fisik, Android dapat memblokir cleartext HTTP pada konfigurasi tertentu; gunakan HTTPS atau konfigurasi development yang sesuai jika diperlukan.

## 4. API

Semua endpoint di bawah selain login memerlukan header `Authorization: Bearer <token>`.

### Login

`POST /api/auth/login`

```json
{
  "username": "umam",
  "password": "Password123!"
}
```

Response:

```json
{
  "token": "<jwt>",
  "tokenType": "Bearer",
  "username": "umam",
  "fullName": "Khoerul Umam",
  "accountNumber": "1000000001"
}
```

### Saldo

`GET /api/accounts/balance`

### Transfer

`POST /api/transfers/overbooking`

```json
{
  "targetAccountNumber": "1000000002",
  "amount": 100000,
  "description": "Transfer demo"
}
```

`amount` harus lebih besar dari 0. Transfer ditolak jika saldo tidak cukup, rekening tujuan tidak ditemukan, atau rekening tujuan sama dengan rekening asal.

### Riwayat transaksi

`GET /api/transactions?page=0&size=20`

### Detail transaksi

`GET /api/transactions/{id}`

## 5. Contoh pengujian API dengan curl

```bash
# Login
curl -X POST http://localhost:8080/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"username":"umam","password":"Password123!"}'

# Setelah mendapatkan token:
curl http://localhost:8080/api/accounts/balance \
  -H 'Authorization: Bearer PASTE_TOKEN_HERE'
```

## 6. Catatan implementasi

- Password demo disimpan sebagai BCrypt hash, bukan plaintext.
- JWT secret di `application.properties` hanya untuk local development; ganti dengan secret kuat dari environment variable sebelum deployment.
- Transfer debit/kredit berjalan dalam satu transaksi database.
- Untuk kebutuhan tes, transfer langsung tercatat sebagai transaksi sukses.
- Tidak ada integrasi ke core banking/payment network sungguhan; ini simulasi transfer antar rekening pada database lokal.
- Simpan token di secure storage untuk penggunaan produksi (misalnya `flutter_secure_storage`), bukan sekadar memori aplikasi.
