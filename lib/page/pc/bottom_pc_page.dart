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
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 14.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
