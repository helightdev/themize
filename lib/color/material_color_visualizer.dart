import 'package:flutter/material.dart';
import 'package:themize/color/color_tile.dart';
import 'package:themize/themize.dart';

class MaterialColorVisualizer extends StatelessWidget {
  MaterialColor color;

  MaterialColorVisualizer({Key? key, required this.color}) : super(key: key) {
    ColorSystem.assertEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
            child: ColorTile(
              color: color.shade50,
            )),
        Flexible(
            child: ColorTile(
              color: color.shade100,
            )),
        Flexible(
            child: ColorTile(
              color: color.shade200,
            )),
        Flexible(
            child: ColorTile(
              color: color.shade300,
            )),
        Flexible(
            child: ColorTile(
              color: color.shade400,
            )),
        Flexible(
            child: ColorTile(
              color: color.shade500,
            )),
        Flexible(
            child: ColorTile(
              color: color.shade600,
            )),
        Flexible(
            child: ColorTile(
              color: color.shade700,
            )),
        Flexible(
            child: ColorTile(
              color: color.shade800,
            )),
        Flexible(
            child: ColorTile(
              color: color.shade900,
            ))
      ],
    );
  }
}