import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RagiProvider extends ChangeNotifier {
  Future<String> createAccount(String email, String password) async {
    String msg = " ";
    var firebaseAuth = FirebaseAuth.instance;

    try {
      var res = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      msg = "You are successfully registered";
    }
    on FirebaseAuthException catch (e) {
      if (e.code == "Week-password") {
        msg = "Password is too short";
      }
      else if (e.code == "email-in-already-use") {
        msg = "You are is already registered";
      }
    }
    return msg;
  }

  Future<String> loginUser(String email, String password) async {
    String msg = "";
    var firebaseAuth = FirebaseAuth.instance;
    try {
      var res = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      msg = "You are login Successfully";
    }
    on FirebaseAuthException catch(e){
      if (e.code == "User-Not-Found") {
        msg = "No user found for that email";
      }
      else if (e.code == "Wrong-password") {
        msg = "wrong password provided for that user";
      }
    }
    return msg;
  }

  bool chckUser(){
    var firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    if(user!=null)
      {
        return true;
      }
    else{
      return false;
    }
  }

  void signOut(){
    var firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.signOut();
  }

}
