part of 'themize.dart';

class ColorTheme {
  final Color backgroundHighlight;

  final Color backgroundLight;
  final Color backgroundNormal;
  final Color backgroundDark;

  final Color textLight;
  final Color textNormal;

  final Color accentLight;
  final Color accentNormal;
  final Color accentDark;
  final Color accentDarker;

  final Color onAccent;

  ColorTheme(
      {required this.backgroundHighlight,
      required this.backgroundLight,
      required this.backgroundNormal,
      required this.backgroundDark,
      required this.textLight,
      required this.textNormal,
      required this.accentLight,
      required this.accentNormal,
      required this.accentDark,
      required this.accentDarker,
      required this.onAccent}) {
    brightness = backgroundLight.computeLuminance() >= 0.5
        ? Brightness.light
        : Brightness.dark;
  }

  late Brightness brightness;

  ColorScheme get colorScheme {
    return ColorScheme(
        primary: accentNormal,
        primaryVariant: accentDark,
        secondary: accentNormal,
        secondaryVariant: accentDark,
        surface: backgroundHighlight,
        background: backgroundLight,
        error: Colors.red,
        onPrimary: onAccent,
        onSecondary: onAccent,
        onSurface: textNormal,
        onBackground: textNormal,
        onError: Colors.white,
        brightness: brightness);
  }
}

extension MaterialColorExtension on MaterialColor {

  MaterialColor chromatized() {
    return MaterialColor(this.value, {
      50: Colors.white,
      100: HsbColor.fromColor(shade50).copyWith(brightness: 98, saturation: 6),
      200: shade100,
      300: shade200,
      400: shade400,
      500: shade500,
      600: shade600,
      700: shade800,
      800: shade900,
      900: Colors.black
    });
  }

}


class ColorSystem {
  static List<ColorEntry>? nameMap;
  static bool enabled = false;
  static Map<Color, MapEntry<ColorEntry, double>> cache = {};

  static void assertEnabled() {
    assert(enabled);
    assert(nameMap != null);
  }

  static Future enable() async {
    nameMap = await ColorNames.parse();
    enabled = true;
  }

  static MapEntry<ColorEntry, double> approximateKnownColor(Color color, List<double> lab) {
    if (cache.containsKey(color)) return cache[color]!;
    var distances = nameMap!
        .map((it) {
      var dR = (color.red - it.color.red).abs();
      var dG = (color.green - it.color.green).abs();
      var dB = (color.blue - it.color.blue).abs();
      var distance = dR + dG + dB;
      return MapEntry(it, distance.toDouble());
    }).toList();
    distances.sort((a, b) => a.value.compareTo(b.value));
    var simple = distances.first;
    if (simple.value <= 8) return simple;

    distances = nameMap!
        .map((it) {
          var distance = calculateDeltaE(lab, it.lab);
          return MapEntry(it, distance);
        })
        .toList();
    distances.sort((a, b) => a.value.compareTo(b.value));
    cache[color] = distances.first;
    return distances.first;
  }
}

extension StringColorExtension on String {
  Color parseHexColor() {
    var value = replaceFirst("#", "");
    var r = ""; var g = ""; var b = ""; var a = "FF";
    if (value.length == 3) {
      var runes = value.split("");
      r = runes[0] + runes[0];
      g = runes[1] + runes[1];
      b = runes[2] + runes[2];
    } else if (value.length == 6) {
      var runes = value.split("");
      r = runes[0] + runes[1];
      g = runes[2] + runes[3];
      b = runes[4] + runes[5];
    } else if (value.length == 8) {
      var runes = value.split("");
      a = runes[0] + runes[1];
      r = runes[2] + runes[3];
      g = runes[4] + runes[5];
      b = runes[6] + runes[7];
    }
    return Color.fromARGB(int.parse(a, radix: 16), int.parse(r, radix: 16), int.parse(g, radix: 16), int.parse(b, radix: 16));
  }
}

extension ColorStringExtension on Color {
  String toHexString({prefixLeadingHashSign = true, uppercase = true}) {
    var buffer = prefixLeadingHashSign ? "#" : "";
    buffer += red.toRadixString(16);
    buffer += green.toRadixString(16);
    buffer += blue.toRadixString(16);
    return uppercase ? buffer.toUpperCase() : buffer.toLowerCase();
  }
}

double _rgb2lab_normalizeRgbChannel(channel) {
  channel /= 255;

  return 100.0 *
      (channel > 0.04045
          ? pow((channel + 0.055) / 1.055, 2.4).toDouble()
          : channel / 12.92);
}

double _rgb2labNormalizeXyzChannel(channel) {
  return (channel > 0.008856)
      ? pow(channel, 1 / 3).toDouble()
      : (7.787 * channel) + (16 / 116);
}

