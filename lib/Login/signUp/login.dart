import 'dart:convert';
import 'package:a1primeinventory/Login/signUp/register.dart';
import 'package:a1primeinventory/main_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwordController = TextEditingController();
  final TextEditingController _ipController =
      TextEditingController(text: '192.168.86.20');
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _showIpField = false;

  @override
  void initState() {
    super.initState();
    _loadSavedIp();
  }

  Future<void> _loadSavedIp() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIp = prefs.getString('server_ip');
    if (savedIp != null) {
      _ipController.text = savedIp; // Pre-populate the IP field
    }
  }

  Future<void> _saveIp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_ip', _ipController.text.trim());
  }

  // Fast login - directly navigates to main screen
  void _fastLogin() async {
    await _saveIp(); // Save the IP before navigation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ItemlistPage()),
    );
  }

  /*
  // Original login functionality (commented out but modified with IP selection)
  Future<void> loginUser() async {
    final String url = "http://${_ipController.text.trim()}/3GXInventory/login.php";

    Map<String, String> body = {
      "Uname": _unameController.text.trim(),
      "Pword": _pwordController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      String responseBody = response.body.trim();
      print("🔹 Raw Response: $responseBody");

      int jsonStart = responseBody.indexOf("{");
      if (jsonStart != -1) {
        responseBody = responseBody.substring(jsonStart);
      }

      final data = jsonDecode(responseBody);

      if (data["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Login successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${data["message"]}")),
        );
      }
    } catch (e) {
      print("⚠️ Network Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error: Could not connect to server")),
      );
    }
  }
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/assets/a1prime_logo.png'),
                const SizedBox(height: 32),
                const Text("Welcome Back"),
                const Text("Sign in to your account to continue"),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _ipController,
                  decoration: InputDecoration(
                    labelText: 'Server',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.network_cell_rounded),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _unameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.man_2_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _fastLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Login', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  child: const Text("Don't have an account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
