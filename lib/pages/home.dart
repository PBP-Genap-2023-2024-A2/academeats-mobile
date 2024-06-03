import 'package:academeats_mobile/models/user.dart';
import 'package:academeats_mobile/utils/fetch.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/toko.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TestWidget();
  }
}

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<StatefulWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Toko? _toko;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            ElevatedButton(
              onPressed: () async {
                var response = await fetchData('toko/api/v1/6');

                Toko toko = Toko.fromJson(response);

                setState(() {
                  _toko = toko;
                });
              },
              child: const Text("Pencet"),
            ),
            SizedBox(height: 8.0,),
            Text('${_toko?.name}'),
            SizedBox(height: 8.0,),
            Text('${_toko?.description}'),
          ])),
    );
  }
}
