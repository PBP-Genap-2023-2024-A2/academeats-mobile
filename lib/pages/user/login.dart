import 'package:academeats_mobile/auth/auth.dart';
import 'package:academeats_mobile/models/cart.dart';
import 'package:academeats_mobile/models/user.dart';
import 'package:academeats_mobile/pages/home.dart';
import 'package:academeats_mobile/pages/landing_page/pembeli.dart';
import 'package:academeats_mobile/pages/landing_page/penjual.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LoginApp extends StatelessWidget {
    const LoginApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Login',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: MultiProvider(
        providers: [
          Provider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: const LoginPage(),
      ),
        );
    }
}

class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        final request = context.watch<AuthProvider>();
        return Scaffold(
            appBar: AppBar(
                title: const Text('Login'),
            ),
            body: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                                labelText: 'Username',
                            ),
                        ),
                        const SizedBox(height: 12.0),
                        TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                                labelText: 'Password',
                            ),
                            obscureText: true,
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                            onPressed: () async {
                                String username = _usernameController.text;
                                String password = _passwordController.text;

                                final response = await request.login("http://localhost:8000/auth/login/", {
                                    'username': username,
                                    'password': password,
                                });

                                if (request.loggedIn) {
                                    String message = response['message'];
                                    String uname = response['username'];
                                    User? user = context.watch<AuthProvider>().user;
                                    if (context.mounted) {
                                        if(user?.role == "penjual") {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => LandingPagePenjual(user: user)),
                                            );
                                        } else {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => LandingPagePembeli(user: user)),
                                            );
                                        }
                                        ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                                SnackBar(content: Text("$message Selamat datang, $uname.")));
                                    }
                                } else {
                                    if (context.mounted) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                title: const Text('Login Gagal'),
                                                content:
                                                    Text(response['message']),
                                                actions: [
                                                    TextButton(
                                                        child: const Text('OK'),
                                                        onPressed: () {
                                                            Navigator.pop(context);
                                                        },
                                                    ),
                                                ],
                                            ),
                                        );
                                    }
                                }
                            },
                            child: const Text('Login'),
                        ),
                    ],
                ),
            ),
        );
    }
}