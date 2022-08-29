import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FDProvider extends ChangeNotifier {
  void AddData(
      {String? id,
      String? title,
      String? cate,
      String? desc,
      String? img,
      String? key}) {
    var firebaseDatabase = FirebaseDatabase.instance;
    var FDBref = firebaseDatabase.ref();

    if (key == null) {
      FDBref.child("Recipe").push().set(
          {"id": id, "title": title, "cate": cate, "desc": desc, "img": img});
    } else {
      FDBref.child("Recipe").child(key).set(
          {"id": id, "title": title, "cate": cate, "desc": desc, "img": img});
    }
  }

  Stream<DatabaseEvent> readData() {
    var firebaseDatabase = FirebaseDatabase.instance;
    var FDBref = firebaseDatabase.ref();
    return FDBref.child("Recipe").onValue;
  }

  void Delete(String? key) {
    var firebaseDatabase = FirebaseDatabase.instance;
    var FDBref = firebaseDatabase.ref();
    FDBref.child("Recipe").child(key!).remove();
  }
}

class ModelRecipe {
  String? id, title, cate, desc, img, key;

  ModelRecipe({this.id, this.title, this.cate, this.desc, this.img, this.key});
}
