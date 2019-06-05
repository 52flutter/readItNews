import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:readitnews/routers/router.dart';
import 'package:readitnews/utils/colorPaletteMixin.dart';
import 'package:readitnews/utils/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';

class WebScaffold extends StatefulWidget {
  const WebScaffold({
    Key key,
    this.title,
    this.titleId,
    this.url,
  }) : super(key: key);

  final String title;
  final String titleId;
  final String url;

  @override
  State<StatefulWidget> createState() {
    return new WebScaffoldState();
  }
}

class WebScaffoldState extends State<WebScaffold>
    with AutomaticKeepAliveClientMixin {
  WebViewController _webViewController;

  // Widget _buildFloatingActionButton() {
  //   // if (_webViewController == null) {
  //   //   return null;
  //   // }
  //   return new FloatingActionButton(
  //       heroTag: widget.title ?? widget.titleId,
  //       backgroundColor: Theme.of(context).primaryColor,
  //       child: Icon(
  //         Icons.replay,
  //       ),
  //       onPressed: () {
  //         if (_webViewController != null) {
  //           print('123');
  //           _webViewController.reload();
  //         }
  //         print('12223');
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    var _fabMiniMenuItemList = [
      new FabMiniMenuItem.withText(
          new Icon(Icons.arrow_forward), Colors.blue, 4.0, "前进", () {
        if (_webViewController != null) {
          _webViewController.goForward();
        }
      }, "前进", Colors.blue, Colors.white, true),
      new FabMiniMenuItem.withText(
          new Icon(Icons.arrow_back), Colors.blue, 4.0, "后退", () {
        if (_webViewController != null) {
          _webViewController.goBack();
        }
      }, "后退", Colors.blue, Colors.white, true),
      new FabMiniMenuItem.withText(
          new Icon(Icons.replay), Colors.blue, 4.0, "刷新", () {
        if (_webViewController != null) {
          _webViewController.reload();
        }
      }, "刷新", Colors.blue, Colors.white, true)
    ];
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: new WebView(
              debuggingEnabled: false,
              //只响应垂直手势
              gestureRecognizers: Set()
                ..add(
                  Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer(),
                  ),
                ),
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
              },
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
          new Container(
            decoration: new BoxDecoration(
              border: new Border(
                top: new BorderSide(color: Colours.gray_cc, width: 0.5),
              ),
            ),
            height: 50,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new IconButton(
                  icon: new Icon(
                    Icons.arrow_back,
                  ),
                  color: globalColorPalette.colorPalette(6),
                  onPressed: () {
                    if (_webViewController != null) {
                      _webViewController.goBack();
                    }
                  },
                  tooltip: "后退",
                ),
                new IconButton(
                  icon: new Icon(
                    Icons.arrow_forward,
                  ),
                  color: globalColorPalette.colorPalette(6),
                  onPressed: () {
                    if (_webViewController != null) {
                      _webViewController.goForward();
                    }
                  },
                  tooltip: "前进",
                ),
                new IconButton(
                  icon: new Icon(
                    Icons.replay,
                  ),
                  color: globalColorPalette.colorPalette(6),
                  onPressed: () {
                    if (_webViewController != null) {
                      _webViewController.reload();
                    }
                  },
                  tooltip: "刷新",
                ),
                new IconButton(
                  icon: new Icon(
                    Icons.open_in_browser,
                  ),
                  color: globalColorPalette.colorPalette(6),
                  onPressed: () {
                    Router.launchInBrowser(widget.url);
                  },
                  tooltip: "浏览器打开",
                ),
              ],
            ),
          )
        ],
      ),
    );

    // return new Scaffold(
    //   body: new Stack(children: [
    //     new WebView(
    //       debuggingEnabled: false,
    //       //只响应垂直手势
    //       // gestureRecognizers: Set()
    //       //   ..add(
    //       //     Factory<VerticalDragGestureRecognizer>(
    //       //       () => VerticalDragGestureRecognizer(),
    //       //     ),
    //       //   ),
    //       onWebViewCreated: (WebViewController webViewController) {
    //         _webViewController = webViewController;
    //       },
    //       initialUrl: widget.url,
    //       javascriptMode: JavascriptMode.unrestricted,
    //     ),
    //     new FabDialer(_fabMiniMenuItemList, Colors.blue, new Icon(Icons.add)),
    //   ]),
    // );
  }

  @override
  bool get wantKeepAlive => true;
}
