# War-Rung — Product Requirements Document (PRD)

**Versi:** 1.0.0  
**Status:** Draft  
**Jenis Aplikasi:** Desktop CLI Application  
**Bahasa Pemrograman:** Indonesiaku Lang  
**Database:** SQLite  
**Platform Target:** Windows 11

---

## 1. Pendahuluan

### 1.1 Latar Belakang

Warung tradisional merupakan bagian penting dari aktivitas ekonomi masyarakat Indonesia. Dalam operasional sehari-hari, banyak warung masih menggunakan pencatatan manual untuk mengelola transaksi penjualan, persediaan barang, dan utang pelanggan.

War-Rung merupakan aplikasi pengelolaan operasional warung berbasis Command Line Interface (CLI) yang dirancang untuk membantu pemilik maupun penjaga warung mengelola aktivitas bisnis secara sederhana dan terstruktur.

Proyek ini juga dikembangkan sebagai eksperimen untuk mengeksplorasi kemampuan Indonesiaku Lang dalam membangun aplikasi bisnis yang memiliki business logic, pengelolaan database, validasi data, transaksi, dan pelaporan.

### 1.2 Tujuan Proyek

1. Membangun aplikasi operasional warung berbasis CLI.
2. Menggunakan Indonesiaku Lang sebagai bahasa utama seluruh business logic.
3. Mengimplementasikan operasi CRUD menggunakan SQLite.
4. Menguji kemampuan Object-Oriented Programming dan modularisasi.
5. Mengimplementasikan pengelolaan transaksi database.
6. Mengimplementasikan validasi input dan exception handling.
7. Menghasilkan aplikasi yang dapat digunakan secara lokal tanpa ketergantungan terhadap layanan cloud.

### 1.3 Target Pengguna

- Pemilik warung tradisional.
- Penjaga toko atau kasir.
- Pengelola usaha kecil.
- Developer yang ingin mempelajari kemampuan Indonesiaku Lang melalui proyek nyata.

## 2. Gambaran Produk

### 2.1 Deskripsi Produk

War-Rung adalah aplikasi manajemen warung sederhana yang menyediakan fasilitas pengelolaan barang, transaksi penjualan, persediaan, pelanggan, pencatatan utang, dan laporan penjualan.

Aplikasi dijalankan melalui terminal dengan sistem navigasi berbasis menu. Seluruh data operasional disimpan dalam database SQLite secara lokal.

### 2.2 Karakteristik Produk

- Berbasis Command Line Interface.
- Menggunakan Indonesiaku Lang sebagai bahasa pemrograman utama.
- Menggunakan SQLite sebagai database.
- Mendukung penyimpanan data secara lokal.
- Tidak membutuhkan koneksi internet untuk operasional dasar.
- Memiliki struktur kode modular.
- Menggunakan Rupiah sebagai satuan mata uang.

### 2.3 Ruang Lingkup

War-Rung dikembangkan sebagai aplikasi single-user untuk satu warung dengan fokus pada kebutuhan operasional dasar.

Proyek tidak mencakup integrasi layanan pembayaran eksternal, sinkronisasi cloud, aplikasi mobile, maupun sistem multi-cabang.

## 3. Kebutuhan Fungsional

### 3.1 Manajemen Barang

Sistem harus menyediakan fasilitas untuk mengelola seluruh barang yang dijual.

Fitur:

- Menambahkan barang baru.
- Menampilkan daftar barang.
- Melihat detail barang.
- Mengubah informasi barang.
- Menghapus atau menonaktifkan barang.
- Mencari barang berdasarkan nama atau SKU.
- Mengelola harga beli dan harga jual.
- Mengelola jumlah stok.
- Menentukan batas minimum stok.

Informasi barang meliputi ID, SKU, nama, harga beli, harga jual, jumlah stok, stok minimum, dan status aktif.

### 3.2 Sistem Kasir

Sistem harus menyediakan fasilitas untuk melakukan transaksi penjualan.

Fitur:

- Memilih barang berdasarkan SKU atau nama.
- Menambahkan barang ke keranjang.
- Mengubah jumlah barang.
- Menghapus barang dari keranjang.
- Menghitung subtotal.
- Memberikan diskon.
- Menghitung total pembayaran.
- Memproses pembayaran tunai.
- Menghitung uang kembalian.
- Memproses transaksi bon.
- Menyimpan riwayat transaksi.
- Menghasilkan informasi struk transaksi.

