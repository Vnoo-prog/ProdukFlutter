class ProdukModel {
  final int id;
  final String kode, nama, kategori, harga, stok, deskripsi, gambar;

  ProdukModel({
    required this.id, required this.kode, required this.nama,
    required this.kategori, required this.harga, required this.stok,
    required this.deskripsi, required this.gambar,
  });

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id: int.parse(json['id'].toString()),
      kode: json['kode_produk']?.toString() ?? "",
      nama: json['nama_produk']?.toString() ?? "",
      kategori: json['kategori']?.toString() ?? "",
      harga: json['harga']?.toString() ?? "0",
      stok: json['stok']?.toString() ?? "0",
      deskripsi: json['deskripsi']?.toString() ?? "",
      gambar: json['gambar']?.toString() ?? "",
    );
  }
}