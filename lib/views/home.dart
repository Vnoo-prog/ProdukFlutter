import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toko_app/models/mproduk.dart';
import 'package:toko_app/models/api.dart';
import 'package:toko_app/views/create.dart';
import 'package:toko_app/views/detail.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<ProdukModel>> produkList;

  @override
  void initState() {
    super.initState();
    produkList = getProdukList();
  }

  Future<List<ProdukModel>> getProdukList() async {
    final response = await http.get(Uri.parse(BaseUrl.data));
    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body);
      return items.map((item) => ProdukModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal menghubungi server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Katalog Produk"), centerTitle: true, backgroundColor: Colors.blue),
      body: FutureBuilder<List<ProdukModel>>(
        future: produkList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text("Tidak ada produk"));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var data = snapshot.data![index];
              return Card(
                elevation: 3, margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Details(produk: data))),
                  child: ListTile(
                    leading: data.gambar != "" 
                        ? Image.network(BaseUrl.imageUrl + data.gambar, width: 50, height: 50, fit: BoxFit.cover)
                        : Icon(Icons.image, size: 50),
                    title: Text(data.nama, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text("Rp ${data.harga} | Stok: ${data.stok}"),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.blue),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Details(produk: data))),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white), backgroundColor: Colors.deepOrange,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Create())),
      ),
    );
  }
}