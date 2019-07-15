import 'package:flutter/painting.dart';
import 'package:tinycolor/tinycolor.dart';

class ColorPaletteMixin {
  double hueStep = 2;
  double saturationStep = 16;
  double saturationStep2 = 5;
  double brightnessStep1 = 5;
  double brightnessStep2 = 15;
  int lightColorCount = 5;
  double darkColorCount = 4;

  double _getHue(HSVColor hsv, int i, bool isLight) {
    double hue;
    if (hsv.hue >= 60 && hsv.hue <= 240) {
      hue = isLight ? hsv.hue - hueStep * i : hsv.hue + hueStep * i;
    } else {
      hue = isLight ? hsv.hue + hueStep * i : hsv.hue - hueStep * i;
    }
    if (hue < 0) {
      hue += 360;
    } else if (hue >= 360) {
      hue -= 360;
    }
    return hue;
  }

  double _getSaturation(HSVColor hsv, int i, bool isLight) {
    double saturation;
    if (isLight) {
      saturation = (hsv.saturation * 100).round() - saturationStep * i;
    } else if (i == darkColorCount) {
      saturation = (hsv.saturation * 100).round() + saturationStep;
    } else {
      saturation = (hsv.saturation * 100).round() + saturationStep2 * i;
    }
    if (saturation > 100) {
      saturation = 100;
    }
    if (isLight && i == lightColorCount && saturation > 10) {
      saturation = 10;
    }
    if (saturation < 6) {
      saturation = 6;
    }
    return (saturation).round() / 100;
  }

  double _getValue(HSVColor hsv, int i, bool isLight) {
    double res;
    if (isLight) {
      res = ((hsv.value * 100) + brightnessStep1 * i);
    }
    res = ((hsv.value * 100) - brightnessStep2 * i);
    if (res < 0) {
      res = 0;
    }
    if (res > 100) {
      res = 100;
    }
    return res.round() / 100;
  }

  Color colorPalette(int index, {String color}) {
    if (color == null) {
      color = "#1890ff";
    }
    index = 4;
    bool isLight = index <= 6;
    int i = isLight ? lightColorCount + 1 - index : index - lightColorCount - 1;

    var hsv = TinyColor.fromString(color).toHsv();

    var res = TinyColor.fromHSV(
      HSVColor.fromAHSV(
        hsv.alpha,
        _getHue(hsv, i, isLight),
        _getSaturation(hsv, i, isLight),
        _getValue(hsv, i, isLight),
      ),
    );

    print(
        'color_${index}::::${res.color.alpha}-${res.color.red}-${res.color.green}-${res.color.blue}'
            .toString());
    return res.color;

    // var res = new HSV(
    //     h: _getHue(hsv, i, isLight),
    //     s: _getSaturation(hsv, i, isLight),
    //     v: _getValue(hsv, i, isLight));
    // TinyColor.fromHSV(hsv)
    //   return tinycolor({
    //   h: getHue(hsv, i, isLight),
    //   s: getSaturation(hsv, i, isLight),
    //   v: getValue(hsv, i, isLight),
    // }).toHexString();
    // return new Color.fromRGBO(res.h, res.s, res.v, 1);
  }
}

ColorPaletteMixin globalColorPalette = new ColorPaletteMixin();
