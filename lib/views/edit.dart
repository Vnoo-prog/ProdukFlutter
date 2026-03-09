import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:toko_app/models/mproduk.dart';
import 'package:toko_app/models/api.dart';
import 'package:toko_app/widget/form.dart';
import 'package:toko_app/views/home.dart';

class Edit extends StatefulWidget {
  final ProdukModel produk;
  Edit({required this.produk});

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final formkey = GlobalKey<FormState>();
  late TextEditingController kodeController, namaController, kategoriController,
      hargaController, stokController, deskripsiController;

  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    kodeController = TextEditingController(text: widget.produk.kode);
    namaController = TextEditingController(text: widget.produk.nama);
    kategoriController = TextEditingController(text: widget.produk.kategori);
    hargaController = TextEditingController(text: widget.produk.harga);
    stokController = TextEditingController(text: widget.produk.stok);
    deskripsiController = TextEditingController(text: widget.produk.deskripsi);
  }

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() { _image = image; });
  }

  void _onConfirm() async {
    if (!formkey.currentState!.validate()) return;

    var request = http.MultipartRequest('POST', Uri.parse(BaseUrl.edit));
    request.fields['id'] = widget.produk.id.toString();
    request.fields['kode_produk'] = kodeController.text;
    request.fields['nama_produk'] = namaController.text;
    request.fields['kategori'] = kategoriController.text;
    request.fields['harga'] = hargaController.text;
    request.fields['stok'] = stokController.text;
    request.fields['deskripsi'] = deskripsiController.text;
    request.fields['gambar_lama'] = widget.produk.gambar;

    if (_image != null) {
      var bytes = await _image!.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes('gambar', bytes, filename: _image!.name));
    }

    try {
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Home()), (route) => false);
      }
    } catch (e) {
      print("Error Update: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Produk"), centerTitle: true, backgroundColor: Colors.blue),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          child: Text("Update", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.green),
          onPressed: _onConfirm,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            InkWell(
              onTap: getImage,
              child: Container(
                height: 150, width: double.infinity, color: Colors.grey[300],
                child: _image == null 
                  ? Center(child: Text("Ketuk untuk ganti gambar\n(Biarkan jika tidak ingin ganti)", textAlign: TextAlign.center))
                  : Center(child: Text("Gambar baru dipilih", style: TextStyle(color: Colors.green))),
              ),
            ),
            SizedBox(height: 20),
            AppForm(
              formkey: formkey, kodeController: kodeController, namaController: namaController,
              kategoriController: kategoriController, hargaController: hargaController,
              stokController: stokController, deskripsiController: deskripsiController,
            ),
          ],
        ),
      ),
    );
  }
}