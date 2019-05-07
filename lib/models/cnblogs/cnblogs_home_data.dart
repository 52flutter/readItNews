class CnBlogsHomeModel {
  String title;
  String headpic;
  String diggnum;
  String desc;
  String href;
  String createTime;
  String readCount;
  String authorName;
  String commentCount;
  CnBlogsHomeModel(this.title, this.href, this.headpic, this.authorName,
      this.createTime, this.readCount, this.commentCount, this.desc,
      {this.diggnum});
}
