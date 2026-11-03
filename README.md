# Qalamku — Aplikasi Pembelajaran Iqro & Penilaian Otomatis Menulis Hijaiyah untuk Anak

Prototipe Flutter yang mengikuti test case `RG_001` s.d. `KU_009` dan desain splash/logo Qalamku.

## Cara menjalankan

Folder ini hanya berisi kode Dart (`lib/`), `pubspec.yaml`, aset, dan tes. Folder platform
(`android/`, `ios/`) dibuat oleh Flutter:

```bash
cd qalamku
flutter create . --org com.qalamku --project-name qalamku   # membuat android/ ios/ dll. (file lib/ tidak ditimpa)
flutter pub get
flutter run
```

Disarankan Flutter >= 3.24 (memakai `PopScope.onPopInvokedWithResult`).

### Pengaturan platform (wajib sekali saja)

**Android** — `android/app/src/main/AndroidManifest.xml`, di dalam `<manifest>`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<queries>
  <intent><action android:name="android.intent.action.TTS_SERVICE" /></intent>
</queries>
```
`android/app/build.gradle(.kts)` → `minSdk = 21` (atau lebih tinggi).

**iOS** — `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Qalamku memakai kamera untuk memotret tulisan hijaiyah anak.</string>
```

## Struktur folder

```
qalamku/
├── pubspec.yaml                 dependensi & aset
├── analysis_options.yaml        aturan lint
├── assets/images/qalamku_logo.png   logo dari desain splash
├── lib/
│   ├── main.dart                titik masuk, memuat sesi & progres
│   ├── app.dart                 MaterialApp + tema
│   ├── core/
│   │   ├── theme/               app_colors.dart, app_theme.dart
│   │   ├── constants/           hijaiyah.dart (28 huruf, harakat)
│   │   └── utils/               validators.dart
│   ├── models/                  user_profile, quiz_question, writing_target
│   ├── data/                    iqro_data, quiz_bank, writing_data (konten belajar)
│   ├── services/                tts_service, handwriting_scorer
│   ├── providers/               auth_provider, progress_provider (state)
│   ├── widgets/                 komponen UI yang dipakai ulang
│   └── screens/
│       ├── splash_screen.dart
│       ├── auth/                login, register, verify_email, account_created, forgot_password
│       ├── dashboard/           dashboard_screen
│       ├── iqro/                jilid_list, jilid_detail, iqro_reader
│       ├── writing/             writing_home, single_levels, compound_levels,
│       │                        writing_level, camera_capture, writing_result, level_complete
│       └── quiz/                quiz_map, quiz_play, quiz_result
└── test/app_logic_test.dart     unit test validasi, kuis, data menulis, bintang
```

## Pemetaan test case → file

| Test case | Layar utama |
|---|---|
| RG_001 Registrasi | `auth/register_screen.dart` |
| VE_002 Verifikasi email | `auth/verify_email_screen.dart`, `auth/account_created_screen.dart` |
| LG_003 Login | `auth/login_screen.dart`, `auth/forgot_password_screen.dart` |
| DB_004 Dashboard | `dashboard/dashboard_screen.dart` |
| IQ_005 Pilih jilid | `iqro/jilid_list_screen.dart`, `iqro/jilid_detail_screen.dart` |
| IQ_006 Halaman baca | `iqro/iqro_reader_screen.dart` |
| MH_007 Huruf satuan | `writing/writing_home`, `single_levels`, `writing_level`, `camera_capture`, `writing_result` |
| MG_008 Huruf gabungan | `writing/compound_levels`, `writing_level`, `level_complete` |
| KU_009 Kuis | `quiz/quiz_map`, `quiz_play`, `quiz_result` |

## Catatan penting / keterbatasan

1. **Akun & email masih simulasi.** `AuthProvider` menyimpan akun di perangkat (SharedPreferences) dan
   menampilkan kode verifikasi 6 angka lewat SnackBar. Untuk produksi, ganti isi method di `auth_provider.dart`
   dengan Firebase Auth / API server — layarnya tidak perlu diubah.
2. **Penilaian tulisan memakai heuristik offline** (`services/handwriting_scorer.dart`): menghitung titik, ukuran, posisi,
   dan ketebalan goresan. Cukup untuk demo alur, tapi BUKAN pengenalan huruf yang sebenarnya. Untuk akurasi nyata,
   latih model (mis. TFLite) dan ganti fungsi `_analyze`.
3. **Suara** memakai Text-to-Speech perangkat (bahasa Arab). Pastikan paket suara Arab terpasang. Bila punya
   rekaman suara guru, ganti `services/tts_service.dart` dengan audio player.
4. **Data awal akun baru** diisi sesuai data uji (12 bintang, menulis Level 4, kuis Level 7). Matikan di
   `ProgressProvider.seedDemoProgress = false`.
5. Konten Jilid 1 hal. 2–30, Jilid 2 hal. 2–20, dan kuis selain Level 7 dibuat otomatis sebagai kerangka;
   ganti dengan materi Iqro resmi di `data/iqro_data.dart` dan `data/quiz_bank.dart`.
6. Perbaikan dari sheet *bug monitoring* sudah diterapkan sejak awal: tombol Verifikasi nonaktif sampai 6 angka,
   tautan "Kirim ulang kode" abu-abu saat hitung mundur, alif berfathah konsisten, bar "Suara" ikut kartu tersorot,
   layar "Level N selesai!" sesuai level & bintang, kolom bunyi soal mencocokkan diacak, contoh Huruf Gabungan = ب + ت,
   tanda baris tidak keluar kartu, dan "apa‑apa" tidak terpotong.
7. Kode belum dikompilasi di lingkungan pembuatnya (Flutter tidak terpasang di sana), jadi kemungkinan ada
   peringatan/error kecil saat pertama `flutter run` — kirim pesan error-nya ke saya untuk diperbaiki.
