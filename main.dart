import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'toko.dart';
import 'register.dart';
import 'home_screen.dart';
import 'tampilan_awal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/toko': (context) => const TokoScreen(),
        '/tampilan_awal': (context) => TampilanAwal(),
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  Future<void> _login() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final userRef = FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid);
        var userDoc = await userRef.get();

        if (!userDoc.exists) {
          await userRef.set({
            'username': email.split('@').first,
            'email': email,
            'saldo': 150000,
            'createdAt': FieldValue.serverTimestamp(),
            'profileImage': '',
            'lastLogin': FieldValue.serverTimestamp(),
          });

          userDoc = await userRef.get(); // Reload data
        } else {
          await userRef.update({'lastLogin': FieldValue.serverTimestamp()});
        }

        final username = userDoc['username'] ?? firebaseUser.displayName ?? email.split('@').first;

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                username: username,
                email: email,
                uid: firebaseUser.uid,
              ),
            ),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = e.message ?? 'Terjadi kesalahan saat login';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              children: [
                Image.asset(
                  'assets/terumbu_karang.png',
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "SIGN IN",
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildTextField(
                        controller: emailController,
                        hintText: "Email",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 18),
                      _buildTextField(
                        controller: passwordController,
                        hintText: "Password",
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            },
                            activeColor: Colors.green[700],
                          ),
                          Text(
                            "Ingat Password",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.login, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              "MASUK",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: Text(
                          "BELUM PUNYA AKUN? DAFTAR",
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.green[700]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
