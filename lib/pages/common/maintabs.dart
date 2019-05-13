import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readitnews/models/maintab.dart';

class MainTabs extends StatefulWidget {
  @override
  MainTabsState createState() => new MainTabsState();
}

class MainTabsState extends State<MainTabs>
    with SingleTickerProviderStateMixin {
  /// 单击提示退出
  // Future<bool> _dialogExitApp(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) => new AlertDialog(
  //             content: new Text("确认退出?"),
  //             actions: <Widget>[
  //               new FlatButton(
  //                 onPressed: () => Navigator.of(context).pop(false),
  //                 child: new Text(
  //                   "取消",
  //                 ),
  //               ),
  //               new FlatButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(true);
  //                 },
  //                 child: new Text(
  //                   "确认",
  //                 ),
  //               )
  //             ],
  //           ));
  // }

  final List<VMMainTabModel> mainTabs = <VMMainTabModel>[
    new VMMainTabModel('博客园', new Text('博客园')), //拼音就是参数值
    new VMMainTabModel('掘金', new Text('掘金')),
    new VMMainTabModel('简书', new Text('简书')),
    new VMMainTabModel('简书', new Text('简书')),
    new VMMainTabModel('简书', new Text('简书')),
    new VMMainTabModel('Github', new Text('博客园'))
  ];

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: mainTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildIconBotton(Widget icon, VoidCallback onPressed) {
    return new IconButton(
      // alignment: Alignment.centerLeft,
      // color: Colors.red,
      // padding: EdgeInsets.all(1.0),
      iconSize: 18.0,
      // Use the FontAwesomeIcons class for the IconData
      icon: icon,
      onPressed: () {
        print("Pressed");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: buildIconBotton(new Icon(FontAwesomeIcons.user), () {
          print("Pressed");
        }),
        actions: <Widget>[
          buildIconBotton(new Icon(FontAwesomeIcons.search), () {
            print("Pressed");
          })
        ],
        title: new Center(
          child: new TabBar(
            controller: _tabController,
            tabs: mainTabs.map((VMMainTabModel item) {
              //NewsTab可以不用声明
              return new Tab(text: item.text ?? '错误');
            }).toList(),
            indicatorColor: Colors.white,
            isScrollable:
                true, //水平滚动的开关，开启后Tab标签可自适应宽度并可横向拉动，关闭后每个Tab自动压缩为总长符合屏幕宽度的等宽，默认关闭
          ),
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: mainTabs.map((item) {
          return new TabItemBase(child: item.tabWidget);
        }).toList(),
      ),
    );
  }
}

class TabItemBase extends StatefulWidget {
  final Widget child;

  TabItemBase({Key key, this.child}) : super(key: key);

  @override
  State<TabItemBase> createState() {
    return new _TabItemBase();
  }
}

class _TabItemBase extends State<TabItemBase>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
