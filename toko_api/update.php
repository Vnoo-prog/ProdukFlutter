<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Content-Type: application/json; charset=UTF-8");
error_reporting(0);
require_once 'konekdb.php';

try {
    $id = $_POST['id'] ?? '';
    $kode = $_POST['kode_produk'] ?? '';
    $nama = $_POST['nama_produk'] ?? '';
    $kategori = $_POST['kategori'] ?? '';
    $harga = $_POST['harga'] ?? 0;
    $stok = $_POST['stok'] ?? 0;
    $deskripsi = $_POST['deskripsi'] ?? '';
    $gambar_lama = $_POST['gambar_lama'] ?? '';

    $nama_gambar = $gambar_lama;

    // Jika user mengupload gambar baru saat diedit
    // Jika user mengupload gambar baru saat diedit
    if (isset($_FILES['gambar']['name']) && $_FILES['gambar']['name'] != "") {
        // Ambil ekstensi
        $ekstensi = pathinfo($_FILES['gambar']['name'], PATHINFO_EXTENSION);

        // Buat nama baru yang aman
        $nama_gambar = time() . "_" . uniqid() . "." . $ekstensi;

        move_uploaded_file($_FILES['gambar']['tmp_name'], "uploads/" . $nama_gambar);

        // Hapus gambar lama
        if ($gambar_lama != "" && file_exists("uploads/" . $gambar_lama)) {
            unlink("uploads/" . $gambar_lama);
        }
    }

    $sql = "UPDATE produk SET kode_produk=:kode, nama_produk=:nama, kategori=:kategori, 
            harga=:harga, stok=:stok, deskripsi=:deskripsi, gambar=:gambar WHERE id=:id";

    $stmt = $konekdb->prepare($sql);
    $stmt->execute([
        ':id' => $id,
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
