import 'dart:convert';

import 'package:academeats_mobile/auth/auth.dart';
import 'package:academeats_mobile/models/review.dart';
import 'package:academeats_mobile/review/show_review.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../keranjang/keranjang_screen.dart';

class ReplyFormPage extends StatefulWidget {
    final Review? reviews; // Tambahkan parameter untuk objek review

    const ReplyFormPage({super.key, required this.reviews});

    @override
    State<ReplyFormPage> createState() => _ReplyFormPageState();
}

class _ReplyFormPageState extends State<ReplyFormPage> {
    final _formKey = GlobalKey<FormState>();
    String _reply = "";
    @override
    Widget build(BuildContext context) {
        final request = context.watch<AuthProvider>();
        return Scaffold(
          appBar: AppBar(
              title: const Center(
                  child: Text(
                  'Reply Review',
                  ),
              ),
              actions: [
                  IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KeranjangScreen(),
                              ),
                          );
                      },
                  ),
              ],
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
                                      hintText: "Isi reply",
                                      labelText: "Reply",
                                      border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      ),
                                  ),
                                  onChanged: (String? value) {
                                      setState(() {
                                      _reply = value!;
                                      });
                                  },
                                  validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                      return "Reply tidak boleh kosong!";
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
                                                "http://localhost:8000/review/api/v1/reply/${widget.reviews!.id}",
                                                jsonEncode(<String, String>{
                                                    'reply': _reply
                                                }),
                                            );
                                            
                                            if (context.mounted) {
                                                if (response['status'] == 'success') {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(
                                                    content: Text("Reply berhasil disimpan!"),
                                                    ));
                                                    // Tambahkan rute ke halaman makanan
                                                    // Navigator.pushReplacement(
                                                    //     context,
                                                        
                                                    //     MaterialPageRoute(builder: (context) => const ReviewPage()),
                                                    // );
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