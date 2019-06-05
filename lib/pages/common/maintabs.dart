import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readitnews/models/maintab.dart';

class TopTabs extends StatefulWidget {
  final List<VM_Tab> tabs;
  const TopTabs({Key key, @required this.tabs});

  @override
  TopTabsState createState() => new TopTabsState();
}

class TopTabsState extends State<TopTabs> with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: widget.tabs.length);
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
    var mainTabs = widget.tabs;
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
        centerTitle: true,
        title: new Center(
          child: new TabBar(
            controller: _tabController,
            tabs: mainTabs.map((VM_Tab item) {
              //NewsTab可以不用声明
              return new Tab(text: item.text ?? '错误');
            }).toList(),
            isScrollable: true,
            labelPadding: EdgeInsets.all(12.0),
            indicatorSize: TabBarIndicatorSize.label,
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
