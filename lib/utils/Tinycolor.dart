import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class Utils {
// Return a valid alpha value [0,1] with all invalid values being set to 1
  double boundAlpha(double a) {
    if (a == null || a < 0 || a > 1) {
      a = 1;
    }
    return a;
  }

  // Check to see if string passed in is a percentage
  bool isPercentage(String n) {
    if (n == null) {
      return false;
    } else {
      return n.contains("%");
    }
  }

  // Force a hex value to have 2 characters
  String pad2(String c) {
    return c.length == 1 ? '0' + c : '' + c;
  }

  // Replace a decimal with it's percentage value
  String convertToPercentage(double n) {
    if (n <= 1) {
      return (n * 100).toString() + "%";
    }
    return n.toString();
  }

  // Converts a decimal to a hex value
  String convertDecimalToHex(double d) {
    return (d * 255).round().toRadixString(16);
  }
}

class TinyColor {
  final trimLeft = new RegExp(r'^\s+'),
      trimRight = new RegExp(r'\s+$'),
      tinyCounter = 0;
  int _r, _g, _b, _a;
  Color _originalInput = null;
  TinyColor(Color color) {
    this._originalInput = color;
    this._r = color.red;
    this._g = color.green;
    this._b = color.blue;
    this._a = color.alpha;

    //     this._roundA = mathRound(100*this._a) / 100,
    // this._format = opts.format || rgb.format;
    // this._gradientType = opts.gradientType;
  }

  String toHexString(allow3Char) {
    return '#' + toHex(allow3Char);
  }

  String toHex(allow3Char) {
    return rgbToHex(this._r, this._g, this._b, allow3Char);
  }

  String pad2(String c) {
    return c.length == 1 ? '0' + c : '' + c;
  }

  // rgbToHex
// Converts an RGB color to hex
// Assumes r, g, and b are contained in the set [0, 255]
// Returns a 3 or 6 character hex
  String rgbToHex(int r, int g, int b, bool allow3Char) {
    var hex = [
      pad2(r.toRadixString(16)),
      pad2(g.toRadixString(16)),
      pad2(b.toRadixString(16))
    ];
    // Return a 3 character hex if possible
    if (allow3Char &&
        hex[0][0] == hex[0][1] &&
        hex[1][0] == hex[1][1] &&
        hex[2][0] == hex[2][1]) {
      return hex[0][0] + hex[1][0] + hex[2][0];
    }
    return hex.join("");
  }
}
