import 'dart:async';
import 'package:readitnews/models/cnblogs/cnblogs_home_data.dart';
import 'package:xml/xml.dart' as xml;
import './HttpManager.dart';
import 'ResultData.dart';

class CnBlogServices {
//http://wcf.open.cnblogs.com/blog/sitehome/paged/1/20
// 博客园：　
// 　　博客服务接口： http://wcf.open.cnblogs.com/blog/help
// 　　新闻服务接口： http://wcf.open.cnblogs.com/news/help
// Uri	Method	Description
// 48HoursTopViewPosts/{itemCount}	GET	48小时阅读排行
// bloggers/recommend/{pageIndex}/{pageSize}	GET	分页获取推荐博客列表
// bloggers/recommend/count	GET	获取推荐博客总数
// bloggers/search	GET	根据作者名搜索博主
// post/{postId}/comments/{pageIndex}/{pageSize}	GET	获取文章评论
// post/body/{postId}	GET	获取文章内容
// sitehome/paged/{pageIndex}/{pageSize}	GET	分页获取首页文章列表
// sitehome/recent/{itemcount}	GET	获取首页文章列表
// TenDaysTopDiggPosts/{itemCount}	GET	10天内推荐排行
// u/{blogapp}/posts/{pageIndex}/{pageSize}	GET	分页获取个人博客文章列表
static final int pageCount=30;

static Future<List<CnBlogsSitehomeItem> > getSiteHomeData(int pageIndex) async{
  if(pageIndex==0){
    pageIndex=1;
  }
    List<CnBlogsSitehomeItem> results= new List<CnBlogsSitehomeItem>();
  String url='http://wcf.open.cnblogs.com/blog/sitehome/paged/$pageIndex/$pageCount';
   ResultData resData=await httpManager.fetch(url);
if(resData.result){
  var document = xml.parse(resData.data);

  var rootNode=document.findAllElements('feed').single;

    var entrys =rootNode.findAllElements('entry');
    entrys.forEach((node){
      var id=node.findElements('id').single.text;
      var title=node.findElements('title').single.text;
      var summary=node.findElements('summary').single.text;
      var published=node.findElements('published').single.text;
      var updated=node.findElements('published').single.text;
      var blogapp=node.findElements('blogapp').single.text;
      var diggs=int.parse(node.findElements('diggs').single.text) ;
      var views=int.parse(node.findElements('views').single.text);
      var comments=int.parse(node.findElements('comments').single.text);
      var link=node.findElements('link').single.getAttribute('href');
      var authorNode=node.findElements('author').single;
      var name=authorNode.findElements('name').single.text;
      var uri=authorNode.findElements('uri').single.text;
      var avatar=authorNode.findElements('avatar').single.text;
      CnBlogsAuthor author=new CnBlogsAuthor(name,uri,avatar);
      CnBlogsSitehomeItem dataItems=new CnBlogsSitehomeItem(id,title,summary,published,updated,link,blogapp,diggs,views,comments,author);
      results.add(dataItems);
    });
      return results;
    }
    else{
      return null;
    }

}


  static Future<String> getDetails(String title, String id) async {
    var url='http://wcf.open.cnblogs.com/blog/post/body/$id';
    //  await Future.delayed(new Duration(milliseconds: 50));
    String html = "";

   ResultData resData=await httpManager.fetch(url);
    // Dio dio = new Dio();

    // Response response = await dio.get(url);
    // blogpost-body
    if(resData.result){
  //  var document = xml.parse(resData.data);
  //   var data = document.findAllElements("string").single;
    try {
      html = "<h2>$title</h2>" + resData.data;
    } catch (ex) {
      print(ex);
    }
    }

    return html;
  }
}
//  static Future<List<CnBlogsHome>> getData(int page) async {
//     Dio dio = new Dio();
//     List<CnBlogsHome> result = new List<CnBlogsHome>();
//     Response response;
//     if (page == 1) {
//       response = await dio.get("https://www.cnblogs.com/#p" + page.toString());
//     } else {
//       Options option = new Options();
//       option.headers["content-type"] = "application/json";
//       var data = {
//         "CategoryType": "SiteHome",
//         "ParentCategoryId": 0,
//         "CategoryId": 808,
//         "PageIndex": page,
//         "TotalPostCount": 4000,
//         "ItemListActionName": "PostList"
//       };
//       response = await dio.post(
//           "https://www.cnblogs.com/mvc/AggSite/PostList.aspx",
//           data: data,
//           options: option);
//     }
//     var document = parse(response.data);
//     var list = document.getElementsByClassName("post_item");

//     for (var i = 0; i < list.length; i++) {
//       var title = list[i].getElementsByClassName("titlelnk")[0].innerHtml;
//       var href =
//           list[i].getElementsByClassName("titlelnk")[0].attributes["href"];
//       var headpic = list[i].getElementsByClassName("pfs").length > 0
//           ? "https:" +
//               list[i].getElementsByClassName("pfs")[0].attributes["src"]
//           : "";
//       var diggnum = list[i].getElementsByClassName("diggnum")[0].innerHtml;
//       var desc = list[i].getElementsByClassName("post_item_summary")[0].text;
//       // lightblue
//       var authorName = list[i].getElementsByClassName("lightblue")[0].text;
//       var other = list[i].getElementsByClassName("post_item_foot")[0];
//       RegExp regExp = new RegExp(r'(\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2})');
//       var time =
//           CommonUtils.convertDateStr(regExp.stringMatch(other.innerHtml));
//       if (desc.length > 50) {
//         desc = desc.substring(0, 50) + '...';
//       }
//       var commentCount = list[i]
//           .getElementsByClassName("article_comment")[0]
//           .text
//           .replaceAll(r'\n', '')
//           .trim();
//       var readCount = list[i].getElementsByClassName("article_view")[0].text;
//       result.add(new CnBlogsHome(
//           title, href, headpic, authorName, time, readCount, commentCount, desc,
//           diggnum: diggnum));
//     }
//     return result;
//   }