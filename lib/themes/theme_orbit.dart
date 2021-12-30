import 'package:flutter/material.dart';
import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:themize/themize.dart';

class OrbitTheme extends ThemizedTheme {
  OrbitTheme(
      {required Color accent,
      Color? accentLight,
      Color? accentNormal,
      Color? accentDark,
      Color? accentDarker,

      Color? textColor, Color? textColorOnAccent
      })
      : super(
            typography: text(textColor: textColor, textColorOnAccent: textColorOnAccent),
            colorTheme: colorForProduct(
                accent: accent,
                accentLight: accentLight,
                accentNormal: accentNormal,
                accentDark: accentDark,
                accentDarker: accentDarker));

  static InputDecoration inputDecoration(BuildContext context) {
    var theme = ThemizedTheme.of(context);
    return InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide(color: theme.colorTheme.backgroundDark)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.colorTheme.backgroundDark)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.colorTheme.textNormal)),
      fillColor: theme.colorTheme.backgroundHighlight,
    );
  }

  static ColorTheme colorForProduct(
      {required Color accent,
      Color? accentLight,
      Color? accentNormal,
      Color? accentDark,
      Color? accentDarker}) {
    var hsb = HsbColor.fromColor(accent);
    return ColorTheme(
        backgroundHighlight: const Color(0xFFFFFFFF),
        onAccent: const Color(0xFFFFFFFF),
        backgroundLight: const Color(0xFFF5F7F9),
        backgroundNormal: const Color(0xFFEFF2F5),
        backgroundDark: const Color(0xFFE8EDF1),
        textLight: const Color(0xFF4F5E71),
        textNormal: const Color(0xFF252A31),
        accentLight: accentLight ?? hsb.copyWith(brightness: 97, saturation: 5),
        accentNormal: accent,
        accentDark: accentDark ?? hsb.copyWith(brightness: 50),
        accentDarker: accentDarker ?? hsb.copyWith(brightness: 36));
  }

  static TypographyTheme text({Color? textColor, Color? textColorOnAccent}) {
    return TypographyTheme(
      title: (color) => TextStyle(color: textColor ?? color.textNormal, fontSize: 48),
      subtitle: (color) => TextStyle(color: textColor ?? color.textNormal, fontSize: 22),
      h1: (color) => TextStyle(color: textColor ?? color.textNormal, fontSize: 28),
      h2: (color) => TextStyle(color: textColor ?? color.textNormal, fontSize: 22),
      h3: (color) => TextStyle(color: textColor ?? color.textNormal, fontSize: 16),
      h4: (color) => TextStyle(color: textColor ?? color.textNormal, fontSize: 14),
      h5: (color) => TextStyle(color: textColor ?? color.textNormal, fontSize: 12),
      bodySmall: (color) => TextStyle(color: textColor ?? color.textNormal, fontSize: 12),
      body: (color) => TextStyle(color: textColor ?? color.textNormal, fontSize: 14),
      bodyLarge: (color) => TextStyle(color: textColor ?? color.textNormal, fontSize: 16),
      button: (color) => TextStyle(color: textColorOnAccent ?? color.onAccent, fontSize: 16),
    );
  }
}