Setiap transaksi harus memiliki kode transaksi unik, tanggal, daftar barang, jumlah pembelian, subtotal, diskon, total pembayaran, dan status transaksi. Status transaksi dibatasi pada salah satu nilai `'lunas'`, `'bon'`, atau `'batal'`.

### 3.3 Manajemen Stok

Sistem harus menyediakan fasilitas untuk mengelola perubahan persediaan barang.

Fitur:

- Mencatat stok masuk.
- Melakukan penyesuaian stok.
- Melihat stok saat ini.
- Melihat riwayat perubahan stok.
- Menampilkan barang dengan stok minimum.
- Memperbarui stok secara otomatis setelah transaksi penjualan.

Setiap perubahan stok harus dicatat agar pengguna dapat mengetahui riwayat pergerakan persediaan.

### 3.4 Manajemen Pelanggan

Sistem harus menyediakan fasilitas untuk mengelola informasi pelanggan.

Fitur:

- Menambahkan pelanggan.
- Menampilkan daftar pelanggan.
- Mengubah informasi pelanggan.
- Mencari pelanggan.
- Melihat riwayat transaksi pelanggan.
- Melihat total utang pelanggan.

Informasi pelanggan meliputi ID, nama, nomor telepon, dan alamat.

### 3.5 Manajemen Bon dan Piutang

Sistem harus mendukung transaksi penjualan dengan pembayaran tertunda atau bon.

Fitur:

- Mencatat transaksi bon.
- Menghubungkan transaksi bon dengan pelanggan.
- Menampilkan daftar piutang.
- Melihat detail utang pelanggan.
- Mencatat pembayaran cicilan.
- Menampilkan riwayat pembayaran.
- Menghitung sisa utang secara otomatis.

Sistem harus memastikan pembayaran tidak melebihi jumlah utang yang masih tersisa.

### 3.6 Laporan Penjualan

Sistem harus menyediakan laporan untuk membantu pengguna memahami aktivitas penjualan.

Fitur:

- Laporan penjualan harian.
- Laporan penjualan mingguan (periode Senin–Minggu).
- Laporan penjualan bulanan.
- Total transaksi.
- Total omzet.
- Estimasi laba kotor.
- Daftar barang terlaris.
- Ringkasan piutang pelanggan.

Laporan harus menggunakan data transaksi yang tersimpan dalam database.

### 3.7 Pengaturan dan Pemeliharaan

Fitur:

- Melihat informasi aplikasi.
- Mengatur informasi warung.
- Melakukan backup database.
- Memulihkan database dari backup.
- Keluar dari aplikasi dengan aman.

## 4. Kebutuhan Non-Fungsional

### 4.1 Performa

Aplikasi harus dapat berjalan dengan baik pada perangkat Windows 11 dengan spesifikasi komputer kelas menengah atau lebih rendah.

Operasi database harus dilakukan secara efisien dan menghindari query yang tidak diperlukan.

### 4.2 Keandalan Data

Sistem harus menjaga konsistensi data menggunakan mekanisme transaksi SQLite.

Operasi penjualan harus bersifat atomik. Jika terjadi kegagalan pada salah satu proses penyimpanan, seluruh perubahan dalam transaksi tersebut harus dibatalkan.

### 4.3 Keamanan

- Seluruh query database harus menggunakan parameterized query.
- Input pengguna harus divalidasi.
- Foreign key SQLite harus diaktifkan.
- Database harus menjaga integritas relasi antartabel.
- Operasi yang dapat mengubah atau menghapus data harus memiliki validasi.

### 4.4 Maintainability

Kode aplikasi harus dipisahkan berdasarkan tanggung jawab masing-masing modul.

Business logic tidak boleh dicampur dengan kode tampilan CLI atau query database secara sembarangan.

### 4.5 Portabilitas

Aplikasi dirancang agar dapat dijalankan secara lokal selama runtime Indonesiaku Lang dan dependensi yang diperlukan tersedia.

## 5. Business Rules

### 5.1 Aturan Barang

