import 'dart:async';

import 'package:flash_web/config/service_config.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/model/tron_info_model.dart';
import 'package:flash_web/provider/common_provider.dart';
import 'package:flash_web/provider/index_provider.dart';
import 'package:flash_web/service/method_service.dart';
import 'package:flash_web/util/common_util.dart';
import 'package:flash_web/util/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:js' as js;

import 'common/bottom_pc_page.dart';
import 'common/header_pc_page.dart';
import 'common/top_pc_page.dart';

class WalletPcPage extends StatefulWidget {
  @override
  _WalletPcPageState createState() => _WalletPcPageState();
}

class _WalletPcPageState extends State<WalletPcPage> {
  bool _tronFlag = false;
  String _account = '';
  Timer _timer0;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        CommonProvider.changeHomeIndex(3);
      });
    }

    Provider.of<IndexProvider>(context, listen: false).init();
    _getTronInfo();
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
      backgroundColor: Colors.white,
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
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 80),
                              _topWidget(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  _tronInfo != null ? _picWidget(context) : Container(),
                ],
              ),
            ),
          )
        ],
        footer: Footer(
          backgroundColor: Colors.white,
          child: BottomPcPage(color: Colors.white),
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
                      'Flash  Wallet',
                      style: Util.textStyle4PcEn(context, 1, Colors.grey[100],
                          spacing: 0.0, size: 28),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      '${S.of(context).walletTips01}',
                      style: Util.textStyle4Pc(context, 1, Colors.grey[300],
                          spacing: 0.0, size: 15),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  _tronInfo != null
                      ? _androidDownloadWidget(context)
                      : Container(),
                ],
              )),
        ],
      ),
    );
  }

  Widget _androidDownloadWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              launch('${_tronInfo.androidDownloadUrl}').catchError((error) {});
            },
            child: Container(
              child: Chip(
                padding:
                    EdgeInsets.only(left: 18, top: 15, bottom: 15, right: 18),
                backgroundColor: Colors.white,
                label: Text(
                  'Android ${S.of(context).walletDownload}',
                  style: Util.textStyle4PcEn(context, 2, Colors.grey[850],
                      spacing: 0.0, size: 16),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: Text(
              'V${_tronInfo.androidVersionNum} ${S.of(context).walletVersion}',
              style: Util.textStyle4PcEn(context, 1, Colors.white,
                  spacing: 0.0, size: 16),
              maxLines: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _picWidget(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset('images/app-01.png',
                fit: BoxFit.contain, width: 350, height: 500),
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Image.asset('images/app-02.png',
                fit: BoxFit.contain, width: 350, height: 500),
          ),
        ],
      ),
    );
  }

  bool _reloadAccountFlag = false;

  TronInfo _tronInfo;

  TronInfo get tronInfo => _tronInfo;

  _getTronInfo() async {
    try {
      String url = servicePath['tronInfoQuery'];
      await requestGet(url).then((val) {
        var respData = Map<String, dynamic>.from(val);
        TronInfoRespModel respModel = TronInfoRespModel.fromJson(respData);
        if (respModel != null &&
            respModel.code == 0 &&
            respModel.data != null) {
          if (respModel.data.tronInfo != null) {
            if (mounted) {
              setState(() {
                _tronInfo = respModel.data.tronInfo;
              });
            }
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

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
