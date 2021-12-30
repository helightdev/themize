import 'package:flutter/material.dart';
import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:themize/themize.dart';

import 'theme_orbit.dart';

class DualSwatchTheme extends ThemizedTheme {
  DualSwatchTheme(
      {
        required MaterialColor primary,
        required MaterialColor secondary,
      })
      : super(
            typography: OrbitTheme.text(textColor: primary.shade900, textColorOnAccent: primary.shade50),
            colorTheme: colorFor(primary: primary, secondary: secondary));

  static ColorTheme colorFor(
      {
        required MaterialColor primary,
        required MaterialColor secondary
      }) {
    return ColorTheme(
        backgroundHighlight: primary.shade50,
        onAccent: primary.shade50,
        backgroundLight: primary.shade100,
        backgroundNormal: primary.shade200,
        backgroundDark: primary.shade300,
        textLight: primary.shade800,
        textNormal: primary.shade900,
        accentLight: secondary.shade100,
        accentNormal: secondary.shade600,
        accentDark: secondary.shade700,
        accentDarker: secondary.shade800
    );
  }
}
