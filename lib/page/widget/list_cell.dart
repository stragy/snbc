import 'package:bct_flutter/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ListCell extends StatelessWidget {
  ListCell({Key key, this.icon, this.title, this.onTap, this.isDivider = false})
      : super(key: key);

  final bool isDivider;
  final String title;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      icon == null
                          ? Container(
                              padding: EdgeInsets.only(left: 15, right: 10),
                            )
                          : Container(
                              padding: EdgeInsets.only(left: 15, right: 10),
                              child: Image.network(
                                "http://snbc.zglcwl.com/Public/fontImages" +
                                    icon,
                              ),
                              width: 23,
                              height: 23,
                            ),
                      Text(
                        this.title,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Container(
                    child: Image.network(
                      "http://snbc.zglcwl.com/Public/fontImages/button_next.png",
                      width: 16,
                      height: 16,
                    ),
                    padding: EdgeInsets.only(left: 15, right: 15),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            Divider(
              color:
                  this.isDivider ? Color(AppColors.BG_EE) : Colors.transparent,
              height: 1,
            )
          ],
        ),
        color: Colors.white,
      ),
      onTap: this.onTap ?? () => {},
    );
  }
}
