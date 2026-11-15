# War-Rung

Aplikasi kasir & pengelolaan warung berbasis terminal (CLI) untuk Windows — dibangun sepenuhnya dengan bahasa **[Indonesiaku Lang](https://github.com/teguh02/Indonesiaku-Lang)** v1.4.0 dan database **SQLite** lokal.

## 📋 Daftar Isi

- [Kebutuhan](#kebutuhan)
- [Menjalankan Aplikasi](#menjalankan-aplikasi)
- [Struktur Proyek](#struktur-proyek)
- [Fitur Utama](#fitur-utama)
- [Pengujian](#pengujian)
- [Cadangan & Pemulihan](#cadangan--pemulihan)
- [Dokumentasi](#dokumentasi)
- [Status Pengembangan](#status-pengembangan)

## ⚙️ Kebutuhan

- **OS:** Windows 11 (atau lebih baru)
- **Runtime:** `indk` sudah disertakan di `.tools/indk/indk-windows/indk.exe` (tidak perlu instalasi terpisah)
- **Database:** SQLite (otomatis dibuat saat pertama dijalankan)

## 🚀 Menjalankan Aplikasi

### Cara Cepat

Dari akar proyek, jalankan:

```bat
warung.cmd
```

### Manual

Jika ingin menjalankan secara manual:

```bat
chcp 65001 >nul
set INDK_PATH=%CD%
.tools\indk\indk-windows\indk.exe utama.idk
```

> **Catatan:** Skrip `warung.cmd` otomatis menyiapkan `INDK_PATH`, mengaktifkan kode halaman UTF-8 (`chcp 65001`) agar tampilan kotak & divider terlihat benar, lalu menjalankan `utama.idk`.

### Inisialisasi Database

Database otomatis dibuat di `data/War-Rung.db` saat pertama dijalankan dengan:

- Skema dari `basis_data/skema.sql`
- Data awal dari `basis_data/seed.idk`

## 📁 Struktur Proyek

```
War-Rung/
├── .tools/                      # Runtime & tools
│   └── indk/
│       └── indk-windows/        # Indonesiaku Lang compiler & runtime
│           ├── indk.exe         # Executable utama
│           ├── pustaka/         # Pustaka standar (22 modul)
│           └── examples/        # Contoh kode (115+ file)
│
├── basis_data/                  # Database setup
│   ├── skema.sql               # Schema database
│   └── seed.idk                # Data awal
│
├── inti/                        # Core utilities
│   ├── format.idk              # Format & validasi
│   ├── galat.idk               # Error handling
│   ├── kalender.idk            # Date/time utilities
│   ├── koneksi.idk             # Database connection
│   ├── papan.idk               # UI components & layout
│   └── pesan.idk               # Messages & notifications
│
├── model/                       # Data models
│   ├── barang.idk              # Product model
│   └── pelanggan.idk           # Customer model
│
├── repositori/                  # Data access layer
│   ├── barang.idk              # Product repository
│   ├── bon.idk                 # Transaction repository
│   ├── laporan.idk             # Report repository
│   ├── pelanggan.idk           # Customer repository
│   ├── pengaturan.idk          # Settings repository
│   └── transaksi.idk           # Transaction repository
│
├── layanan/                     # Business logic layer
│   ├── barang.idk              # Product services
│   ├── bon.idk                 # Transaction services
│   ├── kasir.idk               # Cashier services
│   ├── laporan.idk             # Report services
│   ├── pelanggan.idk           # Customer services
│   └── pengaturan.idk          # Settings services
│
├── tampilan/                    # Presentation layer (Views)
│   ├── dasar.idk               # Base view components
│   ├── barang.idk              # Product views
│   ├── kasir.idk               # Cashier views
│   ├── laporan.idk             # Report views
│   ├── pelanggan.idk           # Customer views
│   └── pengaturan.idk          # Settings views
│
├── pengujian/                   # Test suite
│   ├── poc/                    # Proof of concept tests
│   ├── uji_fondasi.idk         # Foundation tests
│   ├── uji_barang.idk          # Product tests
│   ├── uji_kasir.idk           # Cashier tests
│   ├── uji_stok.idk            # Stock tests
│   ├── uji_piutang.idk         # Receivables tests
│   ├── uji_laporan.idk         # Report tests
│   ├── uji_pengaturan.idk      # Settings tests
│   └── uji_integritas.idk      # Integrity tests
│
├── data/                        # Runtime data
│   └── War-Rung.db             # SQLite database (auto-generated)
│
├── cadangan/                    # Database backups (gitignored)
├── laporan/                     # Generated reports (gitignored)
├── dokumen/                     # Documentation
│   ├── PRD.md                  # Product requirements
│   ├── DESAIN.md               # UI/UX design guidelines
│   └── POC-HASIL.md            # POC findings
│
├── utama.idk                    # Main application entry
├── konfigurasi.idk             # Configuration
└── warung.cmd                   # Launcher script
```

## 💡 Fitur Utama

### Menu Aplikasi

|  No   | Menu                    | Fitur                                                                                                                            |
| :---: | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **1** | **Masuk ke Kasir**      | • Pencarian barang real-time<br>• Input jumlah & diskon per item<br>• Transaksi tunai/bon<br>• Cetak struk                       |
| **2** | **Kelola Barang**       | • CRUD barang (tambah/ubah/hapus)<br>• Manajemen stok (masuk/penyesuaian)<br>• Monitor stok menipis<br>• Riwayat pergerakan stok |
| **3** | **Pelanggan & Piutang** | • CRUD pelanggan<br>• Buku kas piutang<br>• Pembayaran cicilan<br>• Riwayat transaksi pelanggan                                  |
| **4** | **Laporan Penjualan**   | • Laporan harian/mingguan/bulanan<br>• Analisis barang terlaris<br>• Ringkasan piutang<br>• Ekspor CSV ke folder `laporan/`      |
| **5** | **Pengaturan**          | • Info aplikasi & warung<br>• Konfigurasi warung<br>• Backup database (folder `cadangan/`)<br>• Restore dari backup              |

### Navigasi

- Ketik **nomor menu** lalu tekan `Enter`
- Tekan `Enter` kosong untuk konfirmasi/lanjut
- Ketik **0** untuk kembali/keluar

### Arsitektur

Aplikasi menggunakan **layered architecture** dengan pemisahan yang jelas:

```
Tampilan (Views) → Layanan (Services) → Repositori (Repository) → Database
      ↓                    ↓                    ↓
  UI Logic         Business Logic        Data Access Layer
```

- **Inti:** Utilities bersama (format, error handling, UI components, date/time)
- **Model:** Data models & struktur
- **Repositori:** Data access & query layer
- **Layanan:** Business logic & validasi
- **Tampilan:** User interface & presentation layer

## 🧪 Pengujian

### Menjalankan Test Suite

Pastikan `INDK_PATH` sudah terpasang (otomatis jika menggunakan `warung.cmd`):

#### Test Individual

```bat
.tools\indk\indk-windows\indk.exe uji pengujian\uji_barang.idk
```

#### Semua Test Sekaligus

```bat
for %f in (pengujian\uji_*.idk) do .tools\indk\indk-windows\indk.exe uji "%f"
```

#### Static Analysis

```bat
.tools\indk\indk-windows\indk.exe periksa utama.idk
```

### Daftar Test Suite

| Test File            | Coverage                         |
| -------------------- | -------------------------------- |
| `uji_fondasi.idk`    | Core utilities & foundation      |
| `uji_barang.idk`     | Product management & CRUD        |
| `uji_kasir.idk`      | Cashier & transaction processing |
| `uji_stok.idk`       | Stock management & adjustments   |
| `uji_piutang.idk`    | Receivables & payment tracking   |
| `uji_laporan.idk`    | Report generation & exports      |
| `uji_pengaturan.idk` | Settings & configuration         |
| `uji_integritas.idk` | Data integrity & constraints     |

**Total:** 59 test cases — semua lulus ✅

## 💾 Cadangan & Pemulihan

### Backup Database

Menu **[5] Pengaturan → [3] Cadangkan database**

- Membuat snapshot ke folder `cadangan/` dengan nama `War-Rung-<tanggal>-<waktu>.db`
- Menggunakan SQLite `VACUUM INTO` (atomik & konsisten)
- Aplikasi tetap berjalan selama proses backup

### Restore Database

Menu **[5] Pengaturan → [4] Pulihkan dari cadangan**

- Menampilkan daftar backup (terbaru di atas)
- Restore dilakukan secara atomik
- ⚠️ **Peringatan:** Data yang dibuat **setelah** tanggal backup akan hilang
- Konfirmasi `[y/t]` selalu diminta sebelum restore

> **Catatan:** Folder `cadangan/` dan `laporan/` tidak disimpan ke git (lihat `.gitignore`)

## 📚 Dokumentasi

| File                   | Deskripsi                                                                |
| ---------------------- | ------------------------------------------------------------------------ |
| `dokumen/PRD.md`       | Product Requirements Document — business rules, database schema, roadmap |
| `dokumen/DESAIN.md`    | UI/UX Design Guidelines — warna ANSI, gaya pseudo-3D, layout             |
| `dokumen/POC-HASIL.md` | Proof of Concept Findings — runtime behavior & constraints               |

## 🎯 Status Pengembangan

**Versi:** 1.0.0  
**Status:** ✅ Production Ready

### Milestone Tercapai

- ✅ **Fase 0:** Setup project & infrastruktur
- ✅ **Fase 1:** Database schema & koneksi
- ✅ **Fase 2:** CRUD Barang & Pelanggan
- ✅ **Fase 3:** Kasir & transaksi
- ✅ **Fase 4:** Laporan penjualan
- ✅ **Fase 5:** Backup & restore
- ✅ **Fase 6:** Testing & polish

### Quality Metrics

- **Test Coverage:** 59/59 test cases passed (100%)
- **Static Analysis:** 0 issues found
- **End-to-End Tests:** All scenarios passed
- **Code Quality:** All `.idk` files verified
