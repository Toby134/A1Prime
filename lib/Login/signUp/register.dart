import 'dart:convert';
import 'package:a1primeinventory/Login/signUp/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwordController = TextEditingController();
  final TextEditingController _empNoController = TextEditingController();
  final TextEditingController _utypeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> registerUser() async {
    if (_unameController.text.isEmpty ||
        _pwordController.text.isEmpty ||
        _empNoController.text.isEmpty ||
        _utypeController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill in all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    const String url = "http://192.168.86.31/A1PrimeInventory/register.php";
    Map<String, String> body = {
      "Uname": _unameController.text.trim(),
      "Pword": _pwordController.text,
      "Emp_No": _empNoController.text.trim(),
      "Utype": _utypeController.text.trim(),
      "Email": _emailController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body.trim());
      if (data["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ ${data["message"]}")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${data["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("⚠️ Network error: Could not connect to server")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;

          return SingleChildScrollView(
            child: Center(
              child: isWideScreen
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.red[900],
                            height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'lib/assets/Laptop.png',
                                  width: constraints.maxWidth * 0.35,
                                  height: constraints.maxHeight * 0.4,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Tabaco - Legazpi - Daet - Sorsogon',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: _buildForm(isWideScreen)),
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            children: [
                              Image.asset(
                                'lib/assets/Laptop.png',
                                width: constraints.maxWidth * 0.6,
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Tabaco - Legazpi - Daet - Sorsogon',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        _buildForm(isWideScreen),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(bool isWideScreen) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "User Registration",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildTextField(_unameController, "Username"),
          _buildTextField(_emailController, "Email",
              keyboardType: TextInputType.emailAddress),
          _buildPasswordField(),
          _buildTextField(_empNoController, "Employee Number"),
          _buildTextField(_utypeController, "User Type"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : registerUser,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              backgroundColor: Colors.red[900],
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Sign up",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()));
                },
                child: const Text(
                  " Log in",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: _pwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: "Password",
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          suffixIcon: IconButton(
            icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
      ),
    );
  }
}