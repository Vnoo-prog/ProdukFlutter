<?php
$host = "localhost";
$user = "root";
$pass = "";
$db   = "db_toko"; 

try {
    $konekdb = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
    $konekdb->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die(json_encode(["error" => "Koneksi Gagal: " . $e->getMessage()]));
}
?>