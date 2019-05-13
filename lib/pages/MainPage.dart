import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readitnews/bloc/bloc_juejin.dart';
import 'package:readitnews/bloc/bloc_provider.dart';
import 'package:readitnews/bloc/count_bloc.dart';
import 'package:readitnews/components/webview.dart';
import 'package:readitnews/models/maintab.dart';
import 'package:readitnews/pages/Juejin/Home.dart';
import 'package:readitnews/utils/String.dart';

import 'CnBlogs/Home.dart';

final List<VMMainTabModel> mainTabs = <VMMainTabModel>[
  new VMMainTabModel(
    '博客园',
    new CnBlogHomePage(
      labelId: Ids.cnBlog_home,
    ),
  ), //拼音就是参数值
  new VMMainTabModel(
    '掘金',
    new BlocProvider<JuejinBloc>(
        bloc: globalJuejinBloc, child: new JuejinHomePage()),
  ),
  new VMMainTabModel(
      '简书',
      new WebScaffold(
        title: '简书',
        url: 'https://www.jianshu.com/',
      )),
  new VMMainTabModel(
      'Github',
      new WebScaffold(
        title: '简书',
        url: 'https://github.com',
      ))
];

class MainPage extends StatelessWidget {
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
    return new DefaultTabController(
        length: mainTabs.length,
        child: new Scaffold(
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
            title: new TabLayout(),
          ),
          body: new TabBarViewLayout(),
          // drawer: new Drawer(
          //   child: new MainLeftPage(),
          // ),
        ));
  }
}

class TabLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TabBar(
      isScrollable: true,
      labelPadding: EdgeInsets.all(12.0),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: mainTabs
          .map((VMMainTabModel page) => new Tab(text: page.text))
          .toList(),
    );
  }
}

class TabBarViewLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new BlocProvider<IncrementBloc>(
        bloc: new IncrementBloc(),
        child: new TabBarView(
            children: mainTabs.map((VMMainTabModel page) {
          return page.tabWidget;
        }).toList()));
  }
}
