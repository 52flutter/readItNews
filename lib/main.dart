import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:getuiflut/getuiflut.dart';
import 'package:readitnews/pages/MainPage.dart';
import 'package:readitnews/services/Code.dart';
import 'package:readitnews/utils/eventBus/HttpErrorEvent.dart';
import 'package:readitnews/utils/eventBus/index.dart';

import 'bloc/application_bloc.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/main_bloc.dart';

void main() => runApp(BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider(child: MyApp(), bloc: MainBloc()),
    ));

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  StreamSubscription stream;
  @override
  void initState() {
    super.initState();

    ///Stream演示event bus
    stream = eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream.cancel();
      stream = null;
    }
  }

  ///网络错误提醒
  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        Fluttertoast.showToast(msg: '网络错误,请打开网络连接');
        break;
      case 401:
        Fluttertoast.showToast(msg: '请重新登录');
        break;
      // case 403:
      //   Fluttertoast.showToast(
      //       msg: CommonUtils.getLocale(context).network_error_403);
      //   break;
      // case 404:
      //   Fluttertoast.showToast(
      //       msg: CommonUtils.getLocale(context).network_error_404);
      //   break;
      case Code.NETWORK_TIMEOUT:
        //   //超时
        Fluttertoast.showToast(msg: '请求超时');
        break;
      default:
        Fluttertoast.showToast(msg: '未知错误' + message);
        break;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
    );
  }
}
