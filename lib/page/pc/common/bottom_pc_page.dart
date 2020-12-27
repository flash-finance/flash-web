import 'package:flash_web/util/common_util.dart';
import 'package:flutter/material.dart';

class BottomPcPage extends StatefulWidget {
  final Color color;

  BottomPcPage({this.color});
  @override
  _BottomPcPageState createState() => _BottomPcPageState();
}

class _BottomPcPageState extends State<BottomPcPage> {
  Color _color;
  @override
  Widget build(BuildContext context) {
    _color = widget.color == null ? Colors.grey[200] : widget.color;
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      color: _color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Copyright © 2020 | Flash Finance',
              style: Util.textStyle4PcEn(context, 1, Colors.black87,
                  spacing: 0.0, size: 14.5),
            ),
          ),
        ],
      ),
    );
  }
}
