import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:readitnews/components/CodeView/SyntaxWidget.dart';
import 'package:readitnews/routers/router.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

final codeTags = ["pre", "code", "tt"];

const csharpKeys = ["namespace", "using", "Main(string[] args)"];
const jsKeys = [
  // "script",
  "console.log",
  "require",
  "prototype",
  "template",
  "React",
  "render",
  ".js",
  ".css",
  ".less",
  ".vue",
  ".ts",
  ".tsx",
  "document",
  "Vue",
  "function",
  "addEventListener",
  "onload",
  "vue",
  "react",
  "redux",
  "angular",
  "prototype",
  "javascript",
  // "script"
];

const kotlinKeys = [
  "kotlin",
  "vararg",
  "arrayOf",
  "when",
  "withIndex",
  "listOf",
  "private constructor",
  "open class",
  "mutableListOf",
  "enum class"
];
const dartKeys = [
  "StatefulWidget",
  "StatelessWidget",
  ".dart",
  "flutter",
  "runApp",
  "assert",
  // "??",
  // "..",
  "mixin",
  "bloc"
];

const swiftKeys = [
  "subscript",
  "fallthrough",
  "_FUNCTION_",
  "_COLUMN_",
  "_LINE_",
  "dynamicType",
  "nil",
  "nonmutating",
  "convenience",
  "didSet",
  "nonmutating",
  "UInt",
  "typealias",
  "Cocoa",
  "Character",
  "[Int]",
  "extension"
];

class HtmlView extends StatefulWidget {
  const HtmlView({
    Key key,
    this.htmlStr,
  }) : super(key: key);

  final String htmlStr;

  @override
  State<StatefulWidget> createState() {
    return new HtmlViewState();
  }
}

class HtmlViewState extends State<HtmlView> {
  BuildOp get buildTagCodeOp => BuildOp(
        defaultStyles: (_, __) => [kCssFontFamily, 'monospace'],
        onPieces: (meta, pieces) => meta.domElement.localName == kTagPre
            ? [_buildPreTag(meta)]
            : pieces,
      );

  bool isExistStr(String source, List<String> keys) {
    bool falg = false;
    if (source == null || source.isEmpty) {
      return false;
    }
    if (keys == null || keys.length == 0) {
      return false;
    }
    for (var key in keys) {
      if (source.contains(key)) {
        return true;
      }
    }
    return falg;
  }

  Syntax getSyntax(NodeMetadata meta) {
    var codeType = Syntax.JAVA;
    if (meta.domElement != null &&
        meta.domElement.className != null &&
        meta.domElement.className.isNotEmpty) {
      //尝试 从高亮className 获取
      var className = meta.domElement.className;
      print(className);
      if (className.contains('js') || className.contains('javascript')) {
        codeType = Syntax.JAVASCRIPT;
      } else if (className.contains('csharp')) {
        codeType = Syntax.JAVA;
      } else if (className.contains('dart')) {
        codeType = Syntax.DART;
      } else if (className.contains('kotlin')) {
        codeType = Syntax.KOTLIN;
      } else if (className.contains('swift')) {
        codeType = Syntax.SWIFT;
      }
    }
    if (isExistStr(meta.domElement.text, jsKeys)) {
      codeType = Syntax.JAVASCRIPT;
    } else if (isExistStr(meta.domElement.text, csharpKeys)) {
      codeType = Syntax.JAVA;
    } else if (isExistStr(meta.domElement.text, dartKeys)) {
      codeType = Syntax.DART;
    } else if (isExistStr(meta.domElement.text, kotlinKeys)) {
      codeType = Syntax.KOTLIN;
    } else if (isExistStr(meta.domElement.text, swiftKeys)) {
      codeType = Syntax.SWIFT;
    }
    //  else {
    //   //获取不到的话  就尝试获取正文内容
    //   var html = widget.htmlStr ?? "";
    //   if (isExistStr(html, jsKeys)) {
    //     codeType = Syntax.JAVASCRIPT;
    //   } else if (isExistStr(html, swiftKeys)) {
    //     codeType = Syntax.SWIFT;
    //   } else if (isExistStr(html, kotlinKeys)) {
    //     codeType = Syntax.KOTLIN;
    //   } else if (isExistStr(html, dartKeys)) {
    //     codeType = Syntax.DART;
    //   }
    // }
    return codeType;
  }

  BuiltPiece _buildPreTag(NodeMetadata meta) {
    var syntax = getSyntax(meta);
    // print(syntax.toString());
    return BuiltPieceSimple(widgets: [
      new Container(
        child:
            //  new HtmlWidget(meta.domElement.innerHtml),
            new SyntaxWidget(
          code: meta.domElement.text.replaceAll("复制代码", ''),
          syntax: syntax,
          syntaxTheme: SyntaxTheme.obsidian(),

          // withZoom: true,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // String html = "";
    // if (widget.htmlStr != null) {
    //   html = widget.htmlStr;
    // }
    return new HtmlWidget((widget.htmlStr ?? ""),
        builderCallback: (meta, e) => codeTags.contains(e.localName)
            ? lazySet(null, buildOp: buildTagCodeOp)
            : meta,
        onTapUrl: (url, {String title}) {
          //   print(url + title);
          Router.pushWeb(context, title: title, url: url);
        });
  }
}
