part of '../core_helpers.dart';

class TagA {
  final WidgetFactory wf;

  TagA(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (_, __) => [
              kCssColor,
              colorToHex(wf.config.hyperlinkColor),
              kCssTextDecoration,
              kCssTextDecorationUnderline,
            ],
        onPieces: (meta, pieces) {
          final onTap = _buildGestureTapCallback(meta);
          if (onTap == null) return pieces;

          return pieces.map(
            (piece) => piece.hasWidgets
                ? BuiltPieceSimple(
                    widgets: wf.buildGestureDetectors(piece.widgets, onTap),
                  )
                : _buildBlock(piece, onTap),
          );
        },
      );

  BuiltPiece _buildBlock(BuiltPiece piece, GestureTapCallback onTap) =>
      piece..block.rebuildBits((bit) => bit.rebuild(onTap: onTap));

  GestureTapCallback _buildGestureTapCallback(NodeMetadata meta) {
    final attrs = meta.domElement.attributes;
    final href = attrs.containsKey('href') ? attrs['href'] : '';
    final url = wf.constructFullUrl(href) ?? href;
    return wf.buildGestureTapCallbackForUrl(url);
  }
}
