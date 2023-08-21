
import 'package:flutter/material.dart';

import 'UserInfo.dart';

class UserInfoModel extends ChangeNotifier {

  String user_id;
  String username;
  String add_time;
  String head;
  String nickname;
  String birth;
  String sex;
  String msg;

  UserInfoModel({this.user_id, this.username, this.nickname, this.add_time, this.birth,
    this.sex, this.msg,  this.head});
  void setData({telephone,nickname,idCard,wxNickname,wxHeadimgurl,sex,unionid,status,userid,name,proprietorId,head,password}) {
    if(nickname!=null){
      this.nickname = nickname;
    }
    if(user_id!=null){
      this.user_id = user_id;
    }
    if(username!=null){
      this.username = username;
    }
    if(add_time!=null){
      this.add_time = add_time;
    }
    if(birth!=null){
      this.birth = birth;
    }
    if(msg!=null){
      this.msg = msg;
    }
    if(sex!=null){
      this.sex = sex;
    }
    if(head!=null){
      this.head = head;
    }
    notifyListeners();
  }

  String get getnickname => this.nickname;
  String get gethead => this.head;
  String get getuserid => this.user_id;
  String get getbirth=> this.birth;
  String get getadd_time => this.add_time;
  String get getmsg=> this.msg;
  String get getsex => this.sex;
  String get getname=> this.username;
}