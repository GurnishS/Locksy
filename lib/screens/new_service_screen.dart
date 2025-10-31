import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locksy/crypto/cryptography_handler.dart';
import 'dart:math';

class NewServiceScreen extends StatefulWidget {
  const NewServiceScreen({super.key, required this.masterKey});

  final masterKey;

  @override
  State<NewServiceScreen> createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends State<NewServiceScreen> {
  final _serviceController = TextEditingController();

  final _urlController = TextEditingController();

  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  double _passwordLength = 12;
  bool _includeNumbers = true;
  bool _includeSpecialChar = true;
  bool _includeUppercase = true;


  String generateRandomPassword() {
    const String lowerCase = 'abcdefghijklmnopqrstuvwxyz';
    const String upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = lowerCase;
    if (_includeUppercase) chars += upperCase;
    if (_includeNumbers) chars += numbers;
    if (_includeSpecialChar) chars += specialChars;

    

  final Random random = Random();
  return List.generate(_passwordLength.toInt(), (_) {
    final randomIndex = random.nextInt(chars.length);
    return chars[randomIndex];
  }).join('');
}


  void _saveService(BuildContext context) async {
    final service = _serviceController.text.trim();
    final url = _urlController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (service.isEmpty ||
        url.isEmpty ||
        username.isEmpty ||
        password.isEmpty) {
      return;
    }

    final data = {
      "service": service,
      "url": url,
      "username": username,
      "password": password,
    };

    try {
      await CryptographyHandler.getInstance.addData(widget.masterKey, data);

      // Feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service saved successfully!")),
      );

      // Navigate back after saving
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving service: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add New Service"),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 200,
                      width: 280,
                      color: Colors.grey,
                      child: Image.asset(
                        "assets/new_service.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _serviceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Service Name",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Service URL",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Username",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                            text: _passwordController.text,
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password copied to clipboard'),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.copy,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),

                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Generate Password",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Numbers"),
                        Checkbox(value: _includeNumbers,onChanged: (value){
                          setState(() {
                            _includeNumbers=!_includeNumbers;
                            _passwordController.text=generateRandomPassword();
                          });
                        }),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Text("Uppercase"),
                        Checkbox(value: _includeUppercase, onChanged: (value){
                          setState(() {
                            _includeUppercase=!_includeUppercase;
                            _passwordController.text=generateRandomPassword();
                          });
                        }),
                      ],
                    ),
                      SizedBox(width: 20,),

                      Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Text("Special Characters"),

                        Checkbox(value: _includeSpecialChar, onChanged: (value){
                          setState(() {
                            _includeSpecialChar=!_includeSpecialChar;
                            _passwordController.text=generateRandomPassword();
                          });
                        })
                      ],
                    )
                  ],),
                  Slider(
                    inactiveColor: Colors.grey,
                    value: _passwordLength,
                    onChanged: (val) {
                      setState(() {
                        _passwordLength = val;
                        _passwordController.text=generateRandomPassword();
                      });
                    },
                    min: 8,
                    max: 128,
                    label: _passwordLength.round().toString(),
                    divisions: 120,
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {
                      _saveService(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary, // Set the background color
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
