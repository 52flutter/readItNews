import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readitnews/bloc/bloc_provider.dart';
import 'package:readitnews/bloc/main_bloc.dart';
import 'package:readitnews/components/HtmlView/src/core_html_widget.dart';
import 'package:readitnews/models/cnblogs/cnblogs_home_data.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:readitnews/routers/router.dart';
import 'package:readitnews/utils/CommonUtils.dart';
import 'package:readitnews/utils/LogUtil.dart';
import 'package:readitnews/utils/ObjectUtil.dart';
import 'package:readitnews/utils/styles.dart';
import 'package:rxdart/rxdart.dart';

/** 复制到剪粘板 */
copyToClipboard(final String text) {
  if (text == null) return;
  Clipboard.setData(new ClipboardData(text: text));
}

class CnBlogDetailsPage extends StatelessWidget {
  bool isInit = true;
  final CnBlogsHomeModel itemData;
  CnBlogDetailsPage({Key key, this.itemData}) : super(key: key);

  void _onPopSelected(String value) {
    switch (value) {
      case "browser":
        Router.launchInBrowser(itemData.href);
        break;
      case "copy":
        copyToClipboard(itemData.href);
        CommonUtils.showToast("复制成功");
        break;
      case "share":
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("CnHomeDetailsPage build......");
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);
    if (isInit) {
      isInit = false;
      bloc.clearDetails();
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        bloc.getCnBlogDetails(itemData.title, itemData.href);
      });
    }
    return new StreamBuilder(
      stream: bloc.cnblogDetailsStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Center(
              child: new Text(
                itemData.title,
                style: TextStyle(fontSize: 16),
              ),
            ),
            actions: <Widget>[
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
                          ),
                        ),
                      ),
                      new PopupMenuItem<String>(
                        value: "copy",
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
                                  '复制链接',
                                  style: TextStyles.listContent,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
              ),
            ],
          ),
          body: new Stack(
            children: <Widget>[
              new Scrollbar(
                child: new RefreshIndicator(
                  key: new Key(itemData.href),
                  onRefresh: () {},
                  child: new SingleChildScrollView(
                    child: new HtmlWidget(snapshot.data ?? ''),
                  ),
                ),
              ),
              new Offstage(
                offstage: !ObjectUtil.isEmptyString(snapshot.data),
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
        );
      },
    );
  }
}
