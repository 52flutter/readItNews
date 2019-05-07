import 'dart:async';

import 'package:readitnews/models/cnblogs/cnblogs_home_data.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class CnBlogBloc implements BlocBase {
  var _homeController = BehaviorSubject<List<CnBlogsHomeModel>>();
  // broadcast广播流允许任意数量的收听者
  // StreamController<int> _counterController = StreamController.broadcast();

  StreamSink<List<CnBlogsHomeModel>> get _homeSink => _homeController.sink;
  Stream<List<CnBlogsHomeModel>> get _homeStream => _homeController.stream;

  List<CnBlogsHomeModel> _list;
  int _pageIndex = 0;

  // 构造器
  CnBlogBloc() {
    _pageIndex = 0;
  }

  void dispose() {
    _homeController.close();
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
