import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? _user = {
    "email": null,
    "isAdmin": null,
  };
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Future _getUserData(BuildContext context) async {
    try {
      final user =
          await FirebaseFirestore.instance.collection("Users").doc(uid).get();
      _user!['email'] = user['Username'];
      _user!['isAdmin'] = user['isAdmin'];
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            err.toString(),
          ),
        ),
      );
    }
  }

  Color _checkUserColor() {
    if (_user!['email'].toString().contains("red")) {
      return Colors.red;
    } else if (_user!['email'].toString().contains("blue")) {
      return Colors.blue;
    } else if (_user!['email'].toString().contains("green")) {
      return Colors.green;
    }
    return Color(0xff001253);
  }
  late Future? _getData;
  @override
  void initState() {
    
    super.initState();
    _getData = _getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },
      )),
      body: FutureBuilder(
        future: _getData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _checkUserColor(),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioListTile(
                    title: const Text("Normal user"),
                    value: false,
                    groupValue: _user!['isAdmin'],
                    onChanged: (value) {
                      setState(() {
                        _user!['isAdmin'] = value;
                      });
                    }),
                RadioListTile(
                    title: const Text("Admin"),
                    value: true,
                    groupValue: _user!['isAdmin'],
                    onChanged: (value) {
                      setState(() {
                        _user!['isAdmin'] = value;
                      });
                    }),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(uid)
                          .update({
                        "isAdmin": _user!['isAdmin'],
                      });
                      Navigator.of(context).pushNamed("/information");
                    } catch (err) {}
                  },
                  child: const Text("See information"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
