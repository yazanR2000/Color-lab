import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Auth {
   static Future signup(Map<String, dynamic> user) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user['email'],
        password: user['password'],
      );
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("Users").doc(uid).set({
        "Username" : user['email'],
        "isAdmin" : false,
      });
    } catch (err) {
      throw err;
    }
  }

   static Future login(Map<String, dynamic> user) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user['email'],
        password: user['password'],
      );
    } catch (err) {
      throw err;
    }
  }
}
