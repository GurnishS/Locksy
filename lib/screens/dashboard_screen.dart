import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locksy/crypto/cryptography_handler.dart';
import 'package:locksy/screens/new_service_screen.dart';
import 'package:locksy/screens/service_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.masterKey});

  final masterKey;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var _isLoading = false;
  var _valtName="Vault";
  var _leadingWidth=100;

  List<Map<String, Object>> storedPasswords = [
  ];

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch data from the database
      _valtName=await CryptographyHandler.getInstance.getVaultName();
      final data = await CryptographyHandler.getInstance.getData(widget.masterKey);

      if (data.isEmpty) {
        print("No data found.");
        setState(() {
          _valtName=_valtName;
          storedPasswords = []; // Initialize with an empty list
        });
      } else {
        try {
          // Decode the data and cast to the correct type
          final List<Map<String, Object>> decodedData =
          (jsonDecode(data) as List<dynamic>)
              .map((item) => (item as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value as Object)))
              .toList();
          setState(() {
            storedPasswords = decodedData;
          });
        } catch (decodeError) {
          print("Error decoding data: $decodeError");
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: (MediaQuery.of(context).size.width<310)?0:((MediaQuery.of(context).size.width<620)?100:200),
          leading: Center(child: Text(_valtName,style: TextStyle(fontFamily: 'LeckerliOne',color: Theme.of(context).colorScheme.shadow,fontSize: 14))),
          title: const Text("Locksy",style: TextStyle(fontFamily: 'DynaPuff',fontSize: 22),),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.black87,
                    ),
                    Text("Fetching Data"),
                  ],
                ),
              )
            : ListView(children: [
                SizedBox(height: 20,),
                Text(
                  "Your Saved Passwords",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 20,),
                ...storedPasswords.map((element) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 2, bottom: 2),
                    child: Card(
                      elevation: 8,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
                        tileColor: Colors.grey[400],
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),

                        leading: const CircleAvatar(),
                        title: Text(element['service'].toString()),
                        subtitle: Text(element['username'].toString()),
                        trailing:IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                              text: element['password'].toString(),
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
                        onTap: () async{
                          var result=await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceDetailsScreen(
                                data: element,
                                masterKey: widget.masterKey,
                              ),
                            ),
                          );
                          if(result==true){
                            _fetchData();
                          }
                        },
                      ),
                    ),
                  );
                })
              ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            var result= await Navigator.push(context, MaterialPageRoute(builder: (context)=>NewServiceScreen(masterKey: widget.masterKey,)));
            if(result==true){
              _fetchData();
            }
          },
          tooltip: 'Add Password',
          child: const Icon(Icons.add),
        )
    );
  }
}
