import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Column(
                      children: [
                        Text(
                          "HALO\nBUAT AKUNMU YA!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: isWideScreen ? 28 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/terumbu_karang.png',
                          width: isWideScreen ? 300 : screenWidth * 0.6,
                          height: isWideScreen ? 300 : screenWidth * 0.6,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "SIGN UP",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildInputField(
                          context,
                          icon: Icons.person,
                          hint: "Nama Pengguna",
                          controller: _usernameController,
                        ),
                        const SizedBox(height: 15),

                        _buildInputField(
                          context,
                          icon: Icons.email,
                          hint: "Email",
                          controller: _emailController,
                        ),
                        const SizedBox(height: 15),

                        _buildInputField(
                          context,
                          icon: Icons.lock,
                          hint: "Password",
                          obscureText: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 15),

                        _buildInputField(
                          context,
                          icon: Icons.lock,
                          hint: "Konfirmasi Password",
                          obscureText: true,
                          controller: _confirmPasswordController,
                        ),
                        const SizedBox(height: 25),

                        ElevatedButton(
                          onPressed: () async {
                            final username = _usernameController.text.trim();
                            final email = _emailController.text.trim();
                            final password = _passwordController.text;
                            final confirmPassword = _confirmPasswordController.text;

                            if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Semua kolom wajib diisi!")),
                              );
                              return;
                            }

                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Password tidak cocok!")),
                              );
                              return;
                            }

                            try {
                              // 1. Daftar user di Firebase Auth
                              UserCredential userCredential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              // 2. Simpan data user ke Firestore
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'uid': userCredential.user!.uid,
                                'username': username,
                                'email': email,
                                'createdAt': FieldValue.serverTimestamp(),
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Akun berhasil didaftarkan!")),
                              );

                              await Future.delayed(const Duration(seconds: 2));
                              Navigator.pop(context); // Kembali ke halaman sebelumnya
                            } on FirebaseAuthException catch (e) {
                              // ✅ LOG detail error-nya
                              print("FirebaseAuthException: ${e.code} - ${e.message}");

                              String message = "Gagal mendaftar. Coba lagi.";
                              if (e.code == 'email-already-in-use') {
                                message = 'Email sudah digunakan.';
                              } else if (e.code == 'invalid-email') {
                                message = 'Format email tidak valid.';
                              } else if (e.code == 'weak-password') {
                                message = 'Password terlalu lemah (minimal 6 karakter).';
                              } else if (e.code == 'operation-not-allowed') {
                                message = 'Metode pendaftaran tidak diizinkan.';
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                            } catch (e) {
                              // ❌ fallback untuk error selain FirebaseAuth
                              print("Error lain: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Terjadi kesalahan. Coba lagi.")),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[900],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                "DAFTAR",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            "SUDAH PUNYA AKUN? MASUK",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required IconData icon,
    required String hint,
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.green[600],
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
      style: GoogleFonts.poppins(color: Colors.white),
    );
  }
}
