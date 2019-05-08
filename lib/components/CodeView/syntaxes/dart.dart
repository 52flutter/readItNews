import 'package:flutter/material.dart';
import 'package:string_scanner/string_scanner.dart';

import '../syntax_theme.dart';

class DartSyntaxHighlighter {
  DartSyntaxHighlighter([this.syntaxTheme]) {
    _spans = <_HighlightSpan>[];
    syntaxTheme ??= SyntaxTheme.dracula();
  }

  SyntaxTheme syntaxTheme;

  static const List<String> _keywords = const <String>[
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'default',
    'deferred',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'external',
    'extends',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'get',
    'if',
    'implements',
    'import',
    'in',
    'is',
    'library',
    'new',
    'null',
    'operator',
    'part',
    'rethrow',
    'return',
    'set',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'while',
    'with',
    'yield',
    'show'
  ];

  static const List<String> _builtInTypes = const <String>[
    'int',
    'double',
    'num',
    'bool'
  ];

  String _src;
  StringScanner _scanner;

  List<_HighlightSpan> _spans;

  TextSpan format(String src) {
    _src = src;
    _scanner = StringScanner(_src);

    if (_generateSpans()) {
      /// Successfully parsed the code
      final List<TextSpan> formattedText = <TextSpan>[];
      int currentPosition = 0;

      for (_HighlightSpan span in _spans) {
        if (currentPosition != span.start)
          formattedText
              .add(TextSpan(text: _src.substring(currentPosition, span.start)));

        formattedText.add(TextSpan(
            style: span.textStyle(syntaxTheme), text: span.textForSpan(_src)));

        currentPosition = span.end;
      }

      if (currentPosition != _src.length)
        formattedText
            .add(TextSpan(text: _src.substring(currentPosition, _src.length)));

      return TextSpan(style: syntaxTheme.baseStyle, children: formattedText);
    } else {
      /// Parsing failed, return with only basic formatting
      return TextSpan(style: syntaxTheme.baseStyle, text: src);
    }
  }

