<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");
error_reporting(0);
require_once 'konekdb.php';

try {
    $id = $_POST['id'] ?? '';
    $gambar = $_POST['gambar'] ?? '';

    $stmt = $konekdb->prepare("DELETE FROM produk WHERE id=:id");
    $stmt->execute([':id' => $id]);

    // Hapus file fisik gambar
    if($gambar != "" && file_exists("uploads/" . $gambar)){
        unlink("uploads/" . $gambar);
    }

    echo json_encode(["success" => true]);
} catch (Exception $e) {
    echo json_encode(["success" => false, "message" => $e->getMessage()]);
}
?>