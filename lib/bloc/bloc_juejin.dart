import 'dart:collection';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readitnews/models/StatusEvent.dart';
import 'package:readitnews/models/juejin/juejin_details.dart';
import 'package:readitnews/models/juejin/listresult.dart';
import 'package:readitnews/services/JuejinServices.dart';
import 'package:readitnews/utils/LogUtil.dart';
import 'package:readitnews/utils/ObjectUtil.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';

class JuejinBloc implements BlocBase {
  BehaviorSubject<StatusEvent> _commonListStatusEvent =
      BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get _commonListStatusSink => _commonListStatusEvent.sink;

  Stream<StatusEvent> get commonListStatusStream =>
      _commonListStatusEvent.stream.asBroadcastStream();

  ///****** ****** ****** Juejin ****** ****** ****** /

  BehaviorSubject<JuejinDetails> _juejinDetails =
      BehaviorSubject<JuejinDetails>();

  Sink<JuejinDetails> get _juejinDetailsSink => _juejinDetails.sink;

  Stream<JuejinDetails> get juejinDetailsStream => _juejinDetails.stream;

  BehaviorSubject<ListData> _juejin = BehaviorSubject<ListData>();

  Sink<ListData> get _juejinSink => _juejin.sink;

  Stream<ListData> get juejinStream => _juejin.stream;

  List<Edges> edges;
  String endCursor;

  void clearDetails() {
    _juejinDetailsSink.add(null);
  }

  Future getJuejinDetails(String title, String href) {
    LogUtil.e("getJuejinDetails");
    return JuejinServices.getDetails(title, href).then((html) {
      if (ObjectUtil.isEmptyString(html)) {
        _juejinDetails.add(new JuejinDetails(href, '请求错误'));
      } else {
        _juejinDetails.add(new JuejinDetails(href, html));
      }
    }).catchError((_) {
      _juejinDetails.add(new JuejinDetails(href, '请求错误'));
    });
  }

  Future getJuejinHomeData(JuejinCategory category, {String order}) {
    var oldEndCursor = endCursor;
    return JuejinServices.getListData(endCursor, category, order: order)
        .then((data) {
      if (edges == null) {
        edges = new List();
      }
      if (endCursor == '') {
        edges.clear();
      }
      edges.addAll(data.data.articleFeed.items.edges);
      // _cnblogSink.add(UnmodifiableListView<CnBlogsSitehomeItem>(_cnblogList));
      _juejinSink.add(new ListData(UnmodifiableListView<Edges>(edges),
          data.data.articleFeed.items.pageInfo.endCursor));
      endCursor = data.data.articleFeed.items.pageInfo.endCursor;
      _commonListStatusSink.add(new StatusEvent(
          "",
          oldEndCursor == '' ? RefreshType.top : RefreshType.bottom,
          ObjectUtil.isEmpty(data.data.articleFeed.items.edges)
              ? RefreshResult.noMore
              : RefreshResult.completed));
    }).catchError((_) {
      endCursor = oldEndCursor;
      if (endCursor == '') {
        _juejinSink
            .add(new ListData(UnmodifiableListView<Edges>(new List()), ''));
      }
      _commonListStatusSink.add(new StatusEvent(
          "",
          oldEndCursor == '' ? RefreshType.top : RefreshType.bottom,
          RefreshResult.failed));
    });
  }

  ///****** ****** ****** CnBlog ****** ****** ****** /

  @override
  void dispose() {
    _juejin.close();
    _commonListStatusEvent.close();
    // TODO: implement dispose
  }

  @override
  Future getData({String labelId, int page}) {
    return null;
  }

  @override
  Future onLoadMore({String labelId, JuejinCategory category}) {
    return getJuejinHomeData(category);
  }

  @override
  Future onRefresh({String labelId, JuejinCategory category}) {
    endCursor = "";
    return getJuejinHomeData(category);
    // switch (labelId) {
    //   case Ids.cnBlog_home:
    //     _cnblogPage = 0;
    //     break;
    //   default:
    //     break;
    // }
    // LogUtil.e("onRefresh labelId: $labelId");
    // return getData(labelId: labelId, page: 0);
  }

  static final JuejinBloc _bloc = new JuejinBloc._internal();
  factory JuejinBloc() {
    return _bloc;
  }
  JuejinBloc._internal();
}

JuejinBloc globalJuejinBloc = JuejinBloc();
