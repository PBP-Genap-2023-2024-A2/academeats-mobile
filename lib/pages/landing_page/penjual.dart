import 'package:academeats_mobile/models/user.dart';
import 'package:flutter/material.dart';


class LandingPagePenjual extends StatelessWidget {
  final User? user;

  const LandingPagePenjual({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://github.com/FasiIkom/book-tracker/assets/158117087/4d8ec7c9-8983-4042-b867-e4b732aea504'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, ${user?.username}!',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nikmati kemudahan dalam memasarkan makanan dengan Academeats. Mulai promosikan makanan Anda sekarang juga!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the manage page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManagePage()),
                    );
                  },
                  child: const Text('Mulai Menjual'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ManagePage extends StatelessWidget {
  const ManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage'),
      ),
      body: const Center(
        child: Text('Manage Page'),
      ),
    );
  }
}
