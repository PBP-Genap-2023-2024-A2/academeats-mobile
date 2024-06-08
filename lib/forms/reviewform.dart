import 'package:flutter/material.dart';

class TrackerFormPage extends StatefulWidget {
    const TrackerFormPage({super.key});

    @override
    State<TrackerFormPage> createState() => _TrackerFormPageState();
}

class _TrackerFormPageState extends State<TrackerFormPage> {
    final _formKey = GlobalKey<FormState>();
    String _deskripsi = "";
    int _nilai = 0;
    String _reply = "";
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Center(
                    child: Text(
                    'Form Tambah Buku',
                    ),
                ),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
            ),
            body: Form(
                key: _formKey,  // Tambahkan ini
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Judul Buku",
                                        labelText: "Judul Buku",
                                        border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        ),
                                    ),
                                    onChanged: (String? value) {
                                        setState(() {
                                        _deskripsi = value!;
                                        });
                                    },
                                    validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                        return "Judul tidak boleh kosong!";
                                        }
                                        return null;
                                    },
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Halaman",
                                        labelText: "Halaman",
                                        border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        ),
                                    ),
                                    onChanged: (String? value) {
                                        setState(() {
                                        // TODO: Tambahkan variabel yang sesuai
                                        _nilai = int.tryParse(value!) ?? 0;
                                        });
                                    },
                                    validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                            return "Halaman tidak boleh kosong!";
                                        }
                                        if (int.tryParse(value) == null) {
                                            return "Halaman harus berupa angka!";
                                        }
                                        return null;
                                    },
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Deskripsi",
                                        labelText: "Deskripsi",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                        ),
                                    ),
                                    onChanged: (String? value) {
                                        setState(() {
                                        // TODO: Tambahkan variabel yang sesuai
                                        _reply = value!;
                                        });
                                    },
                                    validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                        return "Deskripsi tidak boleh kosong!";
                                        }
                                        return null;
                                    },
                                ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.indigo),
                                        ),
                                        onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                      return AlertDialog(
                                                          title: const Text('Buku berhasil tersimpan'),
                                                          content: SingleChildScrollView(
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                  children: [
                                                                      Text('Balasan: $_reply'),
                                                                      Text('Nilai: $_nilai'),
                                                                      Text('Deskripsi: $_deskripsi'),
                                                                  ],
                                                              ),
                                                          ),
                                                          actions: [
                                                              TextButton(
                                                                  child: const Text('OK'),
                                                                  onPressed: () {
                                                                      Navigator.pop(context);
                                                                      _formKey.currentState!.reset();
                                                                  },
                                                              ),
                                                          ],
                                                      );
                                                  },
                                              );
                                            }
                                        },
                                        child: const Text(
                                            "Save",
                                            style: TextStyle(color: Colors.white),
                                        ),
                                    ),
                                ),
                            ),
                        ]
                    )
                ),
            ),
        );
    }
}
