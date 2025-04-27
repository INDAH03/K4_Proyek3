import 'package:flutter/material.dart';

class KeranjangScreen extends StatelessWidget {
  const KeranjangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: const Center(
        child: Text('Ini adalah halaman Keranjang'),
      ),
    );
  }
}
