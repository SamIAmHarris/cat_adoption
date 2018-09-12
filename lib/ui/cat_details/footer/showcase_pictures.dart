import 'package:cat_adoption/models/cat.dart';
import 'package:flutter/material.dart';


class PicturesShowcase extends StatelessWidget {
  final Cat cat;

  PicturesShowcase(this.cat);

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[];

    for(var i = 0; i < cat.pictures.length; i++) {
      var image = Image.network(
        cat.pictures[i],
        width: 200.0,
        height: 200.0,
      );

      items.add(image);
    }

    var delegate = SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 3.0
    );

    return GridView(
      padding: const EdgeInsets.only(top: 16.0),
      gridDelegate: delegate,
      children: items,
    );

  }
}