import 'dart:async';

import 'package:flash_web/config/service_config.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/provider/common_provider.dart';
import 'package:flash_web/provider/index_provider.dart';
import 'package:flash_web/util/common_util.dart';
import 'package:flash_web/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';

import 'package:provider/provider.dart';
import 'dart:js' as js;

import 'package:url_launcher/url_launcher.dart';

import 'common/bottom_pc_page.dart';
import 'common/header_pc_page.dart';
import 'common/top_pc_page.dart';


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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0,
        ),
        preferredSize: Size.fromHeight(0),
      ),
      body: FooterView(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      HeaderPcPage(),
                      TopPcPage(0, _account),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(height: 80),
                              _topWidget(context),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 205),
                                _bizWidget(context),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        footer: Footer(
          child: BottomPcPage(),
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
              padding: EdgeInsets.only(top: 30, bottom: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Flash  Finance',
                      style: Util.textStyle4PcEn(context, 1, Colors.grey[100], spacing: 0.0, size: 28),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      '${S.of(context).aboutTips01}',
                      style: Util.textStyle4Pc(context, 1, Colors.grey[300], spacing: 0.4, size: 15),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
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
                '${S.of(context).aboutTips04}',
                style: Util.textStyle4Pc(context, 1, Colors.black87, spacing: 0.0, size: 16),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              onTap: () {
                launch(swapContract).catchError((error) {
                  print('launch error:$error');
                });
              },
              child: Container(
                padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${S.of(context).aboutTips051}',
                        style: Util.textStyle4Pc(context, 1, Colors.black87, spacing: 0.0, size: 16),
                      ),
                      TextSpan(
                        text: '${S.of(context).aboutTips052}',
                        style: Util.textStyle4Pc(context, 1, Colors.black87, spacing: 0.0, size: 14),
                      ),
                    ],
                  ),
                ),
                ),
              ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                '${S.of(context).aboutTips07}',
                style: Util.textStyle4Pc(context, 1, Colors.black87, spacing: 0.0, size: 16),
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
