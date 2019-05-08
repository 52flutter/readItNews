library flutter_syntax_view;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:readitnews/components/CodeView/syntax_theme.dart';
import 'package:readitnews/components/CodeView/syntaxes/dart.dart';
import 'package:readitnews/components/CodeView/syntaxes/java.dart';
import 'package:readitnews/components/CodeView/syntaxes/kotlin.dart';
import 'package:readitnews/components/CodeView/syntaxes/swift.dart';

///Supported Syntaxes Enum
enum Syntax {
  DART,
  JAVA,
  KOTLIN,
  SWIFT

  ///TODO SUPPORT MORE SYNTAXES
}

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
