import 'package:flutter/material.dart';
import 'package:locksy/crypto/cryptography_handler.dart';
import 'package:locksy/screens/dashboard_screen.dart';

class WelcomeScreen extends StatefulWidget {

  WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _vaultNameController = TextEditingController();

  final _masterKeyController = TextEditingController();
  var _errorMessagePass;
  var _errorMessageVault;

  void _setMasterKey(BuildContext context){
    final vaultName=_vaultNameController.text;
    final masterKey=_masterKeyController.text;

    if (masterKey.isEmpty && vaultName.isEmpty) {
      setState(() {
        _errorMessageVault = "Vault name cannot be empty";
        _errorMessagePass = "Password cannot be empty";
      });
      return;
    }

    if (masterKey.isEmpty) {
      setState(() {
        _errorMessagePass = "Password cannot be empty";
      });
      return;
    }

    if (vaultName.isEmpty) {
      setState(() {
        _errorMessageVault = "Vault name cannot be empty";
      });
      return;
    }

    CryptographyHandler.getInstance.setMasterKey(masterKey, vaultName);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen(masterKey: masterKey)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child:Image.asset('assets/logo.png'),
                  ),
                ),
                const SizedBox(height: 50,),
                Text(
                  "Welcome to Locksy",
                  style: TextStyle(fontSize: 30,color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Please Set Your Credentials",
                  style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _vaultNameController,
                  onTap: () {
                    setState(() {
                      _errorMessageVault = null;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Vault Name",
                    errorText: _errorMessageVault,
                  ),

                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _masterKeyController,
                  obscureText: true,
                  onTap: () {
                    setState(() {
                      _errorMessagePass = null;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Master Key",
                    errorText: _errorMessagePass,
                  ),
                ),
                const SizedBox(height: 30,),
                ElevatedButton(onPressed: (){_setMasterKey(context);},
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary, // Set the background color
                  ),child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Next",style: TextStyle(color: Theme.of(context).colorScheme.surface),),
                    Icon(Icons.arrow_forward,color: Theme.of(context).colorScheme.surface,)
                  ],
                ),
                ),
                const SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
