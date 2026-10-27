import 'package:flutter/material.dart';

class AppLiquidGlass {
  static const bool enabled = true;

  static const double blurSigma = 24.0;
  static const double spread = 1.0;
  static const double refraction = 30.0;
  static const double chroma = 0.09;
  static const double specular = 0.60;
  static const double rimWidth = 6.0;
  static const Offset light = Offset(-0.4, -1.0);
  static const double tintFeather = 36.0;

  static Color navTint(ColorScheme cs) =>
      cs.surface.withValues(alpha: 0.72);

  static Color panelTint(ColorScheme cs) =>
      cs.surface.withValues(alpha: 0.60);
}
