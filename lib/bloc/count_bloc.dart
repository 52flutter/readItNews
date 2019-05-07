import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class IncrementBloc implements BlocBase {
  int _counter;
  var _counterController = BehaviorSubject<int>();
  // 处理counter的stream

  // broadcast广播流允许任意数量的收听者
  // StreamController<int> _counterController = StreamController.broadcast();

  StreamSink<int> get _inAdd => _counterController.sink;
  Stream<int> get outCounter => _counterController.stream;

  // 处理业务逻辑的stream
  StreamController _actionController = StreamController();
  StreamSink get incrementCounter => _actionController.sink;

  // 构造器
  IncrementBloc() {
    _counter = 0;
    _actionController.stream.listen(_handleLogic);
  }

  void dispose() {
    _actionController.close();
    _counterController.close();
  }

  void _handleLogic(data) {
    _counter = _counter + 1;
    _inAdd.add(_counter);
  }

  @override
  Future getData({String labelId, int page}) {
    // TODO: implement getData
    return null;
  }

  @override
  Future onLoadMore({String labelId}) {
    // TODO: implement onLoadMore
    return null;
  }

  @override
  Future onRefresh({String labelId}) {
    // TODO: implement onRefresh
    return null;
  }
}
