import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/syntax_theme.dart';
import 'package:flutter_syntax_view/syntaxes/dart.dart';
import 'package:flutter_syntax_view/syntaxes/java.dart';
import 'package:flutter_syntax_view/syntaxes/javascript.dart';
import 'package:flutter_syntax_view/syntaxes/kotlin.dart';
import 'package:flutter_syntax_view/syntaxes/swift.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

///Supported Syntaxes Enum

class SyntaxWidget extends StatefulWidget {
  SyntaxWidget(
      {@required this.code, @required this.syntax, @required this.syntaxTheme});

  final String code;
  final Syntax syntax;
  final SyntaxTheme syntaxTheme;

  dynamic getSyntax(Syntax syntax) {
    switch (syntax) {
      case Syntax.DART:
        return DartSyntaxHighlighter(this.syntaxTheme);
      case Syntax.JAVA:
        return JavaSyntaxHighlighter(this.syntaxTheme);
      case Syntax.KOTLIN:
        return KotlinSyntaxHighlighter(this.syntaxTheme);
      case Syntax.SWIFT:
        return SwiftSyntaxHighlighter(this.syntaxTheme);
      case Syntax.JAVASCRIPT:
        return JavaScriptSyntaxHighlighter(this.syntaxTheme);
      default:
        return DartSyntaxHighlighter(this.syntaxTheme);
    }
  }

  @override
  State<StatefulWidget> createState() => SyntaxWidgetState();
}

class SyntaxWidgetState extends State<SyntaxWidget> {
  double textScaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    assert(widget.code != null,
        "Code Content must not be null.\n===| if you are loading a String from assets, make sure you declare it in pubspec.yaml |===");
    assert(widget.syntaxTheme != null,
        "syntaxTheme must not be null. select a theme by calling SyntaxTheme.(prefered theme)");
    assert(widget.syntax != null,
        "Syntax must not be null. select a Syntax by calling Syntax.(Language)");

    return Container(
        padding: EdgeInsets.all(10),
        color: widget.syntaxTheme.backgroundColor,
        // constraints: BoxConstraints.expand(),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RichText(
                textScaleFactor: textScaleFactor,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12.0),
                  children: <TextSpan>[
                    widget.getSyntax(widget.syntax).format(widget.code)
                  ],
                ),
              ),
            ),
          ),
        )

        /// To ignore null if zoom is not enabled.
        );
  }
}
