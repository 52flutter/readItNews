import 'package:flutter/widgets.dart';

import 'data_classes.dart';

abstract class Config {
  Uri get baseUrl;
  EdgeInsets get bodyPadding;
  NodeMetadataCollector get builderCallback;
  Color get hyperlinkColor;
  OnTapUrl get onTapUrl;
  EdgeInsets get tableCellPadding;
  double get wrapSpacing;
}

typedef void OnTapUrl(String url, {String title});
