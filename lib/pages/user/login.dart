import 'package:academeats_mobile/auth/auth.dart';
import 'package:academeats_mobile/models/cart.dart';
import 'package:academeats_mobile/models/user.dart';
import 'package:academeats_mobile/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


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

                                final response = await request.login("http://localhost:8000/u/api/v1/masuk/", {
                                    'username': username,
                                    'password': password,
                                });

                                if (request.loggedIn) {
                                    String uname = response['username'];
                                    User? user = request.user;
                                    if (context.mounted) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const HomeScreen())
                                      );
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