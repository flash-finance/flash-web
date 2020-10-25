import 'dart:async';

import 'package:flash_web/common/color.dart';
import 'package:flash_web/config/service_config.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/provider/common_provider.dart';
import 'package:flash_web/provider/index_provider.dart';
import 'package:flash_web/router/application.dart';
import 'package:flash_web/util/screen_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'dart:js' as js;

import 'package:url_launcher/url_launcher.dart';


class WalletPcPage extends StatefulWidget {
  @override
  _WalletPcPageState createState() => _WalletPcPageState();
}

class _WalletPcPageState extends State<WalletPcPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool tronFlag = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        CommonProvider.changeHomeIndex(2);
      });
    }
    _reloadAccount();
  }

  @override
  void dispose() {
    if (_timer != null) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocalScreenUtil.instance = LocalScreenUtil.getInstance()..init(context);
    return Material(
      color: MyColors.white,
      child: Scaffold(
        backgroundColor: MyColors.white,
        key: _scaffoldKey,
        appBar: _appBarWidget(context),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _mainWidget(context),
          ],
        ),
      ),
    );
  }


  Widget _mainWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      width: 1000,
      color: MyColors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            child: _bodyWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          _topWidget(context),
          SizedBox(height: 10),
          _bizWidget(context),
        ],
      ),
    );
  }

  Widget _topWidget(BuildContext context) {
    return Container(
      width: 1000,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: [MyColors.blue700, MyColors.blue500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
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
                      style: GoogleFonts.lato(
                        fontSize: 30,
                        color: MyColors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      '${S.of(context).walletTips1}',
                      style: GoogleFonts.lato(fontSize: 17, color: MyColors.white),
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
        padding: EdgeInsets.only(left: 80, top: 80, right: 80, bottom: 80),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              child: Text('Coming  Soon', style: GoogleFonts.lato(fontSize: 30, color: Colors.black87)),
            ),
          ],
        ),
      ),
    );
  }


  Widget _appBarWidget(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      titleSpacing: 0.0,
      leading: _leadingWidget(context),
      title: Container(
        color: MyColors.white,
        margin: EdgeInsets.only(left: LocalScreenUtil.getInstance().setWidth(20)),
        child: Row(
          children: [
            Container(
              child: Image.asset('images/logo.png', fit: BoxFit.contain, width: 80, height: 80),
            ),
          ],
        ),
      ),
      backgroundColor: MyColors.white,
      elevation: 0.0,
      centerTitle: false,
      actions: _actionWidget(context),
    );
  }

  Widget _leadingWidget(BuildContext context) {
    return Container(
      width: 0,
      child: InkWell(
        onTap: () {},
        child: Container(
          color: MyColors.white,
          child: null,
        ),
      ),
    );
  }

  List<Widget> _actionWidget(BuildContext context) {
    List<Widget> _widgetList = [];
    for (int i = 0; i < 6; i++) {
      _widgetList.add(_actionItemWidget(context, i));
    }
    _widgetList.add(SizedBox(width: LocalScreenUtil.getInstance().setWidth(50)));
    return _widgetList;
  }

  Widget _actionItemWidget(BuildContext context, int index) {
    String account = Provider.of<IndexProvider>(context).account;
    int _homeIndex = CommonProvider.homeIndex;
    String actionTitle = '';
    switch(index) {
      case 0:
        actionTitle = S.of(context).actionTitle0;
        break;
      case 1:
        actionTitle = S.of(context).actionTitle1;
        break;
      case 2:
        actionTitle = S.of(context).actionTitle2;
        break;
      case 3:
        actionTitle = S.of(context).actionTitle3;
        break;
      case 4:
        actionTitle = S.of(context).actionTitle4;
        break;
    }
    return Container(
      color: MyColors.white,
      child: InkWell(
        child: index != 4 && index != 5 ?
        Container(
            color: MyColors.white,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                '$actionTitle',
                style: GoogleFonts.lato(
                  fontSize: 16.0,
                  letterSpacing: 0.5,
                  color: _homeIndex == index ? MyColors.black : MyColors.grey700,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ))
            : index != 5 ?
        Container(
          color: MyColors.white,
          child: Chip(
            elevation: 3,
            padding: EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20),
            backgroundColor: MyColors.blue500,
            label: Text(
              account == '' ? '$actionTitle' : account.substring(0, 4) + '...' + account.substring(account.length - 4, account.length),
              style: GoogleFonts.lato(
                letterSpacing: 0.5,
                color: MyColors.white,
                fontSize: 15,
              ),
            ),
          ),
        ) : Container(
          margin: EdgeInsets.only(left: 15),
          color: MyColors.white,
          child: Chip(
            elevation: 3,
            padding: EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20),
            backgroundColor: MyColors.blue500,
            label: Text(
              'English/中文',
              style: GoogleFonts.lato(
                letterSpacing: 0.5,
                color: MyColors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
        onTap: () async {
          if (index != 4 && index != 5) {
            CommonProvider.changeHomeIndex(index);
          }
          if (index == 0) {
            Application.router.navigateTo(context, 'swap', transition: TransitionType.fadeIn);
          } else if (index == 1) {
            Application.router.navigateTo(context, 'farm', transition: TransitionType.fadeIn);
          } else if (index == 2) {
            Application.router.navigateTo(context, 'wallet', transition: TransitionType.fadeIn);
          } else if (index == 3) {
            Application.router.navigateTo(context, 'about', transition: TransitionType.fadeIn);
          } else if (index == 4 && account == '') {
            _showConnectWalletDialLog();
          } else if (index == 5) {
            Provider.of<IndexProvider>(context, listen: false).changeLangType();
          }
        },
      ),
    );
  }

  _showConnectWalletDialLog() {
    showDialog(
      context: context,
      child: AlertDialog(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        content: Container(
          width: 300,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    '请使用TronLink钱包登录',
                    style: GoogleFonts.lato(
                      fontSize: 18.0,
                      letterSpacing: 0.2,
                      color: MyColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                    onTap: () {
                      launch(tronLinkChrome).catchError((error) {
                        print('launch error:$error');
                      });
                    },
                    child: Container(
                      child: Text(
                        '还没安装TronLink？ 请点击此处>>',
                        style: GoogleFonts.lato(
                          fontSize: 15.0,
                          letterSpacing: 0.2,
                          color: MyColors.black87,
                          //decoration: TextDecoration.underline,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }


  _reloadAccount() async {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      tronFlag = js.context.hasProperty('tronWeb');
      if (tronFlag) {
        var result = js.context["tronWeb"]["defaultAddress"]["base58"];
        if (result.toString() != 'false') {
          Provider.of<IndexProvider>(context, listen: false).changeAccount(result.toString());
        } else {
          Provider.of<IndexProvider>(context, listen: false).changeAccount('');
        }
      } else {
        Provider.of<IndexProvider>(context, listen: false).changeAccount('');
      }
    });
  }
}
