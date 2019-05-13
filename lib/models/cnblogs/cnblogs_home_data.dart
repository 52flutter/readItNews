class CnBlogsAuthor {
  String name;
  String uri;
  String avatar;
  CnBlogsAuthor(this.name, this.uri, this.avatar);
}

class CnBlogsSitehomeItem {
  String id;
  String title;
  String summary;
  String published;
  String updated;
  String link;
  String blogapp;
  int diggs;
  int views;
  int comments;
  CnBlogsAuthor author;
  CnBlogsSitehomeItem(
      this.id,
      this.title,
      this.summary,
      this.published,
      this.updated,
      this.link,
      this.blogapp,
      this.diggs,
      this.views,
      this.comments,
      this.author);
}
