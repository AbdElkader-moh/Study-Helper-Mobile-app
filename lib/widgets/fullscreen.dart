import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
class FullScreenImage extends StatelessWidget {
  Uint8List imageBytes;
  FullScreenImage({required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: 'image',
          child: Image.memory(imageBytes, fit: BoxFit.contain),
        ),
      ),
    );
  }
}