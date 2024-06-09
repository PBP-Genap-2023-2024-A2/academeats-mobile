import 'package:academeats_mobile/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth.dart';
import '../makanan/detail_makanan.dart';
import '../makanan/tambah_makanan.dart';
import '../models/makanan.dart';
import '../models/toko.dart';
import '../models/user.dart';
import '../utils/fetch.dart';

class TokoDetailScreen extends StatefulWidget {
  final Toko toko;

  TokoDetailScreen({required this.toko, Key? key}) : super(key: key);

  @override
  _TokoDetailScreenState createState() => _TokoDetailScreenState();
}

class _TokoDetailScreenState extends State<TokoDetailScreen> {
  int update = 0;
  late Future<Map<String, dynamic>> _makananFuture;

  @override
  void initState() {
    super.initState();
    _makananFuture = fetchData('makanan/api/v1/toko/${widget.toko.id}/');
  }

  void _refreshMakananList() {
    setState(() {
      _makananFuture = fetchData('makanan/api/v1/toko/${widget.toko.id}/');
    });
  }

  Future<void> _deleteMakanan(int makananId) async {
    final response = await deleteData('makanan/api/v1/delete/$makananId/');
    if (response['success']) {
      _refreshMakananList();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(response['message']),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _confirmDeleteMakanan(int makananId) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this makanan?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      _deleteMakanan(makananId);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<AuthProvider>().user;
    String role = user?.role ?? 'anonymous';
    bool isOwner = (role == 'penjual' && user?.id == widget.toko.user.id);

    CartProvider cart = context.watch<CartProvider>();

    fetchData('u/api/v1/tambah-saldo/', method: RequestMethod.post, body: {
      'jumlah': 10000.0,
      'username': user?.username ?? '',
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.toko.name),
        backgroundColor: const Color(0xFFF6E049),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _makananFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          } else {
            Map<String, dynamic>? data = snapshot.data;
            if (data == null || data['data'] == null) {
              return const Center(child: Text('No data found'));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image:
                              NetworkImage('https://via.placeholder.com/150'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.toko.name,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: const Color(0xFF625A1D),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Owner: ${widget.toko.user.namaLengkap}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: const Color(0xFF383A48),
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Deskripsi: ${widget.toko.description}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: const Color(0xFF383A48),
                          ),
                    ),
                    const SizedBox(height: 20),
                    if (isOwner)
                      ElevatedButton(
                        onPressed: () async {
                          final newMakanan = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TambahMakananPage(toko: widget.toko),
                            ),
                          );
                          if (newMakanan != null) {
                            _refreshMakananList();
                          }
                        },
                        child: Text('Tambah Makanan'),
                      ),
                    const Divider(color: Color(0xFFE0719E)),
                    const SizedBox(height: 10),
                    Text(
                      'Available Makanan',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: const Color(0xFFE0719E),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data['data'].length,
                      itemBuilder: (context, index) {
                        Makanan makanan = Makanan.fromJson(data['data'][index]);
                        bool canDelete =
                            isOwner && makanan.toko.id == widget.toko.id;
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF9DB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFE0719E),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FoodDetailScreen(makanan: makanan),
                                ),
                              );
                            },
                            child: Dismissible(
                              key: Key(makanan.id.toString()),
                              background: Container(
                                color: Colors.pink,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Detail',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              secondaryBackground: canDelete
                                  ? Container(
                                      color: Colors.red,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  if (canDelete) {
                                    return await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Confirm Delete'),
                                          content: Text(
                                              'Are you sure you want to delete this makanan?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    return false;
                                  }
                                } else if (direction ==
                                    DismissDirection.startToEnd) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FoodDetailScreen(makanan: makanan),
                                    ),
                                  );
                                  return false;
                                }
                                return false;
                              },
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart &&
                                    canDelete) {
                                  _deleteMakanan(makanan.id);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        makanan.imgUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            makanan.nama,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                ?.copyWith(
                                                  color:
                                                      const Color(0xFF383A48),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Harga: ${makanan.harga}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(
                                                  color:
                                                      const Color(0xFF383A48),
                                                ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Stok: ${makanan.stok}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(
                                                  color:
                                                      const Color(0xFF383A48),
                                                ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              cart.add(user?.username ?? '', makanan.id, 1);
                                            },
                                            child: Text('Masukkan Keranjang!'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        },
      ),
      backgroundColor: const Color(0xFFF3F6E6),
    );
  }
}
