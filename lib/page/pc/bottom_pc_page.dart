import 'package:flutter/material.dart';

class BottomPcPage extends StatefulWidget {
  @override
  _BottomPcPageState createState() => _BottomPcPageState();
}

class _BottomPcPageState extends State<BottomPcPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      color: Theme.of(context).bottomAppBarColor,
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              'Copyright © 2020 | Flash Finance',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
