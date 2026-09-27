import 'dart:async';

import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TimerCountDownWidget extends StatefulWidget {
  final VoidCallback onTimerFinish;
  final String phone;
  final bool reg;
  const TimerCountDownWidget({
    super.key,
    required this.onTimerFinish,
    required this.phone,
    required this.reg,
  });

  @override
  State<StatefulWidget> createState() => TimerCountDownWidgetState();
}

class TimerCountDownWidgetState extends State<TimerCountDownWidget> {
  Timer? _timer;
  int _countdownTime = 0;

  /// 获取当前最新的手机号
  String get _currentPhone => widget.phone;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final phone = _currentPhone;
        debugPrint("获取验证码, phone=$phone");
        if (phone.length < 5) {
          Fluttertoast.showToast(
              msg: "请填写正确手机号",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: ScreenUtil().setSp(24),
              textColor: Color(AppColors.TEXT_WHITE),
              backgroundColor: Color(0xFF000000));
        } else {
          if (_countdownTime == 0) {
            setState(() {
              _countdownTime = 60;
            });
            startCountdownTimer();
            // 发送验证码请求
            FormData formData = FormData.fromMap({
              "username": phone,
            });
            Request.getInstance().post(
                widget.reg ? "/regSendNote" : "/logSendNote", (data) async {
              // 验证码发送成功
              Fluttertoast.showToast(
                  msg: "验证码已发送",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: ScreenUtil().setSp(24),
                  textColor: Color(AppColors.TEXT_WHITE),
                  backgroundColor: Color(0xFF000000));
            }, params: formData);
          }
        }
      },
      child: Text(
        _countdownTime > 0 ? '${_countdownTime}s后重新获取' : '获取验证码',
        style: TextStyle(
          fontSize: ScreenUtil().setSp(28),
          color: _countdownTime > 0
              ? Color(AppColors.BLACK)
              : Color(AppColors.APP_THEME),
        ),
      ),
    );
  }

  void startCountdownTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdownTime < 1) {
          widget.onTimerFinish();
          _timer?.cancel();
        } else {
          _countdownTime = _countdownTime - 1;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
