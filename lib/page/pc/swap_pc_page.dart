import 'dart:async';

import 'package:flash_web/common/color.dart';
import 'package:flash_web/config/service_config.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/model/lang_model.dart';
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


class SwapPcPage extends StatefulWidget {
  @override
  _SwapPcPageState createState() => _SwapPcPageState();
}

class _SwapPcPageState extends State<SwapPcPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool tronFlag = false;
  Timer _timer;

  @override
  void initState() {
    print('SwapPcPage initState');
    super.initState();
    if (mounted) {
      setState(() {
        CommonProvider.changeHomeIndex(1);
      });
    }
    _reloadAccount();
  }

  @override
  void dispose() {
    print('SwapPcPage dispose');
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
      margin: EdgeInsets.only(top: 50),
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
                      'Flash  Swap',
                      style: GoogleFonts.lato(
                        fontSize: 30,
                        color: MyColors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      '${S.of(context).aboutTips4}',
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
        height: 500,
        padding: EdgeInsets.only(left: 80, top: 30, right: 80, bottom: 50),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            _dataWidget(context),
            SizedBox(height: 80),
            _swapWidget(context),
          ],
        ),
      ),
    );
  }


  Widget _dataWidget(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          _dataLeftWidget(context),
          SizedBox(width: 10),
          _dataMidWidget(context),
          SizedBox(width: 10),
          _dataRightWidget(context),
        ],
      )
    );
  }

  Widget _dataLeftWidget(BuildContext context) {
    return Container(
      width: 380,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    '发送',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 2),
                  child: Text(
                    '余额:  17632.453',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.only(top: 2, bottom: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1.0, color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 15),
                      Container(
                        child: ClipOval(
                          child: Image.asset(
                            'images/usdt.png',
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 45,
                        child: Text(
                          'USDT',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: MyColors.grey700,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(width: 0.8, color: Colors.black12)),
                        ),
                        child: Icon(Icons.arrow_drop_down, size: 28, color: Colors.black54),
                      ),
                      SizedBox(width: 15),
                    ],
                  ),
                ),
                Container(
                    width: 170,
                    padding: EdgeInsets.only(left: 0),
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      enableInteractiveSelection: false,
                      cursorColor: MyColors.black87,
                      decoration: InputDecoration(
                        hintText: '输入数量',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16, letterSpacing: 0.5),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (String value) {},
                      onSaved: (String value) {},
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      //inputFormatters: [DoubleFormat4Trade()],
                    )
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 40,
                    alignment: Alignment.centerRight,
                    child: Text('MAX',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    '1  USDT  =  39.561  TRX',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: MyColors.grey700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    'Fee:  0.1%',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: MyColors.grey700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dataMidWidget(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: MyColors.white,
      alignment: Alignment.topCenter,
      child: Icon(
        Icons.arrow_forward_sharp,
        size: 28,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _dataRightWidget(BuildContext context) {
    return Container(
      width: 380,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    '接收',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 2),
                  child: Text(
                    '余额:  6548.453',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.only(top: 2, bottom: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1.0, color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 15),
                      Container(
                        child: ClipOval(
                          child: Image.asset(
                            'images/trx.png',
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 45,
                        child: Text(
                          'TRX',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: MyColors.grey700,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(width: 0.8, color: Colors.black12)),
                        ),
                        child: Icon(Icons.arrow_drop_down, size: 28, color: Colors.black54),
                      ),
                      SizedBox(width: 15),
                    ],
                  ),
                ),
                Container(
                    width: 200,
                    padding: EdgeInsets.only(left: 0),
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      enableInteractiveSelection: false,
                      cursorColor: MyColors.black87,
                      decoration: InputDecoration(
                        hintText: '输入数量',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16, letterSpacing: 0.5),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (String value) {},
                      onSaved: (String value) {},
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      //inputFormatters: [DoubleFormat4Trade()],
                    )
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    //'1  USDT  =  39.561  TRX',
                    '986471707.4153  TRX',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: MyColors.grey700,
                      //color: MyColors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    //'Fee:  0.03%',
                    '25116757.4774  USDT',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: MyColors.grey700,
                      //color: MyColors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _swapWidget(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        child: Chip(
          padding: EdgeInsets.only(left: 80, top: 15, right: 80, bottom: 15),
          backgroundColor:  MyColors.blue500,
          label: Container(
            child: Text(
              '兑换',
              style: GoogleFonts.lato(
                letterSpacing: 0.7,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
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
    int langType = Provider.of<IndexProvider>(context).langType;
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
              langType == 1 ? 'English' : '简体中文',
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
            Application.router.navigateTo(context, 'farm', transition: TransitionType.fadeIn);
          } else if (index == 1) {
            Application.router.navigateTo(context, 'swap', transition: TransitionType.fadeIn);
          } else if (index == 2) {
            Application.router.navigateTo(context, 'wallet', transition: TransitionType.fadeIn);
          } else if (index == 3) {
            Application.router.navigateTo(context, 'about', transition: TransitionType.fadeIn);
          } else if (index == 4 && account == '') {
            _showConnectWalletDialLog();
          } else if (index == 5) {
            _showLangTypeDialLog();
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

  _showLangTypeDialLog() {
    List<LangModel> langModels = Provider.of<IndexProvider>(context, listen: false).langModels;
    showDialog(
      context: context,
      child: AlertDialog(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        content: Container(
          width: 300,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: langModels.length,
            itemBuilder: (context, index) {
              return _selectLangTypeItemWidget(context, index, langModels[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _selectLangTypeItemWidget(BuildContext context, int index, LangModel item) {
    int langType = Provider.of<IndexProvider>(context, listen: false).langType;
    bool flag = index == langType ? true : false;
    return InkWell(
      onTap: () {
        Provider.of<IndexProvider>(context, listen: false).changeLangType(index);
        Navigator.pop(context);
      },
      child: Container(
        width: 300,
        //color: MyColors.white,
        padding: EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 200,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                '${item.name}',
                style: TextStyle(
                  color: !flag ? Colors.black87 : Colors.blue[800],
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: 100,
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              alignment: Alignment.centerRight,
              child: !flag ? Container() : Icon(
                Icons.check,
                color: Colors.blue[800],
                size: 20,
              ),
            ),
          ],
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
