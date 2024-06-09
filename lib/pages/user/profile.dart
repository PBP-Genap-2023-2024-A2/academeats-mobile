import 'package:academeats_mobile/auth/auth.dart';
import 'package:academeats_mobile/models/user.dart';
import 'package:academeats_mobile/utils/fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  void increaseSaldo(int amount) {
    final user = context.read<AuthProvider>().user;
    setState(() {
      user?.saldo += amount;
    });
  }

  @override
  void initState(){
    super.initState();
    User? _user = context.read<AuthProvider>().user;
    setState(() {
      user = _user;
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: Image.network(
                width: 100, // lebar gambar yang diinginkan
                height: 100, // tinggi gambar yang diinginkan
                user?.pfp_url ?? 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
              )
            ),
            Center(
              child: Text(
                '${user?.namaLengkap ?? ''}(${user?.namaPanggilan ?? ''})',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                user?.username ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8),
              child: Text(
                'Bio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8
            ),
            Padding(padding: const EdgeInsets.all(8), // Padding inside the box
              child: Container(
              width: double.infinity,
              height: 100,
              color: const Color.fromARGB(255, 195, 188, 188),
                child:
                  Padding(
                    padding: const EdgeInsets.all(20), // Padding inside the box
                    child: Text(
                      user?.bio ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
              ),
            ),
            
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40,left : 8, bottom: 10),
                  child: Text(
                    'Saldo: Rp ${user?.saldo ?? 0}',
                    style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, left : 8, bottom: 10, right: 8),
                  child: ElevatedButton(
                    onPressed: () => _showAddSaldoDialog(context),
                    style: TextButton.styleFrom(foregroundColor: Colors.grey, backgroundColor: Colors.yellow),
                    child: const Text('Top Up Saldo'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

}

  void _showAddSaldoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddSaldoDialog();
      },
    );
  }
}

class AddSaldoDialog extends StatefulWidget {
  const AddSaldoDialog({super.key});

  @override
  _AddSaldoDialogState createState() => _AddSaldoDialogState();
}

class _AddSaldoDialogState extends State<AddSaldoDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return AlertDialog(
      title: const Text('Tambah Saldo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Minimum Top Up Rp 10.000',
              errorText: _errorText,
            ),
          ),
          const SizedBox(height: 5),
          const Align(
            alignment: Alignment.centerLeft, // Add this line
            child: Text('Biaya admin: 1000'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Batal'),
          onPressed: () {
            
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Tambah'),
          onPressed: () {
            setState(() {
              _errorText = null; // Reset error text
            });
            int? amount = int.tryParse(_controller.text);
            if (amount != null && amount >= 10000) {
              fetchData(
                'u/api/v1/top-up/', 
                method: RequestMethod.post, 
                body: {
                      'username': user?.username ?? '',
                      'jumlah': amount,
                    });
              Navigator.of(context).pop();
            } else {
              setState(() {
                _errorText = 'Masukkan angka yang valid';
              });
            }
          },
        ),
      ],
    );
  }
}
