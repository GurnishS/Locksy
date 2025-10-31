import 'package:flutter/material.dart';
import 'package:locksy/crypto/cryptography_handler.dart';
import 'package:locksy/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _masterKeyController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  void _login() async {
    final key = _masterKeyController.text.trim();
    if (key.isEmpty) {
      setState(() {
        _errorMessage = "Password cannot be empty";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isKeyCorrect =
          CryptographyHandler.getInstance.checkMasterKey(key);

      if (isKeyCorrect) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(masterKey: key),
          ),
        );
      } else {
        setState(() {
          _errorMessage = "Invalid Password";
        });
        print("Incorrect Password");
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
      print("Error during login: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                // color: Theme.of(context).colorScheme.tertiary,
                width: 200,
                height: 200,
                child: Padding(padding: const EdgeInsets.all(10), child: Image.asset('assets/logo.png',fit: BoxFit.cover,)),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "Please Enter Your",
              style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary),
            ),
            Text(
              "Master Key",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: _masterKeyController,
              obscureText: true,
              onTap: () {
                setState(() {
                  _errorMessage = null;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: "Master Key",
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: _login,
              style: TextButton.styleFrom(
                backgroundColor:
                Theme.of(context).colorScheme.secondary, // Set the background color
              ),
              child: _isLoading
                  ? Center(
                      widthFactor: 2,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.surface),
                        ),
                      ),
                    )
                  : Text(
                      "Login",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface
                      ),
                    ),
            ),
          ],
        ),
      )),
    );
  }
}
