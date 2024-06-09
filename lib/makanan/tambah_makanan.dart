import 'package:flutter/material.dart';
import '../models/toko.dart';
import '../models/makanan.dart';
import '../utils/fetch.dart';

class TambahMakananPage extends StatefulWidget {
  final Toko toko;

  TambahMakananPage({required this.toko});

  @override
  _TambahMakananPageState createState() => _TambahMakananPageState();
}

class _TambahMakananPageState extends State<TambahMakananPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _imgUrlController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newMakanan = Makanan(
        id: 0, // This will be set by the backend
        nama: _namaController.text,
        harga: double.tryParse(_hargaController.text) ?? 0,
        stok: int.tryParse(_stokController.text) ?? 0,
        imgUrl: _imgUrlController.text,
        toko: widget.toko,
      );

      try {
        final jsonData = newMakanan.toJson();


        final response = await postData(
          'makanan/api/v1/toko/${widget.toko.id}/add',
          jsonData,
        );



        if (response['success'] == true) {
          Navigator.pop(context, newMakanan);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add makanan: ${response['message']}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Makanan'),
        backgroundColor: const Color(0xFFF6E049),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Makanan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama makanan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _stokController,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _imgUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Image URL tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Tambah Makanan'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFFE0719E), // text color
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF3F6E6),
    );
  }
}
