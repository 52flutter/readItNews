import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readitnews/pages/CnBlogs/Details.dart';
import 'package:readitnews/utils/CommonUtils.dart';
import 'package:url_launcher/url_launcher.dart';

class Routes {
  /// 博客园
  static const cnBlogDetails = "/cnblogsdetails";

  static final _routes = <String, WidgetBuilderX>{
    cnBlogDetails: (context, param) {
      return new CnBlogDetailsPage(
        itemData: param["itemData"],
      );
    },
  };
}

typedef Widget WidgetBuilderX(BuildContext context, Map<String, dynamic> param);

class Router {
  static Future<Null> launchInBrowser(String url, {String title}) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      CommonUtils.showToast('Could not launch $url');
      // throw 'Could not launch $url';
    }
  }

  /// 界面跳转
  static Future navigateTo(BuildContext context, String path,
      {dynamic param,
      Duration transitionDuration = const Duration(milliseconds: 200),
      TransitionType transitionType = TransitionType.inFromRight}) {
    // 创建 route 实例
    // Route<dynamic> route = new PageRouteBuilder<dynamic>(
    //   settings: new RouteSettings(name: path),
    //   pageBuilder: (context, animation, secondaryAnimation) {
    //     assert(Routes._routes.containsKey(path));
    //     return Routes._routes[path](context, param);
    //   },
    //   transitionDuration: transitionDuration,
    //   transitionsBuilder: _transitionsBuilder(transitionType),
    // );
    return Navigator.push(
        context,
        new CupertinoPageRoute<void>(
            builder: (ctx) => Routes._routes[path](context, param)));
    // return Navigator.push(context, route);
  }

  /// 转场动画自定义实现
  static RouteTransitionsBuilder _transitionsBuilder(
      TransitionType transitionType) {
    return (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      switch (transitionType) {
        case TransitionType.fadeIn: // 淡入
          return new FadeTransition(
            opacity: animation,
            child: child,
          );
        case TransitionType.inFromRight: // 从右往左进
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(new CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            )),
            child: child,
          );
        default: // 从下往上进入
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(new CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            )),
            child: new FadeTransition(
              opacity: new CurvedAnimation(
                parent: animation,
                curve: Curves.easeIn, // Eyeballed from other Material apps.
              ),
              child: child,
            ),
          );
      }
    };
  }
}

enum TransitionType {
  fadeIn,
  inFromRight,
  inFromBottom,
}
