import 'dart:async';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:readitnews/models/juejin/listresult.dart';
import 'package:readitnews/models/juejin/search_args.dart';

class JuejinServices {
  static final int pageCount = 20;
  static String getQueryId(JuejinCategory category) {
    var id = "";
    switch (category) {
      case JuejinCategory.Recommend:
        id = "21207e9ddb1de777adeaca7a2fb38030";
        break;
      default:
        break;
    }
    return id;
  }
// {first: 20, after: "", order: "NEWEST"}
  //{"operationName":"","query":"","variables":{"first":20,"after":"","order":"POPULAR"},"extensions":{"query":{"id":"21207e9ddb1de777adeaca7a2fb38030"}}}

  static Future<ListResult> getListData(String after, JuejinCategory category,
      {String order}) async {
    order = order ?? 'NEWEST'; //默认最新排序
    var id = getQueryId(category);

    SearchArgs args = new SearchArgs(
      operationName: "",
      query: "",
      variables: new Variables(first: pageCount, after: after, order: order),
      extensions: new Extensions(
        query: new Query(id: id),
      ),
    );
    Dio dio = new Dio();
    var url = 'https://web-api.juejin.im/query';

    var data = await dio.post(url,
        data: args,
        options: new Options(
          headers: {
            "X-Agent": "Juejin/Web",
          },
        ));
    return ListResult.fromJson(data.data);
  }

  static Future<String> getDetails(String title, String url) async {
    //  await Future.delayed(new Duration(milliseconds: 50));
    var html = '';
    Dio dio = new Dio();
    Response response = await dio.get(url);
    // blogpost-body
    if (url.contains('juejin')) {
      var document = parse(response.data);
      var data = document.getElementsByClassName("article");
      html = "<h2>$title</h2>" + data[0].innerHtml;
    } else {
      html = response.data;
    }
    return html;
  }
}