  bool _generateSpans() {
    int lastLoopPosition = _scanner.position;

    while (!_scanner.isDone) {
      /// Skip White space
      _scanner.scan(RegExp(r'\s+'));

      /// Block comments
      if (_scanner.scan(RegExp('/\\*+[^*]*\\*+(?:[^/*][^*]*\\*+)*/'))) {
        _spans.add(_HighlightSpan(_HighlightType.comment,
            _scanner.lastMatch.start, _scanner.lastMatch.end));
        continue;
      }

      /// Line comments
      if (_scanner.scan('//')) {
        final int startComment = _scanner.lastMatch.start;
        bool eof = false;
        int endComment;
        if (_scanner.scan(RegExp(r'.*'))) {
          endComment = _scanner.lastMatch.end;
        } else {
          eof = true;
          endComment = _src.length;
        }
        _spans.add(
            _HighlightSpan(_HighlightType.comment, startComment, endComment));

        if (eof) break;

        continue;
      }

      /// Raw r"String"
      if (_scanner.scan(RegExp(r'r".*"'))) {
        _spans.add(_HighlightSpan(_HighlightType.string,
            _scanner.lastMatch.start, _scanner.lastMatch.end));
        continue;
      }

      /// Raw r'String'
      if (_scanner.scan(RegExp(r"r'.*'"))) {
        _spans.add(_HighlightSpan(_HighlightType.string,
            _scanner.lastMatch.start, _scanner.lastMatch.end));
        continue;
      }

      /// Multiline """String"""
      if (_scanner.scan(RegExp(r'"""(?:[^"\\]|\\(.|\n))*"""'))) {
        _spans.add(_HighlightSpan(_HighlightType.string,
            _scanner.lastMatch.start, _scanner.lastMatch.end));
        continue;
      }

      /// Multiline '''String'''
      if (_scanner.scan(RegExp(r"'''(?:[^'\\]|\\(.|\n))*'''"))) {
        _spans.add(_HighlightSpan(_HighlightType.string,
            _scanner.lastMatch.start, _scanner.lastMatch.end));
        continue;
      }

      /// "String"
      if (_scanner.scan(RegExp(r'"(?:[^"\\]|\\.)*"'))) {
        _spans.add(_HighlightSpan(_HighlightType.string,
            _scanner.lastMatch.start, _scanner.lastMatch.end));
        continue;
      }

      /// 'String'
      if (_scanner.scan(RegExp(r"'(?:[^'\\]|\\.)*'"))) {
        _spans.add(_HighlightSpan(_HighlightType.string,
            _scanner.lastMatch.start, _scanner.lastMatch.end));
        continue;
      }

      /// Double
      if (_scanner.scan(RegExp(r'\d+\.\d+'))) {
        _spans.add(_HighlightSpan(_HighlightType.number,
            _scanner.lastMatch.start, _scanner.lastMatch.end));
        continue;
      }

      /// Integer
      if (_scanner.scan(RegExp(r'\d+'))) {
        _spans.add(_HighlightSpan(_HighlightType.number,
            _scanner.lastMatch.start, _scanner.lastMatch.end));
        continue;
      }

      /// Punctuation
      if (_scanner.scan(RegExp(r'[\[\]{}().!=<>&\|\?\+\-\*/%\^~;:,]'))) {
        _spans.add(_HighlightSpan(_HighlightType.punctuation,
            _scanner.lastMatch.start, _scanner.lastMatch.end));
        continue;
      }

      /// Meta data
      if (_scanner.scan(RegExp(r'@\w+'))) {
        _spans.add(_HighlightSpan(_HighlightType.keyword,
            _scanner.lastMatch.start, _scanner.lastMatch.end));
        continue;
      }

      /// Words
      if (_scanner.scan(RegExp(r'\w+'))) {
        _HighlightType type;

        String word = _scanner.lastMatch[0];
        if (word.startsWith('_')) word = word.substring(1);

        if (_keywords.contains(word))
          type = _HighlightType.keyword;
        else if (_builtInTypes.contains(word))
          type = _HighlightType.keyword;
        else if (_firstLetterIsUpperCase(word))
          type = _HighlightType.klass;
        else if (word.length >= 2 &&
            word.startsWith('k') &&
            _firstLetterIsUpperCase(word.substring(1)))
          type = _HighlightType.constant;

        if (type != null) {
          _spans.add(_HighlightSpan(
              type, _scanner.lastMatch.start, _scanner.lastMatch.end));
        }
      }

      /// Check if this loop did anything
      if (lastLoopPosition == _scanner.position) {
        /// Failed to parse this file, abort gracefully
        return false;
      }
      lastLoopPosition = _scanner.position;
    }

    _simplify();
    return true;
  }

  void _simplify() {
    for (int i = _spans.length - 2; i >= 0; i -= 1) {
      if (_spans[i].type == _spans[i + 1].type &&
          _spans[i].end == _spans[i + 1].start) {
        _spans[i] =
            _HighlightSpan(_spans[i].type, _spans[i].start, _spans[i + 1].end);
        _spans.removeAt(i + 1);
      }
    }
  }

  bool _firstLetterIsUpperCase(String str) {
    if (str.isNotEmpty) {
      final String first = str.substring(0, 1);
      return first == first.toUpperCase();
    }
    return false;
  }
}

class _HighlightSpan {
  _HighlightSpan(this.type, this.start, this.end);
  final _HighlightType type;
  final int start;
  final int end;

  String textForSpan(String src) {
    return src.substring(start, end);
  }

  TextStyle textStyle(SyntaxTheme syntaxTheme) {
    if (type == _HighlightType.number)
      return syntaxTheme.numberStyle;
    else if (type == _HighlightType.comment)
      return syntaxTheme.commentStyle;
    else if (type == _HighlightType.keyword)
      return syntaxTheme.keywordStyle;
    else if (type == _HighlightType.string)
      return syntaxTheme.stringStyle;
    else if (type == _HighlightType.punctuation)
      return syntaxTheme.punctuationStyle;
    else if (type == _HighlightType.klass)
      return syntaxTheme.classStyle;
    else if (type == _HighlightType.constant)
      return syntaxTheme.constantStyle;
    else
      return syntaxTheme.baseStyle;
  }
}

enum _HighlightType {
  number,
  comment,
  keyword,
  string,
  punctuation,
  klass,
  constant
}
