import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:themize/colornames.dart';
import 'package:themize/themize.dart';

class ColorTile extends StatefulWidget {
  Color color;

  ColorTile({Key? key, required this.color}) : super(key: key) {
    ColorSystem.assertEnabled();
  }

  @override
  State<ColorTile> createState() => _ColorTileState();
}

class _ColorTileState extends State<ColorTile> {
  late bool isLight;
  late Color textColor;
  late List<double> lab;
  late MapEntry<ColorEntry, double> approximated;
  late double luminance;

  bool showApproximation = false;

  @override
  void initState() {
    super.initState();
    isLight = widget.color.computeLuminance() >= 0.5;
    textColor = isLight ? Colors.black : Colors.white;
    lab = rgb2lab(widget.color);
    luminance = widget.color.computeLuminance();
    approximated = ColorSystem.approximateKnownColor(widget.color, lab);
  }

  @override
  Widget build(BuildContext context) {
    var theme = ThemizedTheme.of(context);
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
                color:
                    showApproximation ? approximated.key.color : widget.color),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.color.toHexString()));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Copied color to clipboard!",
                          style: theme.body.copyWith(color: theme.onAccent),
                        ),
                        duration: const Duration(milliseconds: 1000),
                        backgroundColor: theme.accentDark,
                      ));
                    },
                    child: Text(
                      widget.color.toHexString(),
                      style: theme.h2.copyWith(color: textColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      showApproximation = false;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      showApproximation = false;
                    });
                  },
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: approximated.key.name));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Copied color name to clipboard!",
                          style: theme.body.copyWith(color: theme.onAccent),
                        ),
                        duration: const Duration(milliseconds: 1000),
                        backgroundColor: theme.accentDark,
                      ));
                    },
                    child: Column(
                      children: [
                        Text(
                          approximated.key.name,
                          style: theme.bodyLarge.copyWith(color: textColor.withOpacity(.8)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
