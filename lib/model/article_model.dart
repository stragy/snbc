
class ArticleModel {
  var article_id;
  var article_title;
  var article_lecturer;
  var article_see;
  var article_img;
  var add_time;
  var article_content;

  ArticleModel({
    this.article_id,
    this.article_title,
    this.article_lecturer,
    this.article_see,
    this.article_img,
    this.add_time,
    this.article_content
  });

  factory ArticleModel.fromJSON(Map<String, dynamic> json) {
    return ArticleModel(
      article_id: json['article_id'],
      article_title: json['article_title'],
      article_lecturer: json['article_lecturer'],
      article_see: json['article_see'],
      article_img: json['article_img'],
      add_time: json['add_time'],
      article_content: json['article_content'],
    );
  }
}