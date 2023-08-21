
class EnterpriseZoneModel {
  var id;
  var name;
  var head;
  var img;
  var style;
  var introduction;
  var banner;

  EnterpriseZoneModel({
    this.id,
    this.name,
    this.head,
    this.img,
    this.style,
    this.introduction,
    this.banner
  });

  factory EnterpriseZoneModel.fromJSON(Map<String, dynamic> json) {
    return EnterpriseZoneModel(
      id: json['id'],
      name: json['name'],
      head: json['head'],
      img: json['img'],
      style: json['style'],
      banner: json['banner'],
      introduction: json['introduction'],
    );
  }
}