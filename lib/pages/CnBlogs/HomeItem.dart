import 'package:flutter/material.dart';
import 'package:readitnews/components/ProgressView.dart';
import 'package:readitnews/models/cnblogs/cnblogs_home_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:readitnews/routers/router.dart';
import 'package:readitnews/utils/styles.dart';

class HomeItem extends StatelessWidget {
  final CnBlogsHomeModel model;
  const HomeItem({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var newsInfo = model;
    return new InkWell(
      key: new Key(newsInfo.href),
      onTap: () {
        Router.navigateTo(context, Routes.cnBlogDetails,
            param: {"itemData": model});
      },
      child: new Container(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            border: new Border(
                bottom: new BorderSide(width: 1, color: Colours.divider))),
        // elevation: 2.0,
        child: new Column(
          children: <Widget>[
            new Container(
              alignment: Alignment.centerLeft,
              child: new Text(
                newsInfo.title,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                // textScaleFactor: 1.0,
                textAlign: TextAlign.start,
                style: TextStyles.listTitle,
              ),
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            ),
            new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 40.0,
                    height: 40.0,
                    child: newsInfo.headpic == ""
                        ? new Icon(Icons.error)
                        : new CachedNetworkImage(
                            width: 40,
                            height: 40,
                            fit: BoxFit.fill,
                            imageUrl: newsInfo.headpic,
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
                        newsInfo.desc,
                        textAlign: TextAlign.left,
                        maxLines: 4,
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
              // padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Row(
                    // Image.network()
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(newsInfo.authorName),
                      new Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        child: new Text(newsInfo.createTime),
                      ),
                    ],
                  ),
                  new Expanded(
                    // flex: 5,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // new Image(
                        //     image: new AssetImage('images/icon_arrow.gif')),
                        new Text(newsInfo.readCount),
                        // new Padding(
                        //   padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        //   child: new Image(
                        //       image: new AssetImage('images/icon_comment.gif')),
                        // ),
                        new Text(newsInfo.commentCount),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
