<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Content-Type: application/json; charset=UTF-8");
error_reporting(0);
require_once 'konekdb.php';

try {
    $kode = $_POST['kode_produk'] ?? '';
    $nama = $_POST['nama_produk'] ?? '';
    $kategori = $_POST['kategori'] ?? '';
    $harga = $_POST['harga'] ?? 0;
    $stok = $_POST['stok'] ?? 0;
    $deskripsi = $_POST['deskripsi'] ?? '';

    // Logika Upload Gambar 
    // Logika Upload Gambar yang AMAN
    $nama_gambar = "";
    if (isset($_FILES['gambar']['name']) && $_FILES['gambar']['name'] != "") {
        // Ambil ekstensi filenya saja (misal: jpg, png)
        $ekstensi = pathinfo($_FILES['gambar']['name'], PATHINFO_EXTENSION);

        // Buat nama baru yang 100% aman (Kombinasi waktu dan id unik)
        $nama_gambar = time() . "_" . uniqid() . "." . $ekstensi;

        move_uploaded_file($_FILES['gambar']['tmp_name'], "uploads/" . $nama_gambar);
    }

    $sql = "INSERT INTO produk (kode_produk, nama_produk, kategori, harga, stok, deskripsi, gambar) 
            VALUES (:kode, :nama, :kategori, :harga, :stok, :deskripsi, :gambar)";

    $stmt = $konekdb->prepare($sql);
    $stmt->execute([
        ':kode' => $kode,
        ':nama' => $nama,
        ':kategori' => $kategori,
        ':harga' => $harga,
        ':stok' => $stok,
        ':deskripsi' => $deskripsi,
        ':gambar' => $nama_gambar
    ]);

    echo json_encode(["success" => true]);
} catch (Exception $e) {
    echo json_encode(["success" => false, "message" => $e->getMessage()]);
}
