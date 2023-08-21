import 'dart:async';

import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';


class TimerCountDownWidget extends StatefulWidget {
  Function onTimerFinish;
  String phone;
  bool reg;
  TimerCountDownWidget({this.onTimerFinish,this.phone,this.reg}) : super();

  @override
  State<StatefulWidget> createState() => TimerCountDownWidgetState();
}

class TimerCountDownWidgetState extends State<TimerCountDownWidget> {
  Timer _timer;
  int _countdownTime = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("object"+widget.phone.toString());
        if( widget.phone.toString().length<5){
          Fluttertoast.showToast(
              msg: "请填写正确手机号",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: ScreenUtil().setSp(24),
              textColor: Color(AppColors.TEXT_WIT),
              backgroundColor: Color(0xFF000000));
        }else{
          if (_countdownTime == 0) {
            setState(() {
              _countdownTime = 60;
            });
            startCountdownTimer();
            //开始倒计时
            FormData formData = new FormData.fromMap({
              "username":  widget.phone,
            });
             Request.getInstance().post(widget.reg?"/regSendNote":"/logSendNote", (data) async {
              setState(() {});
            }, params: formData);

          }
        }

      },
        child: Text(
          _countdownTime > 0 ? '$_countdownTime后重新获取' : '获取验证码',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
            color: _countdownTime > 0
                ? Color(AppColors.BLACK)
                : Color(AppColors.APP_ThEME),
          ),
      ),
    );
  }

  void startCountdownTimer() {


    _timer = Timer.periodic(
        Duration(seconds: 1),
            (Timer timer) => {
          setState(() {
            if (_countdownTime < 1) {
              widget.onTimerFinish();
              _timer.cancel();
            } else {
              _countdownTime = _countdownTime - 1;
            }
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
    widget.onTimerFinish();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}