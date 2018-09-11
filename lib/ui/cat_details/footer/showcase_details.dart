import 'package:cat_adoption/models/cat.dart';
import 'package:flutter/material.dart';


class DetailsShowcase extends StatelessWidget {
  final Cat cat;

  DetailsShowcase(this.cat);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Details",
        textAlign: TextAlign.center,),
    );
  }
}