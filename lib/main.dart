import 'package:flutter/material.dart';
import 'package:getuiflut/getuiflut.dart';
import 'package:readitnews/pages/MainPage.dart';

import 'bloc/application_bloc.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/main_bloc.dart';
import 'models/juejin/search_args.dart';

void main() => runApp(BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider(child: MyApp(), bloc: MainBloc()),
    ));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
// GETUI_APP_ID    : "sERNrRax4vAn646UlGN8r2",
//     	GETUI_APP_KEY   : "8KJc0jQOFdAdED3OQjQxy5",
//     	GETUI_APP_SECRET: "aIeMIm1C5EAbqBxX41CCg"
    Getuiflut().startSdk(
        appId: "sERNrRax4vAn646UlGN8r2",
        appKey: "8KJc0jQOFdAdED3OQjQxy5",
        appSecret: "aIeMIm1C5EAbqBxX41CCg");
//个推
    Getuiflut().addEventHandler(
      // 注册收到 cid 的回调
      onReceiveClientId: (String message) async {
        print("flutter onRegisterDeviceToken: $message");
      },
      //// 消息到达的回调
      onNotificationMessageArrived: (Map<String, dynamic> message) async {
        print("flutter onNotificationMessageArrived: $message");
      },
      // 消息点击的回调
      onNotificationMessageClicked: (Map<String, dynamic> message) async {
        print("flutter onNotificationMessageArrived: $message");
      },
      // 透传消息的内容都会走到这里
      onReceiveMessageData: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessageData: $message");
      },

      onRegisterDeviceToken: (String message) async {
        print("flutter onRegisterDeviceToken: $message");
      },
      onReceivePayload: (String message) async {
        print("flutter onReceivePayload: $message");
      },
      onReceiveNotificationResponse: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationResponse: $message");
      },
      onAppLinkPayload: (String message) async {
        print("flutter onAppLinkPayload: $message");
      },
      onRegisterVoipToken: (String message) async {
        print("flutter onRegisterVoipToken: $message");
      },
      onReceiveVoipPayLoad: (Map<String, dynamic> message) async {
        print("flutter onReceiveVoipPayLoad: $message");
      },
    );
    return MaterialApp(
      // title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
