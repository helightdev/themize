part of 'themize.dart';

extension TextExtension on Text {
  Text copyWithStyle({required TextStyle style}) => Text(data!,
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior);

  Widget get title => Builder(
      builder: (context) =>
          copyWithStyle(style: ThemizedTheme.of(context).title));

  Widget get subtitle => Builder(
      builder: (context) =>
          copyWithStyle(style: ThemizedTheme.of(context).subtitle));

  Widget get h1 => Builder(
      builder: (context) => copyWithStyle(style: ThemizedTheme.of(context).h1));

  Widget get h2 => Builder(
      builder: (context) => copyWithStyle(style: ThemizedTheme.of(context).h2));

  Widget get h3 => Builder(
      builder: (context) => copyWithStyle(style: ThemizedTheme.of(context).h3));

  Widget get h4 => Builder(
      builder: (context) => copyWithStyle(style: ThemizedTheme.of(context).h4));

  Widget get h5 => Builder(
      builder: (context) => copyWithStyle(style: ThemizedTheme.of(context).h5));

  Widget get bodySmall => Builder(
      builder: (context) =>
          copyWithStyle(style: ThemizedTheme.of(context).bodySmall));

  Widget get body => Builder(
      builder: (context) =>
          copyWithStyle(style: ThemizedTheme.of(context).body));

  Widget get bodyLarge => Builder(
      builder: (context) =>
          copyWithStyle(style: ThemizedTheme.of(context).bodyLarge));

  Widget get button => Builder(
      builder: (context) =>
          copyWithStyle(style: ThemizedTheme.of(context).button));
}

typedef TextThemeColorBuilder = TextStyle Function(ColorTheme colors);

class TypographyTheme {
  final TextThemeColorBuilder title;
  final TextThemeColorBuilder subtitle;

  final TextThemeColorBuilder h1;
  final TextThemeColorBuilder h2;
  final TextThemeColorBuilder h3;
  final TextThemeColorBuilder h4;
  final TextThemeColorBuilder h5;

  final TextThemeColorBuilder bodySmall;
  final TextThemeColorBuilder body;
  final TextThemeColorBuilder bodyLarge;

  final TextThemeColorBuilder button;

  const TypographyTheme({
    required this.title,
    required this.subtitle,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.h4,
    required this.h5,
    required this.bodySmall,
    required this.body,
    required this.bodyLarge,
    required this.button,
  });
}