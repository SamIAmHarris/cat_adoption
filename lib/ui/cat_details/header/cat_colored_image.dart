import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class DiagonallyCutColoredImage extends StatelessWidget {

  final Image image;
  final Color color;

  DiagonallyCutColoredImage(this.image, {@required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DiagonalClipper(),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(color: color),
        child: image,
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - 50.0);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}