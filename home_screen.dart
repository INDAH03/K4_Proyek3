import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // Add this for SocketException and TimeoutException
import 'login.dart';
import 'profil.dart';
import 'toko.dart';
import 'dart:async'; 


class ApiService {
  static const String baseUrl = "http://192.168.0.116:8000/api";

  static Future<Map<String, dynamic>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } 
    on TimeoutException {
      throw Exception('Connection timeout');
    } on SocketException {
      throw Exception('No internet connection');
    }
  }

  static Future<Map<String, dynamic>> searchProducts(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products?search=$keyword'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timeout');
    } on SocketException {
      throw Exception('No internet connection');
    }
  }
}

class HomeScreen extends StatefulWidget {
  final String username;
  final String email;
  final String uid;

  const HomeScreen({
    Key? key,
    required this.username,
    required this.email,
    required this.uid, // Fixed: changed 'self.uid' to 'required this.uid'
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = false;
  List<dynamic> _products = [];
  List<dynamic> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getProducts();
      setState(() {
        _products = data['products'] ?? [];
        _filteredProducts = _products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar(e.toString());
    }
  }

  Future<void> _searchProduct(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _filteredProducts = _products;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _isLoading = true;
    });

    try {
      final data = await ApiService.searchProducts(keyword);
      setState(() {
        _filteredProducts = data['products'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar(e.toString());
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      
      (route) => false,
    );
  }

  Widget _buildCategoryItem(String imagePath, String label) {
    return InkWell(
      onTap: () => print('Category $label tapped'),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                product['image_url'] ?? '',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product['name'] ?? 'No Name',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Rp${product['price']?.toStringAsFixed(2) ?? '0'}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    if (_isLoading && _filteredProducts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/Banner Family Aqua.png',
                  height: MediaQuery.of(context).size.height * 0.35,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "KATEGORI",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8,
              children: [
                _buildCategoryItem('assets/mas.jpeg', 'IKAN'),
                _buildCategoryItem('assets/takari.jpg', 'PAKAN'),
                _buildCategoryItem('assets/R.jpg', 'ALAT'),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              _isSearching ? "HASIL PENCARIAN" : "PRODUK TERBARU",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _filteredProducts.isEmpty
                ? const Center(
                    child: Text('Tidak ada produk ditemukan'),
                    heightFactor: 3,
                  )
                : GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.7,
                    children: _filteredProducts
                        .map((product) => _buildProductItem(product))
                        .toList(),
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Cari produk...",
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                  onChanged: _searchProduct,
                )
              : const Text(
                  "FAMILY AQUARIUM",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: _logout,
            ),
          ],
        ),
        body: _buildHomeContent(),
      ),
      const TokoScreen(),
      const SizedBox.shrink(), // Placeholder for camera
      ProfilScreen(
        displayName: widget.username,
        email: widget.email,
        uid: widget.uid,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Toko',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? 'Product Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product['image_url'] ?? '',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 100),
            ),
            const SizedBox(height: 16),
            Text(
              product['name'] ?? 'No Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp${product['price']?.toStringAsFixed(2) ?? '0'}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product['description'] ?? 'No description available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  // Add to cart functionality
                },
                child: const Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}