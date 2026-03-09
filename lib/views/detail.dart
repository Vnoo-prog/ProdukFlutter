import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toko_app/models/api.dart';
import 'package:toko_app/models/mproduk.dart';
import 'package:toko_app/views/edit.dart';
import 'package:toko_app/views/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Details extends StatefulWidget {
  final ProdukModel produk;
  Details({required this.produk});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  void deleteData() async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.hapus),
        body: {'id': widget.produk.id.toString(), 'gambar': widget.produk.gambar}, 
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Data Dihapus", backgroundColor: Colors.red);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Home()), (route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Hapus produk ini?'),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Icon(Icons.cancel)),
          ElevatedButton(onPressed: deleteData, child: Icon(Icons.check_circle)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Produk"), centerTitle: true, backgroundColor: Colors.blue,
        actions: [IconButton(onPressed: confirmDelete, icon: Icon(Icons.delete))],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.produk.gambar != "" 
                  ? Image.network(BaseUrl.imageUrl + widget.produk.gambar, height: 200, fit: BoxFit.cover)
                  : Icon(Icons.image, size: 100, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text("Kode : ${widget.produk.kode}", style: TextStyle(fontSize: 20)),
            Text("Nama : ${widget.produk.nama}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Kategori : ${widget.produk.kategori}", style: TextStyle(fontSize: 20)),
            Text("Harga : Rp ${widget.produk.harga}", style: TextStyle(fontSize: 20, color: Colors.green)),
            Text("Stok : ${widget.produk.stok}", style: TextStyle(fontSize: 20)),
            Divider(),
            Text("Deskripsi :\n${widget.produk.deskripsi}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Edit(produk: widget.produk))),
      ),
    );
  }
}