- SKU harus unik.
- Nama barang wajib diisi.
- Harga beli tidak boleh negatif.
- Harga jual harus lebih besar dari nol.
- Stok tidak boleh negatif.
- Barang yang sudah memiliki riwayat transaksi tidak boleh dihapus secara permanen melalui operasi biasa.

### 5.2 Aturan Transaksi

- Transaksi harus memiliki minimal satu barang.
- Jumlah pembelian harus lebih besar dari nol.
- Stok harus mencukupi jumlah pembelian.
- Harga barang yang digunakan dalam transaksi harus disimpan sebagai snapshot pada `detail_transaksi` (meliputi `harga_satuan` dari harga jual dan `harga_beli` dari harga modal saat transaksi).
- Diskon tidak boleh melebihi subtotal.
- Pembayaran tunai harus mencukupi total transaksi.
- Transaksi bon harus memiliki pelanggan.
- Setiap transaksi harus memiliki kode unik.
- Pengurangan stok dan penyimpanan transaksi harus dilakukan secara atomik.

### 5.3 Aturan Pembayaran

- Pembayaran tidak boleh bernilai negatif.
- Pembayaran cicilan tidak boleh melebihi sisa utang.
- Sisa utang dihitung dengan rumus: `total − (dibayar + Σ pembayaran_bon.jumlah)` terhadap seluruh pembayaran yang sudah diterima.
- Status piutang berubah menjadi lunas ketika seluruh kewajiban telah dibayar.

### 5.4 Aturan Keuangan

- Seluruh nilai uang disimpan sebagai integer dalam satuan Rupiah.
- Perhitungan uang tidak menggunakan floating point.
- Omzet dihitung dari transaksi penjualan yang valid.
- Laba kotor dihitung berdasarkan selisih harga jual dan harga beli pada saat transaksi.

## 6. Struktur Database

War-Rung menggunakan SQLite dengan tujuh tabel utama.

### 6.1 Tabel barang

| Kolom        | Tipe    | Keterangan         |
| ------------ | ------- | ------------------ |
| id           | INTEGER | Primary Key        |
| sku          | TEXT    | Kode barang unik   |
| nama         | TEXT    | Nama barang        |
| harga_beli   | INTEGER | Harga modal        |
| harga_jual   | INTEGER | Harga jual         |
| stok         | INTEGER | Jumlah stok        |
| stok_minimum | INTEGER | Batas minimum stok |
| aktif        | INTEGER | Status barang      |

### 6.2 Tabel pelanggan

| Kolom   | Tipe    | Keterangan       |
| ------- | ------- | ---------------- |
| id      | INTEGER | Primary Key      |
| nama    | TEXT    | Nama pelanggan   |
| telepon | TEXT    | Nomor telepon    |
| alamat  | TEXT    | Alamat pelanggan |

### 6.3 Tabel transaksi

| Kolom        | Tipe    | Keterangan            |
| ------------ | ------- | --------------------- |
| id           | INTEGER | Primary Key           |
| kode         | TEXT    | Kode transaksi unik   |
| pelanggan_id | INTEGER | Foreign Key, nullable |
| tanggal      | TEXT    | Tanggal transaksi     |
| subtotal     | INTEGER | Total sebelum diskon  |
| diskon       | INTEGER | Potongan harga        |
| total        | INTEGER | Total akhir           |
| dibayar      | INTEGER | Pembayaran awal       |
| kembalian    | INTEGER | Uang kembalian        |
| status       | TEXT    | `'lunas'` / `'bon'` / `'batal'` |

### 6.4 Tabel detail_transaksi

| Kolom        | Tipe    | Keterangan           |
| ------------ | ------- | -------------------- |
| id           | INTEGER | Primary Key          |
| transaksi_id | INTEGER | Foreign Key          |
| barang_id    | INTEGER | Foreign Key          |
| nama_barang  | TEXT    | Snapshot nama barang |
| harga_satuan | INTEGER | Snapshot harga jual  |
| harga_beli   | INTEGER | Snapshot harga modal |
| jumlah       | INTEGER | Jumlah pembelian     |
| subtotal     | INTEGER | Total detail         |

### 6.5 Tabel pembayaran_bon

| Kolom        | Tipe    | Keterangan            |
| ------------ | ------- | --------------------- |
| id           | INTEGER | Primary Key           |
| transaksi_id | INTEGER | Foreign Key           |
| jumlah       | INTEGER | Nominal pembayaran    |
| tanggal      | TEXT    | Tanggal pembayaran    |
| catatan      | TEXT    | Keterangan pembayaran |

