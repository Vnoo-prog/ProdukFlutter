import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:toko_app/models/api.dart';
import 'package:toko_app/widget/form.dart';
import 'package:toko_app/views/home.dart';

class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final formkey = GlobalKey<FormState>();
  TextEditingController kodeController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController stokController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() { _image = image; });
  }

  void _onConfirm() async {
    if (!formkey.currentState!.validate()) return;

    var request = http.MultipartRequest('POST', Uri.parse(BaseUrl.tambah));
    request.fields['kode_produk'] = kodeController.text;
    request.fields['nama_produk'] = namaController.text;
    request.fields['kategori'] = kategoriController.text;
    request.fields['harga'] = hargaController.text;
    request.fields['stok'] = stokController.text;
    request.fields['deskripsi'] = deskripsiController.text;

    if (_image != null) {
      var bytes = await _image!.readAsBytes(); 
      request.files.add(http.MultipartFile.fromBytes('gambar', bytes, filename: _image!.name));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Home()), (route) => false);
      }
    } catch (e) {
      print("Error Upload: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Produk"), centerTitle: true, backgroundColor: Colors.blue),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          child: Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                  ? Center(child: Text("Ketuk untuk pilih gambar", style: TextStyle(fontSize: 16)))
                  : Center(child: Text("Gambar terpilih: ${_image!.name}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
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