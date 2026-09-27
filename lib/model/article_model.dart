class ArticleModel {
  final int? articleId;
  final String? articleTitle;
  final String? articleLecturer;
  final int? articleSee;
  final String? articleImg;
  final String? addTime;
  final String? articleContent;

  ArticleModel({
    this.articleId,
    this.articleTitle,
    this.articleLecturer,
    this.articleSee,
    this.articleImg,
    this.addTime,
    this.articleContent,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      articleId: json['article_id'] as int?,
      articleTitle: json['article_title'] as String?,
      articleLecturer: json['article_lecturer'] as String?,
      articleSee: json['article_see'] as int?,
      articleImg: json['article_img'] as String?,
      addTime: json['add_time'] as String?,
      articleContent: json['article_content'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'article_id': articleId,
      'article_title': articleTitle,
      'article_lecturer': articleLecturer,
      'article_see': articleSee,
      'article_img': articleImg,
      'add_time': addTime,
      'article_content': articleContent,
    };
  }
}
