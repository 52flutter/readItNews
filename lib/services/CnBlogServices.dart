import 'dart:async';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:readitnews/models/cnblogs/cnblogs_home_data.dart';
import 'package:readitnews/utils/CommonUtils.dart';

class CnBlogServices {
  static Future<List<CnBlogsHomeModel>> getData(int page) async {
    Dio dio = new Dio();
    List<CnBlogsHomeModel> result = new List<CnBlogsHomeModel>();
    Response response;
    if (page == 1) {
      response = await dio.get("https://www.cnblogs.com/#p" + page.toString());
    } else {
      Options option = new Options();
      option.headers["content-type"] = "application/json";
      var data = {
        "CategoryType": "SiteHome",
        "ParentCategoryId": 0,
        "CategoryId": 808,
        "PageIndex": page,
        "TotalPostCount": 4000,
        "ItemListActionName": "PostList"
      };
      response = await dio.post(
          "https://www.cnblogs.com/mvc/AggSite/PostList.aspx",
          data: data,
          options: option);
    }
    var document = parse(response.data);
    var list = document.getElementsByClassName("post_item");

    for (var i = 0; i < list.length; i++) {
      var title = list[i].getElementsByClassName("titlelnk")[0].innerHtml;
      var href =
          list[i].getElementsByClassName("titlelnk")[0].attributes["href"];
      var headpic = list[i].getElementsByClassName("pfs").length > 0
          ? "https:" +
              list[i].getElementsByClassName("pfs")[0].attributes["src"]
          : "";
      var diggnum = list[i].getElementsByClassName("diggnum")[0].innerHtml;
      var desc = list[i].getElementsByClassName("post_item_summary")[0].text;
      // lightblue
      var authorName = list[i].getElementsByClassName("lightblue")[0].text;
      var other = list[i].getElementsByClassName("post_item_foot")[0];
      RegExp regExp = new RegExp(r'(\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2})');
      var time =
          CommonUtils.convertDateStr(regExp.stringMatch(other.innerHtml));
      // if (desc.length > 50) {
      //   desc = desc.substring(0, 50) + '...';
      // }
      var commentCount = list[i]
          .getElementsByClassName("article_comment")[0]
          .text
          .replaceAll(r'\n', '')
          .trim();
      var readCount = list[i].getElementsByClassName("article_view")[0].text;
      result.add(new CnBlogsHomeModel(
          title, href, headpic, authorName, time, readCount, commentCount, desc,
          diggnum: diggnum));
    }
    return result;
  }
}
