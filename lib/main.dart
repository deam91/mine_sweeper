import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mine_sweeper/views/main_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        color: Colors.white,
        theme: ThemeData(fontFamily: 'CaesarDressing'),
        home: const Scaffold(
          body: MainView(),
        ),
      ),
    );
  }
}
