import 'package:cat_adoption/models/cat.dart';
import 'package:flutter/material.dart';


class PicturesShowcase extends StatelessWidget {
  final Cat cat;

  PicturesShowcase(this.cat);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Pictures",
        textAlign: TextAlign.center,),
    );
  }
}