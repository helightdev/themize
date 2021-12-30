import 'package:flutter/material.dart';
import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:themize/themes/theme_orbit.dart';
import 'package:themize/themize.dart';

class MonochromaticTheme extends ThemizedTheme {
  MonochromaticTheme({required MaterialColor color})
      : super(
            typography: text(color: color),
            colorTheme: ColorTheme(
              backgroundHighlight: color.shade50,
              onAccent: color.shade100,
              backgroundLight: color.shade100,
              backgroundNormal: color.shade200,
              backgroundDark: color.shade300,
              textLight: color.shade700,
              textNormal: color.shade900,
              accentLight: color.shade600,
              accentNormal: color.shade700,
              accentDark: color.shade800,
              accentDarker: color.shade900,
            ),
            transformer: (data, theme) {
              return data.copyWith(
                bottomNavigationBarTheme: data.bottomNavigationBarTheme.copyWith(
                  unselectedItemColor: color.shade500
                ),
              );
            });

  static TypographyTheme text({required MaterialColor color}) {
    return OrbitTheme.text(
        textColor: color.shade900, textColorOnAccent: color.shade50);
  }
}
