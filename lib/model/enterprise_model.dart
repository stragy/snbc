class EnterpriseZoneModel {
  final int? id;
  final String? name;
  final String? head;
  final String? img;
  final String? style;
  final String? introduction;
  final List<dynamic>? banner;

  EnterpriseZoneModel({
    this.id,
    this.name,
    this.head,
    this.img,
    this.style,
    this.introduction,
    this.banner,
  });

  factory EnterpriseZoneModel.fromJson(Map<String, dynamic> json) {
    return EnterpriseZoneModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      head: json['head'] as String?,
      img: json['img'] as String?,
      style: json['style'] as String?,
      introduction: json['introduction'] as String?,
      banner: json['banner'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'head': head,
      'img': img,
      'style': style,
      'introduction': introduction,
      'banner': banner,
    };
  }
}
