import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian atas profil
            Container(
              color: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/OIP.jpg'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dika Saputra",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "familiaquarium@gmail.com",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.notifications, color: Colors.white),
                ],
              ),
            ),

            // Saldo dan Status Pesanan
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Saldo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Rp 150.000", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusIcon(Icons.payment, "Menunggu\nPembayaran"),
                      _buildStatusIcon(Icons.history, "Dalam\nProses"),
                      _buildStatusIcon(Icons.local_shipping, "Dalam\nPengiriman"),
                      _buildStatusIcon(Icons.store, "Hubungi\nPenjual"),
                    ],
                  ),
                ],
              ),
            ),

            // Pesanan Terkini
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/OIP.jpg'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pesanan Terkirim", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("Paket anda telah sampai tujuan", style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Text("09 Maret 2025", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),

            // Aktivitas dan Bantuan
            const SizedBox(height: 16),
            _buildSectionTitle("Aktivitas Saya"),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(4, (index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: const Center(child: Icon(Icons.image, size: 40)),
                  );
                }),
              ),
            ),
            _buildSectionTitle("Bantuan"),
            const ListTile(
              leading: Icon(Icons.help, color: Colors.green),
              title: Text("Pusat Bantuan"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            const ListTile(
              leading: Icon(Icons.chat, color: Colors.green),
              title: Text("Chat dengan Penjual"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
          );
  }

  Widget _buildStatusIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.green),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
