-- basis_data/skema.sql — Tujuh tabel inti War-Rung (PRD §6).
-- Dijalankan pernyataan demi pernyataan oleh inti/koneksi.idk.

CREATE TABLE barang (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sku TEXT NOT NULL UNIQUE,
    nama TEXT NOT NULL,
    harga_beli INTEGER NOT NULL CHECK (harga_beli >= 0),
    harga_jual INTEGER NOT NULL CHECK (harga_jual >= 0),
    stok INTEGER NOT NULL DEFAULT 0 CHECK (stok >= 0),
    stok_minimum INTEGER NOT NULL DEFAULT 0 CHECK (stok_minimum >= 0),
    aktif INTEGER NOT NULL DEFAULT 1 CHECK (aktif IN (0, 1))
);

CREATE TABLE pelanggan (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT NOT NULL,
    telepon TEXT,
    alamat TEXT
);

CREATE TABLE transaksi (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kode TEXT NOT NULL UNIQUE,
    pelanggan_id INTEGER REFERENCES pelanggan(id),
    tanggal TEXT NOT NULL,
    subtotal INTEGER NOT NULL CHECK (subtotal >= 0),
    diskon INTEGER NOT NULL DEFAULT 0 CHECK (diskon >= 0),
    total INTEGER NOT NULL CHECK (total >= 0),
    dibayar INTEGER NOT NULL DEFAULT 0 CHECK (dibayar >= 0),
    kembalian INTEGER NOT NULL DEFAULT 0 CHECK (kembalian >= 0),
    status TEXT NOT NULL CHECK (status IN ('lunas', 'bon', 'batal'))
);

CREATE TABLE detail_transaksi (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    transaksi_id INTEGER NOT NULL REFERENCES transaksi(id),
    barang_id INTEGER NOT NULL REFERENCES barang(id),
    nama_barang TEXT NOT NULL,
    harga_satuan INTEGER NOT NULL CHECK (harga_satuan >= 0),
    harga_beli INTEGER NOT NULL CHECK (harga_beli >= 0),
    jumlah INTEGER NOT NULL CHECK (jumlah > 0),
    subtotal INTEGER NOT NULL CHECK (subtotal >= 0)
);

CREATE TABLE pembayaran_bon (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    transaksi_id INTEGER NOT NULL REFERENCES transaksi(id),
    jumlah INTEGER NOT NULL CHECK (jumlah > 0),
    tanggal TEXT NOT NULL,
    catatan TEXT
);

CREATE TABLE riwayat_stok (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    barang_id INTEGER NOT NULL REFERENCES barang(id),
    jenis TEXT NOT NULL,
    jumlah INTEGER NOT NULL,
    stok_sebelum INTEGER NOT NULL CHECK (stok_sebelum >= 0),
    stok_sesudah INTEGER NOT NULL CHECK (stok_sesudah >= 0),
    tanggal TEXT NOT NULL,
    keterangan TEXT
);

CREATE TABLE pengaturan (
    kunci TEXT PRIMARY KEY,
    nilai TEXT NOT NULL
);

CREATE INDEX idx_transaksi_tanggal ON transaksi(tanggal);
CREATE INDEX idx_transaksi_status ON transaksi(status);
CREATE INDEX idx_detail_transaksi ON detail_transaksi(transaksi_id);
CREATE INDEX idx_pembayaran_bon ON pembayaran_bon(transaksi_id);
CREATE INDEX idx_riwayat_stok_barang ON riwayat_stok(barang_id);
