class BannerModel {
  final String? className;

  const BannerModel({this.className});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      className: json['class_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_name': className,
    };
  }
}
