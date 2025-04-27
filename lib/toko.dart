import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Produk {
  final int id;
  final String nama;
  final double harga;
  final String gambar;
  final String kategori;

  Produk({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.kategori,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id_produk'],
      nama: json['nama_produk'],
      harga: double.parse(json['harga'].toString()),
      gambar: json['gambar_produk'],
      kategori: json['kategori'],
    );
  }
}

class TokoScreen extends StatefulWidget {
  const TokoScreen({super.key});

  @override
  _TokoScreenState createState() => _TokoScreenState();
}

class _TokoScreenState extends State<TokoScreen> {
  List<Produk> produkList = [];
  String kategoriAktif = 'ikan';

  Future<void> fetchProduk() async {
    final response = await http.get(Uri.parse('http://yourdomain.com/api/produk'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      setState(() {
        produkList = data.map((json) => Produk.fromJson(json)).toList();
      });
    } else {
      throw Exception('Gagal memuat produk');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  @override
  Widget build(BuildContext context) {
    List<Produk> produkTampil = produkList
        .where((produk) => produk.kategori == kategoriAktif)
        .toList();

    return Scaffold(
      backgroundColor: Colors.green[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Cari Produk',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Kategori
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['ikan', 'pakan', 'alat'].map((kategori) {
                  bool aktif = kategori == kategoriAktif;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        kategoriAktif = kategori;
                      });
                    },
                    child: Chip(
                      backgroundColor: aktif ? Colors.green : Colors.white,
                      label: Text(
                        kategori.toUpperCase(),
                        style: TextStyle(
                          color: aktif ? Colors.white : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Daftar Produk
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: produkTampil.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 200,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final produk = produkTampil[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            produk.gambar,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                produk.nama.toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("Rp ${produk.harga.toStringAsFixed(0)}"),
                              const SizedBox(height: 4),
                              ElevatedButton(
                                onPressed: () {
                                  // Tambahkan ke keranjang
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(8),
                                  backgroundColor: Colors.green,
                                ),
                                child: const Icon(Icons.add, size: 20),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
