import 'package:flash_web/util/common_util.dart';
import 'package:flutter/material.dart';

class BottomPcPage extends StatefulWidget {
  @override
  _BottomPcPageState createState() => _BottomPcPageState();
}

class _BottomPcPageState extends State<BottomPcPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Copyright © 2020 | Flash Finance',
              style: Util.textStyle4Pc(context, 1, Colors.black87, spacing: 0.0, size: 14.5),
            ),
          ),
        ],
      ),
    );
  }
}
