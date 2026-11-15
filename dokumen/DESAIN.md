# War-Rung — Design & UI/UX Guidelines (DESIGN.md)

**Versi:** 1.1.0  
**Tema Desain:** "Warung Klasik Interaktif (Terminal 3D & Animasi)"  
**Platform Target:** Windows 11 Terminal (CLI / TUI)  
**Referensi:** PRD.md (Versi 1.1.0), docs/POC-HASIL.md (Fase 0)

---

## 1. Filosofi Desain

Meskipun War-Rung berjalan di lingkungan antarmuka baris perintah (CLI), pengalaman pengguna (UX) tidak boleh kaku dan membosankan. Desain War-Rung mengusung tema **"Vintage & Tradisional"** yang dikemas secara **Interaktif** dengan sentuhan **Visual 3D (Pseudo-3D Text Art)**.

Tujuannya adalah memberikan nuansa keakraban warung tradisional Indonesia (ramah, membumi, hangat) sekaligus menyajikan antarmuka yang dinamis, responsif, dan memanjakan mata pengguna (pemilik warung/kasir) saat melakukan tugas harian.

## 2. Palet Warna (ANSI Terminal Colors)

Warna akan dicapai menggunakan _ANSI Escape Codes_ yang didukung oleh Windows 11 Terminal. Palet difokuskan pada warna-warna hangat dan membumi (Earthy Tones).

| Elemen                      | Kode Warna (ANSI)                          | Deskripsi Psikologis & Visual                             |
| :-------------------------- | :----------------------------------------- | :-------------------------------------------------------- |
| **Latar Belakang Utama**    | Default Terminal (Hitam/Gelap)             | Memberikan kontras tinggi agar teks bersinar.             |
| **Bordir & Bingkai (Kayu)** | `\x1b[33m` (Kuning / Cokelat Muda)         | Merepresentasikan kayu jati/bambu tradisional.            |
| **Teks Utama**              | `\x1b[37m` (Putih / Krem)                  | Untuk keterbacaan data dan menu.                          |
| **Aksen Sukses & Uang**     | `\x1b[32m` (Hijau Terang)                  | Digunakan untuk uang masuk, kembalian, notifikasi sukses. |
| **Aksen Peringatan & Bon**  | `\x1b[31m` (Merah / Bata)                  | Untuk peringatan stok habis, error, atau status piutang.  |
| **Highlight & Pilihan**     | `\x1b[43m\x1b[30m` (Teks Hitam, BG Kuning) | Efek "nyala" atau _hover_ saat menu dipilih.              |

> **Catatan implementasi:** kolom "Kode Warna" memakai notasi `\x1b` sebagai singkatan bacaan. Di runtime indk 1.4.0 literal `\x1b` tidak didukung — kode ditulis dengan `chr(27)`, misalnya `chr(27) + "[33m"` (lihat `docs/POC-HASIL.md` §2.3). Saat menu dipilih, gaya "nyala" dipasang pada baris pilihan aktif melalui render ulang (tanpa hover/kursor).

## 3. Gaya Visual "Pseudo-3D" & Tradisional (ASCII Art)

Karena berjalan di CLI, gaya 3D dan tradisional direpresentasikan menggunakan teknik manipulasi karakter _Box-drawing_ dan _Block elements_.

### 3.1. Efek 3D Pop-up (Panel & Dialog)

Setiap menu atau pop-up peringatan tidak hanya berbentuk kotak biasa, tetapi memiliki "bayangan" (shadow) di sisi kanan dan bawah menggunakan karakter blok tebal (`█`, `▓`, `▒`, `░`), memberikan ilusi bahwa panel tersebut mengambang (3D) di atas terminal.

**Contoh Dialog 3D:**

```text
  ╔══════════════════════════════╗
  ║    TRANSAKSI BERHASIL!       ║▒
  ║                              ║▒
  ║  Kembalian: Rp 15.000        ║▒
  ╚══════════════════════════════╝▒
   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
```

### 3.2. Motif Tradisional (Anyaman Bambu/Batik)

Garis pemisah (divider) tidak menggunakan tanda hubung biasa (`---`), melainkan menggunakan kombinasi karakter ASCII yang membentuk pola anyaman atau motif berulang bergaya tradisional.
Contoh Divider: `≈≈≈≈♦≈≈≈≈♦≈≈≈≈♦≈≈≈≈` atau `╬╬╬╬╬╬╬╬╬╬╬╬╬`

### 3.3. Header & Logo (Isometric ASCII)

Judul aplikasi di Menu Utama menggunakan ASCII Art bergaya Isometrik (3D) dengan font tebal (seperti _Slant_ atau _3D-ASCII_).

## 4. Sistem Animasi & Interaksi

Animasi dicapai dengan **redraw ulang layar** (bangun blok teks lengkap → bersihkan layar → cetak satu kali per aksi), bukan penyegaran kontinu. Redraw dilakukan hanya saat keadaan berubah agar tidak berkedip.

