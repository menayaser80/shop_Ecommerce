import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:payment_stripe/consts/app_colors.dart';

import '../../root_screen.dart';
import '../../services/my_app_functions.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});
  Future<User?> _googleSignUp({required BuildContext context}) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final User? user = (await _auth.signInWithCredential(credential)).user;

      final String? name = user?.displayName ;
      final String? image = user?.photoURL ;
      final String? email = user?.email ;
      final String? uid = user?.uid ;
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        'userId': uid,
        'userName':name,
        'userImage': image,
        'userEmail': email,
        'createdAt': Timestamp.now(),
        'userWish': [],
        'userCart': [],
      });
      return user;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.all(12.0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
      ),
      icon: const Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
      label: const Text(
        "Sign in with google",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () async {
        await _googleSignUp(context: context).then((value){
          navigateTo(context, RootScreen());
        });
      },
    );
  }
}
