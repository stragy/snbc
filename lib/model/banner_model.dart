
class BannerModel {
  var class_name;

  BannerModel({
    this.class_name,
  });

  factory BannerModel.fromJSON(Map<String, dynamic> json) {
    return BannerModel(
      class_name: json['class_name'],
    );
  }
}
