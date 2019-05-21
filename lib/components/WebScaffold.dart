import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readitnews/routers/router.dart';
import 'package:readitnews/utils/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

class WebScaffoldState extends State<WebScaffold> {
//  WebViewController _webViewController;
//  bool _isShowFloatBtn = false;

  void _onPopSelected(String value) {
    switch (value) {
      case "browser":
        Router.launchInBrowser(widget.url);
        break;
      case "collection":
        break;

      case "share":
        break;
      default:
        break;
    }
  }

  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void closeLoading() {
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var verticalGestures = Factory<VerticalDragGestureRecognizer>(
        () => VerticalDragGestureRecognizer());
    var gestureSet = Set.from([verticalGestures]);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: <Widget>[
//          new IconButton(icon: new Icon(Icons.more_vert), onPressed: () {}),
          new PopupMenuButton(
              padding: const EdgeInsets.all(0.0),
              onSelected: _onPopSelected,
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    new PopupMenuItem<String>(
                        value: "browser",
                        child: ListTile(
                            contentPadding: EdgeInsets.all(0.0),
                            dense: false,
                            title: new Container(
                              alignment: Alignment.center,
                              child: new Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.language,
                                    color: Colours.gray_66,
                                    size: 22.0,
                                  ),
                                  Gaps.hGap10,
                                  Text(
                                    '浏览器打开',
                                    style: TextStyles.listContent,
                                  )
                                ],
                              ),
                            ))),
//                    new PopupMenuItem<String>(
//                        value: "collection",
//                        child: ListTile(
//                            contentPadding: EdgeInsets.all(0.0),
//                            dense: false,
//                            title: new Container(
//                              alignment: Alignment.center,
//                              child: new Row(
//                                children: <Widget>[
//                                  Icon(
//                                    Icons.collections,
//                                    color: Colours.gray_66,
//                                    size: 22.0,
//                                  ),
//                                  Gaps.hGap10,
//                                  Text(
//                                    '收藏',
//                                    style: TextStyles.listContent,
//                                  )
//                                ],
//                              ),
//                            ))),
                    new PopupMenuItem<String>(
                        value: "share",
                        child: ListTile(
                            contentPadding: EdgeInsets.all(0.0),
                            dense: false,
                            title: new Container(
                              alignment: Alignment.center,
                              child: new Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.share,
                                    color: Colours.gray_66,
                                    size: 22.0,
                                  ),
                                  Gaps.hGap10,
                                  Text(
                                    '分享',
                                    style: TextStyles.listContent,
                                  )
                                ],
                              ),
                            ))),
                  ])
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new WebView(
            // gestureRecognizers: gestureSet,
            //只响应垂直手势
            gestureRecognizers: Set()
              ..add(
                Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer(),
                ),
              ),
            onPageFinished: (String url) {
              closeLoading();
            },
            onWebViewCreated: (WebViewController webViewController) {},
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
          ),
          new Offstage(
            offstage: !loading,
            child: new Container(
              alignment: Alignment.center,
              color: Color(0xfff0f0f0),
              child: new Center(
                child: new SizedBox(
                  width: 200.0,
                  height: 200.0,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new SpinKitDoubleBounce(
                          color: Theme.of(context).primaryColor),
                      // new Container(width: 10.0),
                      // new Container(child: new Text("加载中")),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
//      floatingActionButton: _buildFloatingActionButton(),
    );
  }

//  Widget _buildFloatingActionButton() {
//    if (_webViewController == null || _webViewController.scrollY < 480) {
//      return null;
//    }
//    return new FloatingActionButton(
//        heroTag: widget.title ?? widget.titleId,
//        backgroundColor: Theme.of(context).primaryColor,
//        child: Icon(
//          Icons.keyboard_arrow_up,
//        ),
//        onPressed: () {
//          _webViewController.scrollTop();
//        });
//  }
}
