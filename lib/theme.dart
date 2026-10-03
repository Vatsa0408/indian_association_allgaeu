import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Headings: Quicksand. Body text: Mukta (set as the theme textTheme).
TextStyle qs(double size, {FontWeight w = FontWeight.w700}) =>
    GoogleFonts.quicksand(fontSize: size, fontWeight: w);

final lightTheme = _theme(
  const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFB75500),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFDCC2),
    onPrimaryContainer: Color(0xFF3E1D00),
    secondary: Color(0xFF146B45),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFC3F0D6),
    onSecondaryContainer: Color(0xFF04341F),
    tertiary: Color(0xFF2F5C8A),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFD3E4FA),
    onTertiaryContainer: Color(0xFF0B2A48),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFF8F2),
    onSurface: Color(0xFF26190D),
    onSurfaceVariant: Color(0xFF6F5D4D),
    surfaceContainer: Color(0xFFFBEEE1),
    surfaceContainerHigh: Color(0xFFF6E3D0),
  ),
);

final darkTheme = _theme(
  const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFB77A),
    onPrimary: Color(0xFF3E1D00),
    primaryContainer: Color(0xFF8A4300),
    onPrimaryContainer: Color(0xFFFFDCC2),
    secondary: Color(0xFF7EDBA8),
    onSecondary: Color(0xFF04341F),
    secondaryContainer: Color(0xFF0B5236),
    onSecondaryContainer: Color(0xFFC3F0D6),
    tertiary: Color(0xFFA7C8ED),
    onTertiary: Color(0xFF0B2A48),
    tertiaryContainer: Color(0xFF123A5E),
    onTertiaryContainer: Color(0xFFD3E4FA),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    surface: Color(0xFF19120B),
    onSurface: Color(0xFFF2E4D4),
    onSurfaceVariant: Color(0xFFD2BFA9),
    surfaceContainer: Color(0xFF221A12),
    surfaceContainerHigh: Color(0xFF2C2117),
  ),
);

ThemeData _theme(ColorScheme cs) {
  final base = ThemeData(brightness: cs.brightness);
  return ThemeData(
    colorScheme: cs,
    scaffoldBackgroundColor: cs.surface,
    textTheme: GoogleFonts.muktaTextTheme(
      base.textTheme,
    ).apply(bodyColor: cs.onSurface, displayColor: cs.onSurface),
  );
}
