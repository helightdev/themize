part of 'themize.dart';

const double phiMajor = 0.61803398875;
const double phiMinor = 0.38196601125;
const phiMinorMajor = phiMajor * phiMinor;
const phiMinorMinor = phiMinor * phiMinor;

class SpacingTheme {
  final double gridSize;
  final Map<int, double> spacing;

  const SpacingTheme({required this.gridSize, required this.spacing});

  double getSpacingAt(int pos) => spacing[pos] ?? (gridSize * pos);
}

class DefaultSpacing extends SpacingTheme {
  const DefaultSpacing()
      : super(gridSize: 8, spacing: const {
          1: 8.0,
          2: 12.0,
          3: 16.0,
          4: 24.0,
          5: 32.0,
          6: 48.0
        });
}

class GridSpacer extends StatelessWidget {
  int wAmount;
  int hAmount;

  GridSpacer({
    required this.wAmount,
    required this.hAmount,
  });

  factory GridSpacer.horizontal({int amount = 1}) {
    return GridSpacer(wAmount: amount, hAmount: 0);
  }

  factory GridSpacer.vertical({int amount = 1}) {
    return GridSpacer(wAmount: 0, hAmount: amount);
  }

  @override
  Widget build(BuildContext context) {
    var theme = ThemizedTheme.of(context);
    return SizedBox(
      width: theme.spacingTheme.getSpacingAt(wAmount),
      height: theme.spacingTheme.getSpacingAt(hAmount),
    );
  }
}

class GridPadding extends StatelessWidget {
  Widget child;
  int top;
  int left;
  int right;
  int bottom;

  GridPadding(
      {Key? key,
      required this.child,
      this.top = 1,
      this.bottom = 1,
      this.left = 1,
      this.right = 1})
      : super(key: key);

  factory GridPadding.all({required Widget child, int amount = 1}) {
    return GridPadding(
        child: child, left: amount, right: amount, bottom: amount, top: amount);
  }

  factory GridPadding.only(
      {required Widget child,
      int top = 0,
      int bottom = 0,
      int left = 0,
      int right = 0}) {
    return GridPadding(
      child: child,
      left: left,
      right: right,
      bottom: bottom,
      top: top,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = ThemizedTheme.of(context);
    var padding = EdgeInsets.only(
        left: theme.spacingTheme.getSpacingAt(left),
        right: theme.spacingTheme.getSpacingAt(right),
        top: theme.spacingTheme.getSpacingAt(top),
        bottom: theme.spacingTheme.getSpacingAt(bottom));
    return Padding(padding: padding, child: child);
  }
}
