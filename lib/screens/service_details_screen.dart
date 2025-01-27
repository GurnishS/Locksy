import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locksy/crypto/cryptography_handler.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen(
      {super.key, required this.data, required this.masterKey});

  final data;
  final masterKey;

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  void onDelete(BuildContext context) async {
    print('Service Deleted');
    await CryptographyHandler.getInstance
        .deleteDataById(widget.masterKey, widget.data['id'].toString());
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    String serviceName = widget.data['service'] ?? '';
    String url = widget.data['url'] ?? '';
    String username = widget.data['username'] ?? '';
    String password = widget.data['password'] ?? '';

    final _serviceController = TextEditingController(text: serviceName);
    final _urlController = TextEditingController(text: url);
    final _usernameController = TextEditingController(text: username);
    final _passwordController = TextEditingController(text: password);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Allow scrolling for small screens
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 250,
                      child: Image.asset("assets/happy_person.png"))),
              TextField(
                controller: _serviceController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: "Service Name",
                ),
              ),
              SizedBox(
                height: 20,
              ),

              TextField(
                controller: _urlController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: "Url",
                  suffixIcon: IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: _urlController.text,
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Url copied to clipboard'),
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
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _usernameController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: "Username",
                  suffixIcon: IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: _usernameController.text,
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Username copied to clipboard'),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.copy,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ),
              ),
              SizedBox(
                height: 20,
              ),

              TextField(
                controller: _passwordController,
                readOnly: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
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

              // Copy Buttons on the same line
              const SizedBox(height: 20),

              // Delete Service Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    onDelete(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Service deleted')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for delete button
                  ),
                  child: const Text('Delete Service'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
