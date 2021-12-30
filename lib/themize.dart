library themize;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:provider/provider.dart';
import 'package:themize/color/color_tile.dart';
import 'package:themize/colornames.dart';

part 'text.dart';
part 'color.dart';
part 'spacing.dart';

class ThemeProvider extends StatelessWidget {
  const ThemeProvider({Key? key, required this.child, required this.theme})
      : super(key: key);

  final Widget child;
  final ThemizedTheme theme;

  @override
  Widget build(BuildContext context) {
    return Provider<ThemizedTheme>(
      create: (context) => theme,
      child: Theme(
        child: child,
        data: theme.themeData,
      ),
    );
  }
}

typedef ThemeDataTransformer = ThemeData Function(ThemeData, ThemizedTheme);

ThemeData _noTransformer(input,_) => input;

class ThemizedTheme {

  TypographyTheme typography;
  ColorTheme colorTheme;
  ThemeDataTransformer transformer;
  SpacingTheme spacingTheme;

  ThemizedTheme({
    required this.typography,
    required this.colorTheme,
    this.spacingTheme = const DefaultSpacing(),
    this.transformer = _noTransformer
  });

  /* Spacing */
  /// Scaffold background color
  Color get bgLight => colorTheme.backgroundLight;
  /// One step darker than the scaffold background
  Color get bgNormal => colorTheme.backgroundNormal;
  /// Border color for widgets (mostly unfocused)
  Color get bgDark => colorTheme.backgroundDark;
  /// Background color for cards and input fields
  Color get bgHighlight => colorTheme.backgroundHighlight;
  /// Primarily used text color
  Color get textColor1 => colorTheme.textNormal;
  /// Lighter variant of text color
  Color get textColor2 => colorTheme.textNormal;
  /// Accent color used as secondary color
  Color get accentNormal => colorTheme.accentNormal;
  /// Light hue of the accent color that can be used as a background
  Color get accentLight => colorTheme.accentLight;
  /// Dark variant of the accent color
  Color get accentDark => colorTheme.accentDark;
  /// Dark variant of the accent color
  Color get accentDarker => colorTheme.accentDarker;
  /// color that can be drawn on the accent
  Color get onAccent => colorTheme.onAccent;

  /* Spacing */
  double get s1 => spacingTheme.getSpacingAt(1);
  double get s2 => spacingTheme.getSpacingAt(2);
  double get s3 => spacingTheme.getSpacingAt(3);
  double get s4 => spacingTheme.getSpacingAt(4);
  double get s5 => spacingTheme.getSpacingAt(5);
  double get s6 => spacingTheme.getSpacingAt(6);

  /* Text Styles */
  TextStyle get title => typography.title(colorTheme);
  TextStyle get subtitle => typography.subtitle(colorTheme);
  TextStyle get h1 => typography.h1(colorTheme);
  TextStyle get h2 => typography.h2(colorTheme);
  TextStyle get h3 => typography.h3(colorTheme);
  TextStyle get h4 => typography.h4(colorTheme);
  TextStyle get h5 => typography.h5(colorTheme);
  TextStyle get bodySmall => typography.bodySmall(colorTheme);
  TextStyle get body => typography.body(colorTheme);
  TextStyle get bodyLarge => typography.bodyLarge(colorTheme);
  TextStyle get button => typography.button(colorTheme);

  ThemeData get themeData {
    var data = ThemeData.from(colorScheme: colorTheme.colorScheme);
    data = data.copyWith(
        sliderTheme: SliderThemeData(
            thumbColor: colorTheme.accentNormal,
            valueIndicatorColor: colorTheme.accentDark,
            activeTrackColor: colorTheme.accentNormal,
            inactiveTrackColor: colorTheme.accentLight),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colorTheme.accentNormal),
        )),
        textTheme: TextTheme(
          headline6: bodyLarge, headline5: h5, headline4: h4, headline3: h3, headline2: h2, headline1: h1,
          bodyText1: bodyLarge, bodyText2: body, caption: bodySmall, button: button, subtitle1: h3, subtitle2: h2
        ),
        switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? colorTheme.accentNormal
                    : colorTheme.textLight),
            trackColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? colorTheme.accentLight
                    : colorTheme.backgroundDark)),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: body,
          hintStyle: body.copyWith(color: colorTheme.backgroundDark),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: colorTheme.backgroundDark)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorTheme.backgroundDark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorTheme.accentNormal)),
          fillColor: colorTheme.backgroundHighlight,
        ),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: colorTheme.textNormal,
            selectionColor: colorTheme.backgroundDark),
        appBarTheme: AppBarTheme(
            backgroundColor: colorTheme.backgroundHighlight, elevation: 1),
        bottomAppBarColor: colorTheme.backgroundHighlight,

        disabledColor: colorTheme.backgroundDark,
        unselectedWidgetColor: colorTheme.textLight,

        chipTheme: ChipThemeData(
            backgroundColor: colorTheme.backgroundNormal,
            brightness: colorTheme.brightness,
            labelStyle: bodySmall,
            selectedColor: colorTheme.accentNormal,
            secondarySelectedColor: colorTheme.accentNormal,
            secondaryLabelStyle: bodySmall.copyWith(color: colorTheme.onAccent),
            disabledColor: colorTheme.backgroundDark,
            padding: EdgeInsets.all(8)
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: colorTheme.backgroundHighlight,
        ));
    data = transformer(data, this);
    return data;
  }

  static ThemizedTheme of(BuildContext context) =>
      Provider.of<ThemizedTheme>(context, listen: false);
}

