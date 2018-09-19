import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cat_adoption/models/cat.dart';

class CatApi {

  static FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;

  CatApi(FirebaseUser user) {
    this.firebaseUser = user;
  }

  static Future<CatApi> signInWithEmail(String email, String password) async {
    FirebaseUser emailUser = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    assert (emailUser.email != null);
    assert (!emailUser.isAnonymous);
    assert (await emailUser.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(emailUser.uid == currentUser.uid);

    return CatApi(emailUser);
  }

  static List<Cat> allCatsFromJson(String jsonData) {
    List<Cat> cats = [];
    json.decode(jsonData)['cats'].forEach((cat) => cats.add(_fromMap(cat)));
    return cats;
  }

  Future<List<Cat>> getAllCats() async {
    return (await Firestore.instance.collection('cats').getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }
  
  StreamSubscription watch(Cat cat, void onChange(Cat cat)) {
    return Firestore.instance
        .collection("cats")
        .document(cat.documentId)
        .snapshots()
        .listen((snapshot) => onChange(_fromDocumentSnapshot(snapshot)));
  }

  Future likeCat(Cat cat) async {
    await Firestore.instance
        .collection("likes")
        .document("${cat.documentId}:${this.firebaseUser.uid}")
        .setData({});
  }

  Future unlikeCat(Cat cat) async {
    await Firestore.instance
        .collection("likes")
        .document("${cat.documentId}:${this.firebaseUser.uid}")
        .delete();
  }

  Future<bool> hasLikedCat(Cat cat) async {
    final like = await Firestore.instance
        .collection("likes")
        .document("${cat.documentId}:${this.firebaseUser.uid}")
        .get();

    return like.exists;
  }

  Cat _fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return new Cat(
      documentId: snapshot.documentID,
      externalId: data['id'],
      name: data['name'],
      description: data['description'],
      avatarUrl: data['image_url'],
      location: data['location'],
      likeCounter: data['like_counter'],
      isAdopted: data['adopted'],
      pictures: new List<String>.from(data['pictures']),
      cattributes: new List<String>.from(data['cattributes']),
    );
  }

  static Cat _fromMap(Map<String, dynamic> map) {
    return new Cat(
      externalId: map['id'],
      name: map['name'],
      description: map['description'],
      avatarUrl: map['image_url'],
      location: map['location'],
      likeCounter: map['like_counter'],
      isAdopted: map['adopted'],
      pictures: new List<String>.from(map['pictures']),
      cattributes: new List<String>.from(map['cattributes']),
    );
  }
}