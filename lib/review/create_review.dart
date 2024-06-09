import 'dart:convert';

import 'package:academeats_mobile/models/makanan.dart';
import 'package:academeats_mobile/review/show_review.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewFormPage extends StatefulWidget {
    final Makanan? makanans;

    const ReviewFormPage({super.key, required this.makanans});

    @override
    State<ReviewFormPage> createState() => _TrackerFormPageState();
}

class _TrackerFormPageState extends State<ReviewFormPage> {
    final _formKey = GlobalKey<FormState>();
    String _komentar = "";
    int _nilai = 0;
    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Scaffold(
          appBar: AppBar(
              title: const Center(
                  child: Text(
                  'Create',
                  ),
              ),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              ),
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: "Isi komentar",
                                      labelText: "Komentar",
                                      border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      ),
                                  ),
                                  onChanged: (String? value) {
                                      setState(() {
                                      _komentar = value!;
                                      });
                                  },
                                  validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                      return "Komentar tidak boleh kosong!";
                                      }
                                      return null;
                                  },
                              ),    
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: "1 - 5",
                                      labelText: "Nilai",
                                      border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      ),
                                  ),
                                  onChanged: (String value) {
                                      setState(() {
                                      try {
                                          _nilai = int.parse(value);
                                      } catch (e) {
                                          _nilai = 0;
                                      }
                                    });
                                  },
                                  validator: (String? value) {
                                      if (_nilai <= 0 || _nilai >= 6) {
                                      return "Nilai tidak valid";
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
                                      onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            final response = await request.postJson(
                                                "http://localhost:8000/review/api/v1/create/${widget.makanans!.id}",
                                                jsonEncode(<String, String>{
                                                    'nilai': _nilai.toString(),
                                                    'komentar': _komentar
                                                }),
                                            );
                                            if (context.mounted) {
                                                if (response['status'] == 'success') {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(
                                                    content: Text("Komentar berhasil disimpan!"),
                                                    ));
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const ReviewPage()),
                                                    );
                                                } else {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(
                                                        content:
                                                            Text("Terdapat kesalahan, silakan coba lagi."),
                                                    ));
                                                }
                                            }
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