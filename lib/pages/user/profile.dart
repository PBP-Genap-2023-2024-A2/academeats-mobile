import 'package:academeats_mobile/auth/auth.dart';
import 'package:academeats_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${user?.namaLengkap}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '@${user?.username}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '(${user?.namaPanggilan})',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Bio:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            user?.bio ?? "",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
