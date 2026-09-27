
 // 用户信息
class UserInfo {
  final String userId;
  final String username;
  final String addTime;
  final String head;
  final String nickname;
  final String birth;
  final String sex;
  final String msg;

  UserInfo({
    required this.userId,
    required this.nickname,
    required this.addTime,
    required this.birth,
    required this.msg,
    required this.sex,
    required this.username,
    required this.head,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['user_id']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      addTime: json['add_time']?.toString() ?? '',
      birth: json['birth']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      sex: json['sex']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      head: json['head']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'nickname': nickname,
      'add_time': addTime,
      'birth': birth,
      'msg': msg,
      'sex': sex,
      'username': username,
      'head': head,
    };
  }
}