> Catatan PoC (`docs/POC-HASIL.md`): render warna ANSI terbukti terkirim; efektivitas clear-screen akan diverifikasi pada Fase 1. Flicker dihindari dengan mencetak layar sebagai satu blok tunggal, bukan baris-demi-baris.

### 4.1. Animasi Transisi & Loading

- **Animasi Koin Berputar (Loading Spinner):** *(terbukti PoC — `chr(13)` + `| / - \`)*
  Saat menyimpan data ke SQLite, tampil spinner `| / - \` berwarna emas dengan teks _"Menyimpan ke laci kasir..."_ yang ditimpa pada baris yang sama.
- **Typing Effect (Mesin Tik Klasik):** *(opsional, hemat waktu)*
  Pesan sapaan pembuka muncul huruf-demi-huruf dengan `henti()` singkat.
  _Contoh:_ `S e l a m a t   D a t a n g   d i   W a r   R u n g . . .`

### 4.2. Navigasi Menu Bernomor

Navigasi memakai **pilihan nomor** — pengguna mengetik nomor menu lalu `Enter` (runtime v1.4.0 tidak menyediakan pembacaan tombol tunggal/panah; lihat `docs/POC-HASIL.md`). Opsi valid ditandai warna aksen; input tidak valid memunculkan pesan ramah lalu meminta ulang tanpa merusak tampilan.

_Contoh State:_

```text
  WAR-RUNG — Teras Warung
  ≈≈≈≈♦≈≈≈≈♦≈≈≈≈♦≈≈≈≈♦≈≈≈≈
  [1] Masuk ke Kasir
  [2] Kelola Barang        ← pilihan aktif (Kuning + hitam)
  [3] Pelanggan & Piutang
  [4] Laporan Penjualan
  [5] Pengaturan

  [1-N] Pilih | [Enter] Konfirmasi | [0] Keluar
```

### 4.3. Notifikasi (Dialog Inline)

Jika stok menipis saat kasir memasukkan barang, muncul **dialog inline** bergaya panel 3D (§3.1) di tempat kejadian perkara; pengguna menekan `Enter` untuk menutup. Layout dibangun dari teks polos, warna dipasang setelahnya (PoC: `panjang()` menghitung karakter escape).

## 5. Rancangan Komponen Layar (Screen Flow)

### 5.1. Layar Pembuka (Splash Screen)

- **Visual:** Logo "War-Rung" dalam bentuk 3D ASCII, dikelilingi border bermotif anyaman bambu.
- **Animasi:** Teks "Membuka gembok warung..." dengan loading bar berupa karakter blok yang terisi perlahan `[██████░░░]` (redraw beberapa langkah dengan `henti()`).

### 5.2. Dashboard Utama (Teras Warung)

- Ditampilkan sebagai **satu blok teks** (dirangkai penuh, lalu dicetak sekali) berisi dua bagian:
    - **Atas — Menu Utama:** daftar menu bernomor (§4.2).
    - **Bawah — Papan Tulis/Chalkboard:** ringkasan hari ini (Total Penjualan Hari Ini, Barang Paling Laris, Piutang) dengan warna putih pudar, diperbarui setiap kali layar dirender ulang (bukan real-time kontinu).

### 5.3. Modul Kasir (Meja Transaksi)

- **Konsep:** Didesain menyerupai struk belanja fisik atau kalkulator warung lawas.
- **Tata Letak:**
    - Bagian atas: Input pencarian/baris (`input()`, berbasis Enter).
    - Bagian tengah: Tabel barang yang dibeli (lebar menyesuaikan lebar terminal terdekat).
    - Bagian bawah: Total ditulis besar (BIG ASCII FONTS) berwarna hijau agar mudah dibaca sekilas.
- **Interaksi:** Setiap kali barang ditambahkan, seluruh layar keranjang dirender ulang sebagai satu blok.

### 5.4. Modul Manajemen Barang & Bon (Gudang & Buku Kas)

- **Buku Kas 3D:** Daftar utang pelanggan ditampilkan dalam format buku. Terdapat visual tab "Halaman 1, Halaman 2" di bagian bawah layar.
- **Pencarian:** Cari pelanggan/barang dengan mengetik kata kunci lalu `Enter` (input berbasis baris), hasil disaring dan daftar dirender ulang.
- **Pembayaran cicilan:** pilih tagihan dari Buku Kas → masukkan nominal → konfirmasi; saat sisa utang 0, status berubah "lunas" dan ditandai hijau.

### 5.5. Modul Laporan Penjualan

- **Konsep:** Layar laporan memakai panel berbingkai ASCII + garis pembatas anyaman, konsisten dengan layar lain; angka keuangan disorot (omzet hijau tebal, piutang kuning).
- **Menu:** `[1]` Harian, `[2]` Mingguan (Senin–Minggu), `[3]` Bulanan, `[4]` Barang terlaris, `[5]` Ringkasan piutang, `[6]` Ekspor CSV, `[0]` Kembali — masing-masing layar berakhir dengan dialog `[Enter] kembali`.
- **Tata letak layar ringkasan:** baris label lebar 19 kolom (Periode, Total transaksi, Total omzet, Estimasi laba kotor, Piutang berjalan) → blok "Barang Terlaris" (No/Nama/Jml/Omzet) → blok "Daftar Transaksi" (kode/tanggal/total/status; status lunas hijau, bon kuning); mingguan/bulanan menambah "Rekap per Hari".
- **Ekspor:** submenu `[1-3]` menulis CSV ke folder `laporan/` (nama `laporan-<jenis>-<awal>-<akhir>.csv`), konfirmasi via dialog "Tersimpan: laporan/...".

### 5.6. Modul Pengaturan & Pemeliharaan

- **Menu:** `[1]` Informasi aplikasi, `[2]` Informasi & ubah warung, `[3]` Cadangkan database, `[4]` Pulihkan dari cadangan, `[0]` Kembali.
- **Tata letak:** baris label lebar 16 kolom (konsisten dengan layar ringkasan laporan); operasi berisiko (cadangkan/pulihkan) selalu diawali pertanyaan `[y/t]` dan diakhiri dialog panel 3D.
- **Form ubah warung:** nilai sekarang ditampilkan dulu, lalu tiap isian memakai pola `Enter = tetap` (isian kosong mempertahankan nilai lama); nama warung wajib terisi.
- **Pulihkan:** daftar cadangan ditampilkan terbaru-di-atas dengan nomor `[1..n]`; konfirmasi eksplisit menyebutkan bahwa **semua data saat ini akan diganti** — pesan penolakan (berkas bukan cadangan/hilang) tampil sebagai dialog ramah tanpa mengubah database.

## 6. Aksesibilitas & Ramah Pengguna

1. **Bahasa Manusia (Human-Centric Copywriting):**
   Tidak ada error sistematis seperti `Error: NullPointerException`. Pesan error diubah menjadi ramah, contoh:
    - "Waduh, stok barang ini sisa 0. Coba cek gudang dulu ya!"
    - "Uang tunai yang dibayar kurang dari total belanja, Bos."
2. **Bantuan Bawaan (Help Footer):**
   Di setiap layar selalu ada instruksi singkat di bagian paling bawah layar dengan warna redup.
   _Contoh:_ `[1-N] Pilih | [Enter] Konfirmasi | [0] Keluar`

## 7. Implementasi Teknis (Untuk Developer)

Aturan mengikat hasil PoC Fase 0 (`docs/POC-HASIL.md`, runtime indk 1.4.0):

1. **Tanpa modul `Konsol` / tombol tunggal:** modul tersebut tidak tersedia di v1.4.0. Navigasi = menu bernomor + `input()` baris penuh (§4.2).
2. **ANSI dibangun dengan `chr(27)`:** literal `\x1b` tidak didukung runtime. Kode warna ditulis, mis. `variabel ESC = chr(27)` lalu `ESC + "[32m"`.
3. **Layout dari teks polos, warna setelahnya:** `panjang()` menghitung karakter escape, sehingga perhitungan lebar kolom/padding selalu memakai teks tanpa warna; wrap warna baru menerapkan gaya.
4. **Render satu blok:** layar dibangun sebagai satu string teks-polos, dibersihkan dengan `ESC + "[2J" + ESC + "[H"`, lalu dicetak sekali — meminimalkan flicker tanpa posisi kursor absolut per baris.
5. **Pesan galat ramah:** galat database (kelas `GalatNilai`, pesan asli `SQLite: ...`) diterjemahkan di layer layanan menjadi copywriting human-readable (§6); log teknis dapat menyimpan pesan asli.
6. **Format angka manual:** `format()` tidak mendukung gaya `{:02d}`; gunakan pembungkus sendiri untuk Rupiah/ruang.
7. **Referensi:** seluruh perilaku yang diandalkan (spinner, `input()` pipe, hashing, tanggal) terdokumentasi di `docs/POC-HASIL.md` §2.
8. **Impor bentuk modern + `INDK_PATH`:** aplikasi selalu dijalankan dari **akar proyek** lewat launcher `warung.cmd` yang menetapkan `INDK_PATH=<akar proyek>`. Konvensi: dari modul mana pun boleh `impor konfigurasi` (modul akar) dan `impor inti.koneksi` (paket dotted → memuat `inti/koneksi.idk`, membind `koneksi`), lalu akses berkualifikasi `koneksi.buka_db()`; `dari konfigurasi impor PATH_DB` untuk seleksi nama. Bentuk legacy `impor "path"` tidak dipakai. Aturan resolusi & kegagalan: `docs/POC-HASIL.md` §2.6 — **kegagalan load di dalam modul = senyap exit 70**, maka bila keluar 70 tanpa pesan, jalankan modul yang dicurigai langsung untuk melihat galatnya.
9. **Berkas sumber UTF-8 tanpa BOM:** ditulis via `[System.IO.File]::WriteAllText($p, $c, (New-Object System.Text.UTF8Encoding($false)))` (BOM = `Kesalahan: Karakter tidak dikenal`).
