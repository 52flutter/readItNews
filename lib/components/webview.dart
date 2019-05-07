import 'package:flutter/material.dart';
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
      // appBar: new AppBar(
      //   title: new Text(
      //     widget.title ?? '',
      //     maxLines: 1,
      //     overflow: TextOverflow.ellipsis,
      //   ),
      //   centerTitle: true,
      // ),
      // floatingActionButton: _buildFloatingActionButton(),
      body: new Stack(children: [
        new WebView(
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
            // _webViewController.addListener(() {
            //   int _scrollY = _webViewController.scrollY.toInt();
            //   if (_scrollY < 480 && _isShowFloatBtn) {
            //     _isShowFloatBtn = false;
            //     setState(() {});
            //   } else if (_scrollY > 480 && !_isShowFloatBtn) {
            //     _isShowFloatBtn = true;
            //     setState(() {});
            //   }
            // });
          },
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
        new FabDialer(_fabMiniMenuItemList, Colors.blue, new Icon(Icons.add)),
      ]),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