### 6.6 Tabel riwayat_stok

| Kolom        | Tipe    | Keterangan             |
| ------------ | ------- | ---------------------- |
| id           | INTEGER | Primary Key            |
| barang_id    | INTEGER | Foreign Key            |
| jenis        | TEXT    | Jenis perubahan        |
| jumlah       | INTEGER | Jumlah perubahan (bertanda; negatif = berkurang) |
| stok_sebelum | INTEGER | Stok sebelumnya        |
| stok_sesudah | INTEGER | Stok setelah perubahan |
| tanggal      | TEXT    | Tanggal perubahan      |
| keterangan   | TEXT    | Keterangan perubahan   |

### 6.7 Tabel pengaturan

| Kolom   | Tipe | Keterangan                          |
| ------- | ---- | ----------------------------------- |
| kunci   | TEXT | Primary Key, kunci pengaturan unik  |
| nilai   | TEXT | Nilai pengaturan                    |

Menyimpan pengaturan warung yang dapat diubah dari aplikasi (nama warung, alamat, catatan struk, dan sejenisnya). Konfigurasi teknis aplikasi (path database, banner) berada di `konfigurasi.idk` terpisah, bukan di tabel ini.

Seluruh tabel harus memiliki constraint dan relasi yang sesuai untuk menjaga integritas data.

## 7. Arsitektur Aplikasi

War-Rung menggunakan pendekatan Modular Monolith dengan pemisahan tanggung jawab berdasarkan layer.

### 7.1 Presentation Layer

Bertanggung jawab terhadap interaksi pengguna melalui terminal.

Komponen:

- Menu utama.
- Form input.
- Tampilan daftar barang.
- Tampilan transaksi.
- Tampilan laporan.
- Formatting output.

### 7.2 Business Logic Layer

Bertanggung jawab terhadap seluruh aturan bisnis aplikasi.

Komponen:

- Manajemen barang.
- Pengelolaan kasir.
- Manajemen stok.
- Manajemen pelanggan.
- Manajemen bon.
- Pengolahan laporan.

### 7.3 Data Access Layer

Bertanggung jawab terhadap komunikasi dengan SQLite.

Komponen:

- Database connection.
- Repository.
- Query database.
- Transaction management.
- Data mapping.

### 7.4 Database Layer

Menggunakan SQLite sebagai penyimpanan data utama dengan nama database `data/War-Rung.db`.

## 8. Teknologi

| Komponen              | Teknologi              |
| --------------------- | ---------------------- |
| Bahasa pemrograman    | Indonesiaku Lang       |
| Ekstensi source code  | .idk                   |
| Runtime               | indk 1.4.0            |
| Database              | SQLite                 |
| Antarmuka             | Command Line Interface |
| Format backup         | Database SQLite        |
| Ekspor laporan        | CSV                    |
| Format konfigurasi    | JSON                   |
| Sistem operasi target | Windows 11             |
| Version control       | Git                    |

Seluruh business logic harus ditulis menggunakan Indonesiaku Lang. Bahasa lain tidak boleh digunakan sebagai pengganti implementasi fitur utama.

## 9. Struktur Direktori

```text
War-Rung/
├── utama.idk
├── konfigurasi.idk
├── warung.cmd
├── inti/
├── model/
├── repositori/
├── layanan/
├── tampilan/
├── basis_data/
│   ├── skema.sql
│   └── seed.idk
├── pengujian/
├── data/
├── cadangan/
├── docs/
├── README.md
└── .gitignore
```

Setiap direktori memiliki tanggung jawab tersendiri dan tidak boleh saling mengambil alih fungsi modul lain.

## 10. Roadmap Pengembangan

### Fase 0 — Language Exploration

Melakukan pengujian kemampuan Indonesiaku Lang sebelum implementasi aplikasi.

Aktivitas:

- Instalasi dan konfigurasi runtime.
- Eksperimen sintaks.
- Pengujian OOP.
- Pengujian import modul.
- Pengujian SQLite CRUD.
- Pengujian parameterized query.
- Pengujian transaksi database.
- Pengujian exception handling.

