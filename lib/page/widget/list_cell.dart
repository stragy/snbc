import 'package:bct_flutter/constants/colors.dart';
import 'package:flutter/material.dart';

class ListCell extends StatelessWidget {
  const ListCell(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap,
      this.isDivider = false});

  final bool isDivider;
  final String title;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      icon.isEmpty
                          ? Container(
                              padding: EdgeInsets.only(left: 15, right: 10),
                            )
                          : Container(
                              padding: EdgeInsets.only(left: 15, right: 10),
                              width: 23,
                              height: 23,
                              child: Image.network(
                                "http://snbc.zglcwl.com/Public/fontImages$icon",
                              ),
                            ),
                      Text(
                        title,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Image.network(
                      "http://snbc.zglcwl.com/Public/fontImages/button_next.png",
                      width: 16,
                      height: 16,
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: isDivider ? Color(AppColors.BG_EE) : Colors.transparent,
              height: 1,
            )
          ],
        ),
      ),
    );
  }
}
