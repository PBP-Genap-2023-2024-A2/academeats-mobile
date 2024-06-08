import 'package:flutter/material.dart';
import '../models/makanan.dart';
import '../models/toko.dart';

class TambahMakananPage extends StatefulWidget {
  final Toko toko;

  TambahMakananPage({required this.toko, Key? key}) : super(key: key);

  @override
  _TambahMakananPageState createState() => _TambahMakananPageState();
}

class _TambahMakananPageState extends State<TambahMakananPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newMakanan = Makanan(
        id: 0, // This should be set by your backend
        nama: _namaController.text,
        harga: double.parse(_hargaController.text),
        stok: int.parse(_stokController.text),
        imgUrl: 'https://via.placeholder.com/150', // Example placeholder image
        toko: widget.toko,
      );
      Navigator.pop(context, newMakanan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Makanan'),
        backgroundColor: const Color(0xFFF6E049), // Primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              Text(
                'Tambah Makanan',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: const Color(0xFFE0719E), // Pink text color
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Makanan',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: const Color(0xFFFDF9DB),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Makanan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: const Color(0xFFFDF9DB),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _stokController,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: const Color(0xFFFDF9DB),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  child: Text('Tambah Makanan', style: TextStyle(fontSize: 18)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0719E), // Pink button color
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
