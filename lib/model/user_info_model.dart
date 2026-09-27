import 'package:flutter/material.dart';

class UserInfoModel extends ChangeNotifier {
  String userId = '';
  String username = '';
  String addTime = '';
  String head = '';
  String nickname = '';
  String birth = '';
  String sex = '';
  String msg = '';

  UserInfoModel({
    this.userId = '',
    this.username = '',
    this.nickname = '',
    this.addTime = '',
    this.birth = '',
    this.sex = '',
    this.msg = '',
    this.head = '',
  });

  void setData({
    String? telephone,
    String? nickname,
    String? idCard,
    String? wxNickname,
    String? wxHeadimgurl,
    String? sex,
    String? unionid,
    String? status,
    String? userid,
    String? name,
    String? addTime,
    String? birth,
    String? msg,
    String? proprietorId,
    String? head,
    String? password,
  }) {
    if (nickname != null) {
      this.nickname = nickname;
    }
    if (userid != null) {
      userId = userid;
    }
    if (name != null) {
      username = name;
    }
    if (addTime != null) {
      this.addTime = addTime;
    }
    if (birth != null) {
      this.birth = birth;
    }
    if (msg != null) {
      this.msg = msg;
    }
    if (sex != null) {
      this.sex = sex;
    }
    if (head != null) {
      this.head = head;
    }
    notifyListeners();
  }

  // Keep existing getters to avoid breaking external code
  String get getnickname => nickname;
  String get gethead => head;
  String get getuserid => userId;
  String get getbirth => birth;
  String get getAddTime => addTime;
  String get getmsg => msg;
  String get getsex => sex;
  String get getname => username;
}