Hasil: Proof of Concept SQLite menggunakan Indonesiaku Lang — **selesai** (8 kelompok PoC, seluruhnya exit 0; temuan dan keputusan teknis terdokumentasi di `docs/POC-HASIL.md`).

### Fase 1 — Project Foundation

Aktivitas:

- Membuat struktur direktori.
- Membuat konfigurasi aplikasi.
- Membuat koneksi database.
- Membuat seluruh tabel.
- Membuat sistem inisialisasi database.
- Membuat menu utama CLI.
- Membuat error handling dasar.

Hasil: Fondasi aplikasi War-Rung — **selesai** (uji fondasi 5/5 lulus).

### Fase 2 — Product Management

Aktivitas:

- Implementasi CRUD barang.
- Validasi SKU.
- Pencarian barang.
- Pengelolaan harga.
- Pengelolaan stok awal.

Hasil: Modul manajemen barang — **selesai** (uji barang 8/8 lulus).

### Fase 3 — Cashier System

Aktivitas:

- Implementasi keranjang belanja.
- Perhitungan subtotal.
- Perhitungan diskon.
- Pembayaran tunai.
- Perhitungan kembalian.
- Penyimpanan transaksi.
- Pengurangan stok otomatis.
- Transaction commit dan rollback.

Hasil: Sistem kasir berfungsi — **selesai** (uji kasir 10/10 lulus; tunai sesuai §10, bon dituntaskan Fase 4).

### Fase 4 — Inventory and Customer Debt

Aktivitas:

- Riwayat stok.
- Stok masuk.
- Penyesuaian stok.
- Manajemen pelanggan.
- Transaksi bon.
- Pembayaran cicilan.
- Perhitungan sisa piutang.

Hasil: Modul persediaan dan piutang — **selesai** (uji stok 8/8 + piutang 8/8; seluruh uji 39/39 lulus, periksa 0 temuan, skenario aplikasi end-to-end lulus: stok masuk/riwayat/menipis → tambah pelanggan → bon → cicilan 4.000 → pelunasan).

### Fase 5 — Reporting

Aktivitas:

- Laporan harian.
- Laporan mingguan.
- Laporan bulanan.
- Perhitungan omzet.
- Estimasi laba kotor.
- Barang terlaris.
- Ekspor laporan CSV.

Hasil: Modul laporan — **selesai** (uji laporan 9/9; seluruh uji 48/48 lulus, periksa 0 temuan, skenario aplikasi end-to-end lulus: 2 transaksi lunas+bon → laporan harian/mingguan/bulanan → barang terlaris → ringkasan piutang → ekspor 3 berkas CSV).

### Fase 6 — Testing and Release

Aktivitas:

- Pengujian seluruh modul.
- Pengujian integritas database.
- Pengujian transaksi gagal.
- Pengujian validasi input.
- Pengujian backup dan restore.
- Penyempurnaan dokumentasi.
- Persiapan release.

Hasil: War-Rung versi 1.0.0 — **selesai** (modul Pengaturan & Pemeliharaan: info aplikasi, info/ubah warung, cadangkan `VACUUM INTO`, pulihkan atomik; uji pengaturan 5/5 + integritas 6/6; seluruh uji 59/59 lulus, periksa 0 temuan, skenario aplikasi end-to-end lulus; dokumentasi instalasi & penggunaan di `README.md`).

## 11. Pengujian

Pengujian dilakukan terhadap dua aspek utama, yaitu fungsionalitas aplikasi dan kemampuan Indonesiaku Lang.

### 11.1 Application Testing

Skenario pengujian:

- SKU duplikat harus ditolak.
- Harga negatif harus ditolak.
- Stok tidak mencukupi harus menggagalkan transaksi.
- Pembayaran tunai yang kurang harus ditolak.
- Transaksi bon tanpa pelanggan harus ditolak.
- Pembayaran cicilan melebihi utang harus ditolak.
- Barang yang tidak ditemukan harus ditangani dengan benar.
- Kegagalan database harus ditangani.
- Kegagalan transaksi harus menjalankan rollback.
- Riwayat transaksi harus tetap konsisten ketika informasi barang berubah.
- Laporan harian/mingguan/bulanan harus mengecualikan transaksi berstatus batal.
- Rentang laporan: awal inklusif, akhir eksklusif (harian = hari ini, mingguan = Senin–minggu berjalan, bulanan = bulan berjalan).
- Ekspor CSV harus menghasilkan berkas di folder `laporan/` berisi blok detail + ringkasan yang sesuai periode.
- Cadangan database harus menghasilkan berkas yang bisa dipulihkan kembali (uji segitiga: data sebelum cadangan balik, data sesudah cadangan hilang).
- Pemulihan dari berkas yang bukan cadangan War-Rung harus ditolak dengan pesan ramah tanpa merusak database.

