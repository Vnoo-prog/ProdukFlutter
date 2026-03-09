import 'package:flutter/material.dart';

class AppForm extends StatelessWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController kodeController, namaController, kategoriController,
      hargaController, stokController, deskripsiController;

  AppForm({
    required this.formkey, required this.kodeController, required this.namaController,
    required this.kategoriController, required this.hargaController, 
    required this.stokController, required this.deskripsiController,
  });

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, TextInputType type = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller, keyboardType: type, maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label, prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        validator: (value) => value!.isEmpty ? 'Masukan $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Column(
        children: [
          _buildTextField(controller: kodeController, label: "Kode Produk", icon: Icons.qr_code),
          _buildTextField(controller: namaController, label: "Nama Produk", icon: Icons.shopping_bag),
          _buildTextField(controller: kategoriController, label: "Kategori", icon: Icons.category),
          _buildTextField(controller: hargaController, label: "Harga", icon: Icons.attach_money, type: TextInputType.number),
          _buildTextField(controller: stokController, label: "Stok", icon: Icons.inventory, type: TextInputType.number),
          _buildTextField(controller: deskripsiController, label: "Deskripsi", icon: Icons.description, maxLines: 3),
        ],
      ),
    );
  }
}