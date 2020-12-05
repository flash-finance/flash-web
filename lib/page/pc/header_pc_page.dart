import 'package:flash_web/util/screen_util.dart';
import 'package:flutter/material.dart';

class HeaderPcPage extends StatefulWidget {
  @override
  _HeaderPcPageState createState() => _HeaderPcPageState();
}

class _HeaderPcPageState extends State<HeaderPcPage> {
  @override
  Widget build(BuildContext context) {
    LocalScreenUtil.instance = LocalScreenUtil.getInstance()..init(context);
    var screenSize = MediaQuery.of(context).size;

    return Container(
      color: Color(0xff151e5a),
      child: SizedBox(
        height: 300,
        width: screenSize.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Image.asset(
                'images/bg.png',
                width: 450,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              child: Image.asset(
                'images/bg.png',
                width: 450,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
