import 'dart:collection';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readitnews/models/StatusEvent.dart';
import 'package:readitnews/models/cnblogs/cnblogs_home_data.dart';
import 'package:readitnews/services/CnBlogServices.dart';
import 'package:readitnews/utils/LogUtil.dart';
import 'package:readitnews/utils/ObjectUtil.dart';
import 'package:readitnews/utils/String.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';

class MainBloc implements BlocBase {
  BehaviorSubject<StatusEvent> _commonListStatusEvent =
      BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get _commonListStatusSink => _commonListStatusEvent.sink;

  Stream<StatusEvent> get commonListStatusStream =>
      _commonListStatusEvent.stream.asBroadcastStream();

  ///****** ****** ****** CnBlog ****** ****** ****** /

  BehaviorSubject<String> _cnblogDetails = BehaviorSubject<String>();

  Sink<String> get _cnblogDetailsSink => _cnblogDetails.sink;

  Stream<String> get cnblogDetailsStream => _cnblogDetails.stream;

  BehaviorSubject<List<CnBlogsSitehomeItem>> _cnblog =
      BehaviorSubject<List<CnBlogsSitehomeItem>>();

  Sink<List<CnBlogsSitehomeItem>> get _cnblogSink => _cnblog.sink;

  Stream<List<CnBlogsSitehomeItem>> get cnblogStream => _cnblog.stream;

  List<CnBlogsSitehomeItem> _cnblogList;
  int _cnblogPage = 0;
  void clearDetails() {
    _cnblogDetailsSink.add(null);
  }

  Future getCnBlogDetails(String title, String href) {
    LogUtil.e("getCnBlogDetails");
    return CnBlogServices.getDetails(title, href).then((html) {
      if (ObjectUtil.isEmptyString(html)) {
        _cnblogDetailsSink.add('请求错误');
      } else {
        _cnblogDetailsSink.add(html);
      }
    }).catchError((_) {
      _cnblogDetailsSink.add('请求错误');
    });
  }

  Future getCnBlogHomeData(String labelId, int page) {
    return CnBlogServices.getSiteHomeData(page).then((list) {
      if (_cnblogList == null) {
        _cnblogList = new List();
      }
      if (page == 0) {
        _cnblogList.clear();
      }
      _cnblogList.addAll(list);
      _cnblogSink.add(UnmodifiableListView<CnBlogsSitehomeItem>(_cnblogList));
      _commonListStatusSink.add(new StatusEvent(
          labelId,
          RefreshStatus.completed,
          ObjectUtil.isEmpty(list) ? LoadStatus.noMore : LoadStatus.idle));
    }).catchError((_) {
      _cnblogPage--;
      _commonListStatusSink
          .add(new StatusEvent(labelId, RefreshStatus.failed, LoadStatus.idle));
    });
  }

  ///****** ****** ****** CnBlog ****** ****** ****** /

  @override
  void dispose() {
    _cnblog.close();
    _commonListStatusEvent.close();
    // TODO: implement dispose
  }

  @override
  Future getData({String labelId, int page}) {
    switch (labelId) {
      case Ids.cnBlog_home:
        return getCnBlogHomeData(labelId, page);
        break;
      default:
        return Future.delayed(new Duration(seconds: 1));
        break;
    }
  }

  @override
  Future onLoadMore({String labelId}) {
    int _page = 0;
    switch (labelId) {
      case Ids.cnBlog_home:
        _page = ++_cnblogPage;
        break;
      default:
        break;
    }
    LogUtil.e("onLoadMore labelId: $labelId" + "   _page: $_page");
    return getData(labelId: labelId, page: _page);
  }

  @override
  Future onRefresh({String labelId}) {
    switch (labelId) {
      case Ids.cnBlog_home:
        _cnblogPage = 0;
        break;
      default:
        break;
    }
    LogUtil.e("onRefresh labelId: $labelId");
    return getData(labelId: labelId, page: 0);
  }
}