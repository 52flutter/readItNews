import 'package:flutter/material.dart';
import 'package:readitnews/components/ProgressView.dart';
import 'package:readitnews/models/cnblogs/cnblogs_home_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:readitnews/routers/router.dart';
import 'package:readitnews/utils/styles.dart';
import 'package:readitnews/utils/CommonUtils.dart';

class HomeItem extends StatelessWidget {
  final CnBlogsSitehomeItem model;
  const HomeItem({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var newsInfo = model;
    return new Material(
      color: Colors.white,
      child: new InkWell(
        key: new Key(model.id),
        onTap: () {
          Router.navigateTo(context, Routes.cnBlogDetails,
              param: {"itemData": model, 'key': model});
        },
        child: new Container(
          padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
          decoration: new BoxDecoration(
            // color: Colors.white,
            border: new Border(
              bottom: new BorderSide(width: 1, color: Colours.divider),
            ),
          ),
          // elevation: 2.0,
          child: new Column(
            children: <Widget>[
              new Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  model.title ?? '',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  // textScaleFactor: 1.0,
                  textAlign: TextAlign.start,
                  style: TextStyles.listTitle,
                ),
                // padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
              ),
              new Container(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 40.0,
                      height: 40.0,
                      child: model.author.avatar == ""
                          ? new Icon(Icons.error)
                          : new CachedNetworkImage(
                              width: 40,
                              height: 40,
                              fit: BoxFit.fill,
                              imageUrl: model.author.avatar,
                              placeholder: (context, url) => new ProgressView(),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                    ),
                    new Expanded(
                      child: new Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 10.0),
                        child: new Text(
                          model.summary,
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.listContent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                // padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Row(
                      // Image.network()
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Icon(
                          Icons.assignment_ind,
                          size: 13,
                          color: Colours.gray_66,
                        ),
                        new Text(
                          model.author.name ?? "",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colours.gray_66,
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: new Row(
                            children: <Widget>[
                              new Icon(
                                Icons.access_time,
                                size: 12,
                                color: Colours.gray_99,
                              ),
                              new Text(
                                CommonUtils.convertDateStr(model.updated),
                                // newsInfo.createTime,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colours.gray_99,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    new Expanded(
                      // flex: 5,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Icon(
                            Icons.book,
                            size: 12,
                            color: Colours.gray_99,
                          ),
                          new Text(
                            '阅读:${model.views.toString()}',
                            style:
                                TextStyle(fontSize: 12, color: Colours.gray_99),
                          ),
                          new Icon(
                            Icons.comment,
                            size: 12,
                            color: Colours.gray_99,
                          ),
                          new Text(
                            '评论:${model.comments.toString()}',
                            style:
                                TextStyle(fontSize: 12, color: Colours.gray_99),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