### 11.2 Language Capability Testing

Kemampuan Indonesiaku Lang yang akan dievaluasi:

- Object-Oriented Programming.
- Modularisasi dan import.
- Operasi SQLite.
- Database transaction.
- Exception handling.
- JSON processing.
- CSV processing.
- Collections dan manipulasi data.
- Date and time processing.
- CLI interaction.

Hasil pengujian dapat digunakan sebagai dokumentasi pengalaman pengembangan aplikasi menggunakan Indonesiaku Lang.

## 12. Definition of Done

War-Rung versi 1.0.0 dianggap selesai apabila:

- Seluruh fitur inti MVP sudah berjalan.
- Business logic menggunakan Indonesiaku Lang.
- Database SQLite berjalan secara lokal.
- CRUD barang berfungsi.
- Transaksi penjualan berfungsi.
- Stok diperbarui otomatis.
- Transaksi bon dapat dicatat.
- Pembayaran cicilan dapat diproses.
- Laporan penjualan dapat ditampilkan.
- Mekanisme rollback berhasil diuji.
- Backup dan restore database berhasil diuji.
- Dokumentasi instalasi dan penggunaan tersedia.
- Tidak terdapat masalah kritis yang merusak integritas data.

## 13. Batasan dan Risiko

### 13.1 Keterbatasan Bahasa

Indonesiaku Lang merupakan bahasa pemrograman yang relatif baru. Beberapa kemampuan runtime atau pustaka standar mungkin memiliki keterbatasan atau perbedaan implementasi.

Mitigasi:

- Melakukan eksplorasi sebelum implementasi fitur.
- Membuat Proof of Concept untuk setiap kemampuan penting.
- Mengacu pada dokumentasi resmi dan implementasi runtime.
- Menghindari asumsi terhadap API yang belum diverifikasi.
- Hasil PoC Fase 0 (termasuk daftar API yang tidak ada dan perilaku yang tidak sesuai panduan) tercatat di `docs/POC-HASIL.md` dan menjadi rujukan mengikat.

### 13.2 Integritas Database

Kesalahan pengelolaan transaksi dapat menyebabkan ketidaksesuaian antara data penjualan dan stok.

Mitigasi:

- Menggunakan SQLite transaction.
- Mengaktifkan foreign key.
- Menggunakan constraint.
- Menguji rollback.
- Menyediakan backup database.

### 13.3 Keterbatasan CLI

Antarmuka terminal memiliki keterbatasan dalam menyajikan informasi dibandingkan aplikasi GUI.

Mitigasi:

- Menggunakan format tabel yang konsisten.
- Menyediakan navigasi menu yang sederhana.
- Memberikan pesan kesalahan yang jelas.
- Memisahkan tampilan berdasarkan fungsi.

## 14. Kriteria Keberhasilan Proyek

Proyek dinyatakan berhasil apabila War-Rung dapat menjalankan operasional dasar warung secara lokal menggunakan Indonesiaku Lang, seluruh data tersimpan dengan konsisten, dan fitur utama dapat digunakan tanpa ketergantungan terhadap bahasa pemrograman lain untuk menjalankan business logic.

Selain menghasilkan aplikasi yang berfungsi, proyek ini diharapkan memberikan gambaran nyata mengenai kemampuan, kelebihan, keterbatasan, serta pengalaman penggunaan Indonesiaku Lang dalam pengembangan perangkat lunak berbasis database.

---

**Dokumen:** PRD.md  
**Proyek:** War-Rung  
**Versi Dokumen:** 1.1.0  
**Status:** Final — Fase 0–6 selesai, War-Rung versi 1.0.0 (seluruh uji 59/59 lulus, periksa 0 temuan, skenario aplikasi lulus, dokumentasi `README.md` tersedia)
