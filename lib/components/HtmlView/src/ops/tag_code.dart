part of '../core_helpers.dart';

const kTagCode = 'code';
const kTagPre = 'pre';
const kTagTt = 'tt';

class TagCode {
  final WidgetFactory wf;

  TagCode(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (_, __) => [kCssFontFamily, 'monospace'],
        onPieces: (meta, pieces) => meta.domElement.localName == kTagPre
            ? [_buildPreTag(meta)]
            : pieces,
        // onWidgets: (_, widgets) => [wf.buildScrollView(wf.buildBody(widgets))],
      );
  // Container(
  //       padding: EdgeInsets.all(10.0),
  //       decoration:
  //           new BoxDecoration(color: Color.fromRGBO(40, 44, 52, 1.00)),
  //       child: new RichText(
  //         text: new DartSyntaxHighlighter().format(node.text),
  //       ),
  //     )
  BuiltPiece _buildPreTag(NodeMetadata meta) {
    return BuiltPieceSimple(widgets: [
      new Container(
        child: new SyntaxWidget(
          code: meta.domElement.text,
          syntax: Syntax.JAVASCRIPT,
          syntaxTheme: SyntaxTheme.ayuDark(),
          // withZoom: true,
        ),
      ),

      // new SyntaxWidget(
      //     code: meta.domElement.text,
      //     syntax: Syntax.KOTLIN,
      //     syntaxTheme: SyntaxTheme.ayuDark()),
    ]);
  }
// new DartSyntaxHighlighter().format(node.text)
  // BuiltPiece _buildPreTag(NodeMetadata meta) => BuiltPieceSimple(
  //       block: TextBlock(meta.textStyle)..addText(meta.domElement.text),
  //     );
}
