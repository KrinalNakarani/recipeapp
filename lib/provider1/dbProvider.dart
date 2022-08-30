import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FDProvider extends ChangeNotifier {
  void AddData(String id, String title, String cate, String desc, String img) {
    var firebaseDatabase = FirebaseDatabase.instance;
    var FDBref = firebaseDatabase.ref();
    FDBref.child("Recipe").push().set(
        {"id": id, "title": title, "cate": cate, "desc": desc, "img": img});
  }

  Stream<DatabaseEvent> readData() {
    var firebaseDatabase = FirebaseDatabase.instance;
    var FDBref = firebaseDatabase.ref();
    return FDBref.child("Recipe").onValue;
  }
  void Delete(){}


}

class ModelRecipe {
  String? id, title, cate, desc, img;

  ModelRecipe({this.id, this.title, this.cate, this.desc, this.img});
}
