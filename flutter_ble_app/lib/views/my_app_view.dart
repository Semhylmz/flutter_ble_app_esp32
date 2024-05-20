import 'package:flutter/material.dart';
import 'package:flutter_ble_app/views/home_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter BLE App',
      home: HomePage(),
    );
  }
}
