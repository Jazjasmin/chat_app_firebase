// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print, prefer_const_constructors

//TODO 6a: import firebase auth and google sign in packages

import 'package:flutter/material.dart'; //To invoke a snackbar
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

//TODO 7: Create Auth Services class and write function to sign IN/Sign up using google account
class AuthServices {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try{
      GoogleSignInAccount? googleSignInAccount =await googleSignIn.signIn();
      if(googleSignInAccount != null){
        GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        try{
          UserCredential userCredential =await firebaseAuth.signInWithCredential(credential);
          Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
        }catch (e){
          final snackBar =SnackBar(content: Text(
            "Could not sign in due to  {$e}",
            style: TextStyle(color: Color(0xffFFF3B0),
            backgroundColor: Color(0xff37007C)),));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }else {
         final snackBar =SnackBar(content: Text(
            "Could not sign in due to error",
            style: TextStyle(color: Color(0xffFFF3B0),
            backgroundColor: Color(0xff37007C)),));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

    }catch (e){
       final snackBar =SnackBar(content: Text(
            "Could not sign in due to error ($e)",
            style: TextStyle(color: Color(0xffFFF3B0),
            backgroundColor: Color(0xff37007C)),));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }



  Future<void> signOutOfGoogle(BuildContext context) async {
    try {
      googleSignIn.signOut();
      firebaseAuth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    }catch(e){
      final snackBar =SnackBar(content: Text(
            "An error occured due to  {$e}",
            style: TextStyle(color: Color(0xffFFF3B0),
            backgroundColor: Color(0xff37007C)),));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }

}