/// https://gist.github.com/manojpandey/f5ece715132c572c80421febebaf66ae
List<double> rgb2lab(Color color) {
  var r = _rgb2lab_normalizeRgbChannel(color.red);
  var g = _rgb2lab_normalizeRgbChannel(color.green);
  var b = _rgb2lab_normalizeRgbChannel(color.blue);

  var x = r * 0.4124 + g * 0.3576 + b * 0.1805;
  var y = r * 0.2126 + g * 0.7152 + b * 0.0722;
  var z = r * 0.0193 + g * 0.1192 + b * 0.9505;

  x = _rgb2labNormalizeXyzChannel(x / 95.0470);
  y = _rgb2labNormalizeXyzChannel(y / 100.0);
  z = _rgb2labNormalizeXyzChannel(z / 108.883);

  return [
    roundDecimals(((116 * y) - 16).toDouble(), 3), // L
    roundDecimals((500 * (x - y)).toDouble(), 3), // a
    roundDecimals((200 * (y - z)).toDouble(), 3), // b
  ];
}

double roundDecimals(double x, int a) {
  var b = pow(10, a);
  return (x * b).round() / b;
}

double calculateDeltaE(List<double> lab1, List<double> lab2) {
  return _calculateDeltaE(lab1[0], lab1[1], lab1[2], lab2[0], lab2[1], lab2[2]);
}

double _calculateDeltaE(
    double L1, double a1, double b1, double L2, double a2, double b2) {
  double Lmean = (L1 + L2) / 2.0;
  double C1 = sqrt(a1 * a1 + b1 * b1);
  double C2 = sqrt(a2 * a2 + b2 * b2);
  double Cmean = (C1 + C2) / 2.0;
  double G = (1 - sqrt(pow(Cmean, 7) / (pow(Cmean, 7) + pow(25, 7)))) / 2;
  double a1prime = a1 * (1 + G);
  double a2prime = a2 * (1 + G);
  double C1prime = sqrt(a1prime * a1prime + b1 * b1);
  double C2prime = sqrt(a2prime * a2prime + b2 * b2);
  double Cmeanprime = (C1prime + C2prime) / 2;
  double h1prime =
      atan2(b1, a1prime) + 2 * pi * (atan2(b1, a1prime) < 0 ? 1 : 0);
  double h2prime =
      atan2(b2, a2prime) + 2 * pi * (atan2(b2, a2prime) < 0 ? 1 : 0);
  double Hmeanprime = (((h1prime - h2prime).abs() > pi)
      ? (h1prime + h2prime + 2 * pi) / 2
      : (h1prime + h2prime) / 2);
  double T = 1.0 -
      0.17 * cos(Hmeanprime - pi / 6.0) +
      0.24 * cos(2 * Hmeanprime) +
      0.32 * cos(3 * Hmeanprime + pi / 30) -
      0.2 * cos(4 * Hmeanprime - 21 * pi / 60);
  double deltahprime = (((h1prime - h2prime).abs() <= pi)
      ? h2prime - h1prime
      : (h2prime <= h1prime)
          ? h2prime - h1prime + 2 * pi
          : h2prime - h1prime - 2 * pi);
  double deltaLprime = L2 - L1;
  double deltaCprime = C2prime - C1prime;
  double deltaHprime = 2.0 * sqrt(C1prime * C2prime) * sin(deltahprime / 2.0);
  double SL = 1.0 +
      ((0.015 * (Lmean - 50) * (Lmean - 50)) /
          (sqrt(20 + (Lmean - 50) * (Lmean - 50))));
  double SC = 1.0 + 0.045 * Cmeanprime;
  double SH = 1.0 + 0.015 * Cmeanprime * T;
  double deltaTheta = (30 * pi / 180) *
      exp(-((180 / pi * Hmeanprime - 275) / 25) *
          ((180 / pi * Hmeanprime - 275) / 25));
  double RC =
      (2 * sqrt(pow(Cmeanprime, 7) / (pow(Cmeanprime, 7) + pow(25, 7))));
  double RT = (-RC * sin(2 * deltaTheta));
  double KL = 1;
  double KC = 1;
  double KH = 1;
  double deltaE = sqrt(((deltaLprime / (KL * SL)) * (deltaLprime / (KL * SL))) +
      ((deltaCprime / (KC * SC)) * (deltaCprime / (KC * SC))) +
      ((deltaHprime / (KH * SH)) * (deltaHprime / (KH * SH))) +
      (RT * (deltaCprime / (KC * SC)) * (deltaHprime / (KH * SH))));

  return deltaE;
}