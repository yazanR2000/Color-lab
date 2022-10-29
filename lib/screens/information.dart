import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Information extends StatelessWidget {
  Information({super.key});
  final uid = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot? _userData;
  Future _getUserData(BuildContext context) async {
    try {
      _userData =
          await FirebaseFirestore.instance.collection("Users").doc(uid).get();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getUserData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Email : ${_userData!['Username']}"),
                Text("isAdmin : ${_userData!['isAdmin']}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
