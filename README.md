# War-Rung

Aplikasi kasir & pengelolaan warung berbasis terminal (CLI) untuk Windows — dibangun
sepenuhnya dengan bahasa **[Indonesiaku Lang](https://github.com/teguh02/Indonesiaku-Lang)** v1.4.0 dan database **SQLite** lokal.

## Kebutuhan

- Windows 11 (atau lebih baru; tidak bergantung OS lain).
- Runtime `indk` sudah disertakan di `.tools/indk/indk-windows/indk.exe`
  (tidak perlu instalasi terpisah).

## Menjalankan

Dari akar proyek:

```bat
warung.cmd
```

Skrip `warung.cmd` menyiapkan `INDK_PATH`, mengaktifkan kode halaman UTF-8
(`chcp 65001`) supaya motif kotak & divider tampil benar, lalu menjalankan
`utama.idk`. Alternatif manual (dari akar proyek):

```bat
chcp 65001 >nul
set INDK_PATH=%CD%
.tools\indk\indk-windows\indk.exe utama.idk
```

Database otomatis dibuat di `data/War-Rung.db` saat pertama dijalankan
(skema dari `basis_data/skema.sql`, pengaturan awal dari `basis_data/seed.idk`).

## Menu Utama

| No  | Menu                | Isi                                                                                           |
| --- | ------------------- | --------------------------------------------------------------------------------------------- |
| 1   | Masuk ke Kasir      | Meja transaksi: cari barang, jumlah, diskon, tunai/bon, struk                                 |
| 2   | Kelola Barang       | Daftar/cari/tambah/ubah/nonaktif/hapus barang, stok masuk, penyesuaian, riwayat, stok menipis |
| 3   | Pelanggan & Piutang | Daftar/cari/tambah/ubah pelanggan, detail & riwayat, Buku Kas (bon), bayar cicilan            |
| 4   | Laporan Penjualan   | Harian/mingguan/bulanan, barang terlaris, ringkasan piutang, ekspor CSV ke `laporan/`         |
| 5   | Pengaturan          | Info aplikasi, info & ubah warung, cadangkan database (`cadangan/`), pulihkan dari cadangan   |

Navigasi: ketik nomor lalu `Enter`; `Enter` kosong = konfirmasi/lanjut; `0` = kembali/keluar.

## Pengujian

Dari akar proyek dengan `INDK_PATH` terpasang (lihat `warung.cmd`):

```bat
.tools\indk\indk-windows\indk.exe uji pengujian\uji_barang.idk
```

Atau semua fungsi uji dalam satu berkas (exit 0 = lulus):

```bat
for %f in (pengujian\uji_*.idk) do .tools\indk\indk-windows\indk.exe uji "%f"
```

Statis per berkas (0 temuan = bersih):

```bat
.tools\indk\indk-windows\indk.exe periksa utama.idk
```

Daftar berkas uji: `uji_fondasi`, `uji_barang`, `uji_kasir`, `uji_stok`,
`uji_piutang`, `uji_laporan`, `uji_pengaturan`, `uji_integritas`.

## Cadangan & Pemulihan

- Menu **[5] Pengaturan → [3] Cadangkan database** menulis snapshot ke
  `cadangan/War-Rung-<tanggal>-<waktu>.db` (SQLite `VACUUM INTO`, aplikasi tetap jalan).
- Menu **[4] Pulihkan dari cadangan** menampilkan daftar cadangan (terbaru di atas);
  seluruh isi database diganti secara atomik — data yang dibuat **sesudah** cadangan
  akan hilang. Konfirmasi `[y/t]` selalu diminta.
- Folder `cadangan/` dan `laporan/` tidak ikut ke git (lihat `.gitignore`).

## Dokumentasi

- `docs/PRD.md` — kebutuhan produk, business rules, struktur database, roadmap (Fase 0–6).
- `docs/DESAIN.md` — pedoman UI/UX terminal (warna ANSI, gaya pseudo-3D, tata letak layar).
- `docs/POC-HASIL.md` — temuan runtime Indonesiaku Lang v1.4.0 yang mengikat.

## Status

**Versi 1.0.0 — seluruh Fase 0–6 selesai.** Seluruh uji otomatis lulus
(59/59), `periksa` 0 temuan pada seluruh berkas `.idk`, skenario aplikasi
end-to-end lulus.
