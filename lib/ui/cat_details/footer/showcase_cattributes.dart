import 'package:cat_adoption/models/cat.dart';
import 'package:flutter/material.dart';


class CattributesShowcase extends StatelessWidget {
  final Cat cat;

  CattributesShowcase(this.cat);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Showcase",
      textAlign: TextAlign.center,),
    );
  }
}