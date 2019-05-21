import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readitnews/bloc/bloc_provider.dart';
import 'package:readitnews/bloc/main_bloc.dart';
import 'package:readitnews/components/RefreshScaffold.dart';
import 'package:readitnews/models/cnblogs/cnblogs_home_data.dart';
import 'package:readitnews/utils/LogUtil.dart';
import 'package:rxdart/rxdart.dart';

import 'HomeItem.dart';

bool isInit = true;

class CnBlogHomePage extends StatelessWidget {
  const CnBlogHomePage({Key key, this.labelId}) : super(key: key);

  final String labelId;

  @override
  Widget build(BuildContext context) {
    LogUtil.e("CnHomePage build......");
    RefreshController _controller = new RefreshController();
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);
    bloc.commonListStatusStream.listen((event) {
      if (labelId == event.labelId) {
        if (event.loading == LoadStatus.idle) {
          _controller.loadComplete();
        } else if (event.loading == LoadStatus.noMore) {
          _controller.loadNoData();
        }
      }
    });

    if (isInit) {
      isInit = false;
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        bloc.onRefresh(labelId: labelId);
      });
    }

    return new StreamBuilder(
      stream: bloc.cnblogStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<CnBlogsSitehomeItem>> snapshot) {
        return new RefreshScaffold(
          labelId: labelId,
          isLoading: snapshot.data == null,
          controller: _controller,
          onRefresh: () {
            return bloc.onRefresh(labelId: labelId);
          },
          onLoadMore: () {
            bloc.onLoadMore(labelId: labelId);
          },
          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            CnBlogsSitehomeItem model = snapshot.data[index];
            return new HomeItem(model: model);
          },
        );
      },
    );
  }
}
