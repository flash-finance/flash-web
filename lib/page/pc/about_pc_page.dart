import 'dart:async';

import 'package:flash_web/common/color.dart';
import 'package:flash_web/config/service_config.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/page/pc/top_pc_page.dart';
import 'package:flash_web/provider/common_provider.dart';
import 'package:flash_web/provider/index_provider.dart';
import 'package:flash_web/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'dart:js' as js;

import 'package:url_launcher/url_launcher.dart';


class AboutPcPage extends StatefulWidget {
  @override
  _AboutPcPageState createState() => _AboutPcPageState();
}

class _AboutPcPageState extends State<AboutPcPage> {
  bool _tronFlag = false;
  String _account = '';
  Timer _timer0;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        CommonProvider.changeHomeIndex(4);
      });
    }
    Provider.of<IndexProvider>(context, listen: false).init();
    _reloadAccount();
  }

  @override
  void dispose() {
    if (_timer0 != null) {
      if (_timer0.isActive) {
        _timer0.cancel();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocalScreenUtil.instance = LocalScreenUtil.getInstance()..init(context);
    bool langType = Provider.of<IndexProvider>(context, listen: true).langType;
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: MyColors.white,
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1500),
        child: TopPcPage(_account),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    child: SizedBox(
                      height: 300,
                      width: screenSize.width,
                      child: Image.asset(
                        'images/bg.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(height: 80),
                          _topWidget(context),
                          _bizWidget(context),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topWidget(BuildContext context) {
    return Container(
      width: 1000,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Flash  Finance',
                      style: GoogleFonts.lato(
                        fontSize: 30,
                        color: MyColors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      '${S.of(context).aboutTips01}',
                      style: GoogleFonts.lato(fontSize: 14, color: MyColors.white),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(flashGithub).catchError((error) {
                        print('launch error:$error');
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'github:  ',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: MyColors.white,
                              ),
                            ),
                            TextSpan(
                              text: '${S.of(context).aboutTips02}',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: MyColors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

  Widget _bizWidget(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        width: 1000,
        padding: EdgeInsets.only(left: 80, top: 50, right: 80, bottom: 50),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                '${S.of(context).aboutTips03}',
                style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[800]),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                '${S.of(context).aboutTips04}',
                style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[800]),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ),
            InkWell(
              onTap: () {
                launch(swapContract).catchError((error) {
                  print('launch error:$error');
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${S.of(context).aboutTips051}',
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.grey[800],
                        ),
                      ),
                      TextSpan(
                        text: '${S.of(context).aboutTips052}',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.grey[800],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                '${S.of(context).aboutTips06}',
                style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[800]),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                '${S.of(context).aboutTips07}',
                style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[800]),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _reloadAccountFlag = false;

  _reloadAccount() async {
    _getAccount();
    _timer0 = Timer.periodic(Duration(milliseconds: 2000), (timer) async {
      if (_reloadAccountFlag) {
        _getAccount();
      }
    });
  }

  _getAccount() async {
    _reloadAccountFlag = false;
    _tronFlag = js.context.hasProperty('tronWeb');
    if (_tronFlag) {
      var result = js.context["tronWeb"]["defaultAddress"]["base58"];
      if (result.toString() != 'false' && result.toString() != _account) {
        if (mounted) {
          setState(() {
            _account = result.toString();
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _account = '';
        });
      }
    }
    _reloadAccountFlag = true;
  }

}
