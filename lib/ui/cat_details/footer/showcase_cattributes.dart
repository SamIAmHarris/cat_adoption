import 'package:cat_adoption/models/cat.dart';
import 'package:flutter/material.dart';

final dynamic cattributeLookup = {
  "children": {"name": "Kid Friendly", "icon" : Icons.child_care},
  "desexed": {"name": "Desexed", "icon" : Icons.exposure},
  "vaccinated": {"name": "Vaccinated", "icon" : Icons.remove_red_eye},
  "microchipped": {"name": "Microchipped", "icon" : Icons.sd_card},
};

class CattributesShowcase extends StatelessWidget {
  final Cat cat;

  CattributesShowcase(this.cat);

  _createCircleBadge(
      IconData iconData, Color bgColor, Color iconColor, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: bgColor,
            child: Icon(
              iconData,
              color: iconColor,
              size: 36.0,
            ),
            radius: 36.0,
          ),
          Positioned(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10.0,
                color: iconColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[];

    for (var i = 0; i < cat.cattributes.length; i++) {
      var badge = _createCircleBadge(
        cattributeLookup[cat.cattributes[i]]["icon"],
        Colors.white12,
        Colors.white,
        cattributeLookup[cat.cattributes[i]]["name"]
      );

      items.add(badge);
    }

    var delegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0
    );

    return GridView(
      padding: const EdgeInsets.only(top: 16.0),
      gridDelegate: delegate,
      children: items,
    );

  }
}