import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:flash_web/common/color.dart';
import 'package:flash_web/config/service_config.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/model/swap_model.dart';
import 'package:flash_web/provider/common_provider.dart';
import 'package:flash_web/provider/index_provider.dart';
import 'package:flash_web/router/application.dart';
import 'package:flash_web/service/method_service.dart';
import 'package:flash_web/util/common_util.dart';
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
  Timer _timer1;
  Timer _timer2;
  Timer _timer3;

  bool _flag1 = false;
  bool _flag2 = false;

  int _leftSelectIndex = 0;
  int _rightSelectIndex = 1;

  String _leftBalanceAmount = '0.000';
  String _rightBalanceAmount = '0.000';

  String _leftSwapAmount = '';
  String _rightSwapAmount = '';

  String _leftSwapValue = '';
  String _rightSwapValue = '';

  TextEditingController _leftSwapAmountController;
  TextEditingController _rightSwapAmountController;

  @override
  void initState() {
    print('SwapPcPage initState');
    super.initState();
    if (mounted) {
      setState(() {
        CommonProvider.changeHomeIndex(0);
      });
    }
    _reloadSwapData();
    _reloadAccount();
    _reloadTokenBalance();
  }

  @override
  void dispose() {
    print('SwapPcPage dispose');
    if (_timer1 != null) {
      if (_timer1.isActive) {
        _timer1.cancel();
      }
    }
    if (_timer2 != null) {
      if (_timer2.isActive) {
        _timer2.cancel();
      }
    }
    if (_timer3 != null) {
      if (_timer3.isActive) {
        _timer3.cancel();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocalScreenUtil.instance = LocalScreenUtil.getInstance()..init(context);
    _leftSwapAmountController =  TextEditingController.fromValue(TextEditingValue(text: _leftSwapAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _leftSwapAmount.length))));
    _rightSwapAmountController =  TextEditingController.fromValue(TextEditingValue(text: _rightSwapAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _rightSwapAmount.length))));

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
                      'Flash  Swap 555',
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
        padding: EdgeInsets.only(left: 80, top: 20, right: 80, bottom: 60),
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
    String price = '0.000';
    if (_flag1 && _flag2 && _swapRows[_rightSelectIndex].swapTokenPrice1 > 0) {
      price = (_swapRows[_leftSelectIndex].swapTokenPrice1/_swapRows[_rightSelectIndex].swapTokenPrice1).toStringAsFixed(4);
    }
    if (_flag1 && _flag2 && _swapRows[_leftSelectIndex].swapTokenPrecision > 0
        && _balanceMap[_swapRows[_leftSelectIndex].swapTokenAddress] != null) {
      _leftBalanceAmount = (Decimal.tryParse(_balanceMap[_swapRows[_leftSelectIndex].swapTokenAddress])/Decimal.fromInt(10).pow(_swapRows[_leftSelectIndex].swapTokenPrecision)).toStringAsFixed(3);
    }

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
                      color: MyColors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 2),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '余额:  ',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: MyColors.grey700,
                            ),
                          ),
                          TextSpan(
                            text: '$_leftBalanceAmount',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: MyColors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(width: 1.0, color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _showSwapTokenDialLog(context, 1);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 15),
                          Container(
                            child: ClipOval(
                              child: _flag1 ? Image.network(
                                '${_swapRows[_leftSelectIndex].swapPicUrl}',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ) : Container(
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 45,
                            child: Text(
                              _flag1 ? '${_swapRows[_leftSelectIndex].swapTokenName}' : '',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: MyColors.grey700,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            child: Icon(Icons.arrow_drop_down, size: 26, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    width: 185,
                    padding: EdgeInsets.only(left: 15, top: 2, bottom: 2),
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      controller: _leftSwapAmountController,
                      enableInteractiveSelection: false,
                      cursorColor: MyColors.black87,
                      decoration: InputDecoration(
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16, letterSpacing: 0.5),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      inputFormatters: [MyNumberTextInputFormatter(digit:3)],
                      onChanged: (String value) {
                        if (value != null && value != '') {
                          _leftSwapAmount = value;
                          double leftAmount = Decimal.tryParse(_leftSwapAmount).toDouble();
                          _leftSwapValue = (Decimal.tryParse(_leftSwapAmount) * Decimal.fromInt(10).pow(_swapRows[_leftSelectIndex].swapTokenPrecision)).toStringAsFixed(0);

                          if (_flag1 && _flag2 && _swapRows[_rightSelectIndex].swapTokenPrice1 > 0) {
                            double rightAmount = leftAmount * _swapRows[_leftSelectIndex].swapTokenPrice1 /_swapRows[_rightSelectIndex].swapTokenPrice1;
                            _rightSwapAmount = rightAmount.toStringAsFixed(3);
                            _rightSwapValue = (Decimal.tryParse(rightAmount.toString()) * Decimal.fromInt(10).pow(_swapRows[_rightSelectIndex].swapTokenPrecision)).toStringAsFixed(0);

                            print('_leftSwapAmount: $_leftSwapAmount');
                            print('_leftSwapValue 111: $_leftSwapValue');
                            print('_leftSwapValue 222: ${_balanceMap[_swapRows[_leftSelectIndex].swapTokenAddress]}');


                            print('_rightSwapAmount: $_rightSwapAmount');
                            print('_rightSwapValue 111: $_rightSwapValue');
                            print('_rightSwapValue 222: ${_balanceMap[_swapRows[_rightSelectIndex].swapTokenAddress]}');

                          }
                        } else {
                          _leftSwapAmount = '';
                          _leftSwapValue = '';
                        }
                      },
                      onSaved: (String value) {},
                      onEditingComplete: () {},
                    )
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _leftSwapAmount = _leftBalanceAmount;
                      double leftAmount = Decimal.tryParse(_leftSwapAmount).toDouble();

                      if (_flag1 && _flag2) {
                        if (_balanceMap[_swapRows[_leftSelectIndex].swapTokenAddress] != null) {
                          _leftSwapValue = _balanceMap[_swapRows[_leftSelectIndex].swapTokenAddress];
                        }
                        print('_leftSwapAmount: $_leftSwapAmount');
                        print('_leftSwapValue 111: $_leftSwapValue');
                        print('_leftSwapValue 222: ${_balanceMap[_swapRows[_leftSelectIndex].swapTokenAddress]}');

                        if (_swapRows[_rightSelectIndex].swapTokenPrice1 > 0) {
                          double rightAmount = leftAmount * _swapRows[_leftSelectIndex].swapTokenPrice1 /_swapRows[_rightSelectIndex].swapTokenPrice1;
                          _rightSwapAmount = rightAmount.toStringAsFixed(3);
                          _rightSwapValue = (Decimal.tryParse(rightAmount.toString()) * Decimal.fromInt(10).pow(_swapRows[_rightSelectIndex].swapTokenPrecision)).toStringAsFixed(0);
                          print('_rightSwapAmount: $_rightSwapAmount');
                          print('_rightSwapValue 111: $_rightSwapValue');
                          print('_rightSwapValue 222: ${_balanceMap[_swapRows[_rightSelectIndex].swapTokenAddress]}');
                        }
                      }
                    },
                    child: Container(
                      width: 40,
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      alignment: Alignment.center,
                      child: Text(
                          'MAX',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          _flag1 && _flag2 ? Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: ClipOval(
                    child: Image.network(
                      '${_swapRows[_leftSelectIndex].swapPicUrl}',
                      width: 17,
                      height: 17,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    '1  ${_swapRows[_leftSelectIndex].swapTokenName}  ≈  $price  ${_swapRows[_rightSelectIndex].swapTokenName} ',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                Container(
                  child: ClipOval(
                    child: Image.network(
                      '${_swapRows[_rightSelectIndex].swapPicUrl}',
                      width: 17,
                      height: 17,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    '≈  ${_swapRows[_leftSelectIndex].swapTokenPrice2.toStringAsFixed(4)}  USD',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                Container(
                  child: ClipOval(
                    child: Image.asset(
                      'images/usd.png',
                      width: 19,
                      height: 19,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ) : Container(),
          SizedBox(height: 8),
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if (_flag1 && _flag2 && (_swapRows[_leftSelectIndex].swapTokenType == 1 || _swapRows[_rightSelectIndex].swapTokenType == 1)) {
                      _showPoolTokenOneDialLog(context);
                    } else if (_flag1 && _flag2 && (_swapRows[_leftSelectIndex].swapTokenType != 1 &&  _swapRows[_rightSelectIndex].swapTokenType != 1)) {
                      _showPoolTokenTwoDialLog(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[500],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.only(left: 10, top: 6, bottom: 6, right: 10),
                    child: Text(
                      '资金池',
                      style: GoogleFonts.lato(
                        letterSpacing: 0.2,
                        color: MyColors.white,
                        fontSize: 12,
                      ),
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
      color: Colors.white,
      child: InkWell(
          onTap: () {
            int temp = _leftSelectIndex;
            _leftSelectIndex = _rightSelectIndex;
            _rightSelectIndex = temp;
            setState(() {});
          },
          child: Container(
            width: 50,
            height: 50,
            color: MyColors.white,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 30),
            child: Icon(
              Icons.compare_arrows,
              size: 30,
              color: Colors.grey[800],
            ),
          )
      ),
    );
  }

  Widget _dataRightWidget(BuildContext context) {
    String price = '0.000';
    if (_flag1 && _flag2 && _swapRows[_leftSelectIndex].swapTokenPrice1 > 0) {
      price = (_swapRows[_rightSelectIndex].swapTokenPrice1/_swapRows[_leftSelectIndex].swapTokenPrice1).toStringAsFixed(4);
    }
    if (_flag1 && _flag2 && _swapRows[_rightSelectIndex].swapTokenPrecision > 0
        && _balanceMap[_swapRows[_rightSelectIndex].swapTokenAddress] != null) {
      _rightBalanceAmount = (Decimal.tryParse(_balanceMap[_swapRows[_rightSelectIndex].swapTokenAddress])/Decimal.fromInt(10).pow(_swapRows[_rightSelectIndex].swapTokenPrecision)).toStringAsFixed(3);
    }
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
                      color: MyColors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 2),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '余额:  ',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: MyColors.grey700,
                          ),
                        ),
                        TextSpan(
                          text: '$_rightBalanceAmount',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: MyColors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(width: 1.0, color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _showSwapTokenDialLog(context, 2);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 15),
                          Container(
                            child: ClipOval(
                              child: _flag2 ? Image.network(
                                '${_swapRows[_rightSelectIndex].swapPicUrl}',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ) : Container(
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 45,
                            child: Text(
                              _flag2 ? '${_swapRows[_rightSelectIndex].swapTokenName}' : '',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: MyColors.grey700,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            child: Icon(Icons.arrow_drop_down, size: 26, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    width: 185,
                    padding: EdgeInsets.only(left: 15, top: 2, bottom: 2),
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      controller: _rightSwapAmountController,
                      enableInteractiveSelection: false,
                      cursorColor: MyColors.black87,
                      decoration: InputDecoration(
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16, letterSpacing: 0.5),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      inputFormatters: [MyNumberTextInputFormatter(digit:3)],
                      onChanged: (String value) {
                        if (value != null && value != '') {
                          _rightSwapAmount = value;
                          _rightSwapValue = value;
                        } else {
                          _rightSwapAmount = '';
                          _rightSwapValue = '';
                        }
                        setState(() {});
                      },
                      onSaved: (String value) {},
                      onEditingComplete: () {},
                    )
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_flag1 && _flag2) {
                          _rightSwapAmount = _rightBalanceAmount;
                          if (_balanceMap[_swapRows[_rightSelectIndex].swapTokenAddress] != null) {
                            _rightSwapValue = _balanceMap[_swapRows[_rightSelectIndex].swapTokenAddress];
                          }
                          print('_rightSwapAmount: $_rightSwapAmount');
                          print('_rightSwapValue: $_rightSwapValue');
                      }
                    },
                    child: Container(
                      width: 40,
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      alignment: Alignment.center,
                      child: Text(
                          'MAX',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          _flag1 && _flag2 ? Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: ClipOval(
                    child: Image.network(
                      '${_swapRows[_rightSelectIndex].swapPicUrl}',
                      width: 17,
                      height: 17,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    '1  ${_swapRows[_rightSelectIndex].swapTokenName}  ≈  $price  ${_swapRows[_leftSelectIndex].swapTokenName} ',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                Container(
                  child: ClipOval(
                    child: Image.network(
                      '${_swapRows[_leftSelectIndex].swapPicUrl}',
                      width: 17,
                      height: 17,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    '≈  ${_swapRows[_rightSelectIndex].swapTokenPrice2.toStringAsFixed(4)}  USD',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                Container(
                  child: ClipOval(
                    child: Image.asset(
                      'images/usd.png',
                      width: 19,
                      height: 19,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ) : Container(),
          SizedBox(height: 8),
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.only(left: 10, top: 6, bottom: 6, right: 10),
                    child: Text(
                      '资金池',
                      style: GoogleFonts.lato(
                        letterSpacing: 0.2,
                        color: MyColors.white,
                        fontSize: 12,
                      ),
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
          padding: EdgeInsets.only(left: 70, top: 15, right: 70, bottom: 15),
          backgroundColor:  MyColors.blue500,
          label: Container(
            child: Text(
              '兑换',
              style: GoogleFonts.lato(
                letterSpacing: 0.7,
                color: Colors.white,
                fontSize: 17,
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
            _showConnectWalletDialLog(context);
          } else if (index == 5) {
            Provider.of<IndexProvider>(context, listen: false).changeLangType();
          }
        },
      ),
    );
  }

  _showConnectWalletDialLog(BuildContext context) {
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

  _showSwapTokenDialLog(BuildContext context, int type) {
    showDialog(
      context: context,
      child: AlertDialog(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        content: Container(
          width: 450,
          height: 400,
          padding: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            children: <Widget>[
              _selectSwapTitleWidget(context),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _swapRows.length,
                    itemBuilder: (context, index) {
                      return _selectSwapTokenWidget(context, index, _swapRows[index], type);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectSwapTitleWidget(BuildContext context) {
    return Container(
      width: 450,
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Container(
              width: 140,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'Token 名称',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          Container(
              width: 160,
              alignment: Alignment.center,
              child: Text(
                '价格 (USD)',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          Expanded(
            child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  '余额',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
          ),
        ],
      ),
    );
  }

  Widget _selectSwapTokenWidget(BuildContext context, int index, SwapRow item, int type) {
    String balanceAmount = '0.000';
    if (item.swapTokenPrecision > 0 && _balanceMap[item.swapTokenAddress] != null) {
      balanceAmount = (Decimal.tryParse(_balanceMap[item.swapTokenAddress])/Decimal.fromInt(10).pow(item.swapTokenPrecision)).toStringAsFixed(3);
    }
    bool flag = false;
    if (type == 1) {
      flag = index == _leftSelectIndex ? true : false;
    } else if (type == 2) {
      flag = index == _rightSelectIndex ? true : false;
    }

    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      onTap: () {
        if (type == 1 && index != _rightSelectIndex) {
          _leftSelectIndex = index;
          setState(() {});
          Navigator.pop(context);
        } else if (type == 2 && index != _leftSelectIndex) {
          _rightSelectIndex = index;
          setState(() {});
          Navigator.pop(context);
        }

      },
      child: Container(
        width: 450,
        padding: EdgeInsets.only(top: 12, right: 15, bottom: 12),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: flag ? Colors.grey[100] : null,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 140,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  Container(
                    child: ClipOval(
                      child: Image.network(
                        '${item.swapPicUrl}',
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: type == 1 ? Text(
                      '${item.swapTokenName}',
                      style: TextStyle(
                        color: index != _rightSelectIndex  ? Colors.black87 :Colors.black26,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ) : Text(
                      '${item.swapTokenName}',
                      style: TextStyle(
                        color: index != _leftSelectIndex  ? Colors.black87 :Colors.black26,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 160,
              alignment: Alignment.center,
              child: type == 1 ? Text(
              '${item.swapTokenPrice2.toStringAsFixed(4)}',
              style: TextStyle(
                color: index != _rightSelectIndex  ? Colors.black87 :Colors.black26,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ) : Text(
                '${item.swapTokenPrice2.toStringAsFixed(4)}',
                style: TextStyle(
                  color: index != _leftSelectIndex  ? Colors.black87 :Colors.black26,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: type == 1 ? Text(
                  '$balanceAmount',
                  style: TextStyle(
                    color: index != _rightSelectIndex  ? Colors.black87 :Colors.black26,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ) : Text(
                  '$balanceAmount',
                  style: TextStyle(
                    color: index != _leftSelectIndex  ? Colors.black87 :Colors.black26,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  _showPoolTokenOneDialLog(BuildContext context) {
    showDialog(
      context: context,
      child: AlertDialog(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        content: Container(
          width: 450,
          height: 230,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children:<Widget> [
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        '${_swapRows[_leftSelectIndex].swapTokenName}-${_swapRows[_rightSelectIndex].swapTokenName}',
                        style: GoogleFonts.lato(
                          letterSpacing: 0.2,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 2),
                      child: Text(
                        '资金池',
                        style: GoogleFonts.lato(
                          letterSpacing: 0.2,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0),
              Container(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '总流动性',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          letterSpacing: 0.2,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: ClipOval(
                              child: Image.asset(
                                'images/usd.png',
                                width: 22.5,
                                height: 22.5,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 6),
                            child: Text(
                              _swapRows[_leftSelectIndex].swapTokenType == 2 ? '${TextUtil.formatComma3(_swapRows[_leftSelectIndex].totalLiquidity.toStringAsFixed(0))}'
                                  : '${TextUtil.formatComma3(_swapRows[_rightSelectIndex].totalLiquidity.toStringAsFixed(0))}',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: MyColors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          Container(
                            child: Text(
                              '  USD',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: MyColors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '代币',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          letterSpacing: 0.2,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: ClipOval(
                              child: Image.network(
                                '${_swapRows[_leftSelectIndex].swapPicUrl}',
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 6),
                            child: Text(
                              _swapRows[_leftSelectIndex].swapTokenType == 2 ? '${TextUtil.formatComma3(_swapRows[_leftSelectIndex].swapTokenAmount.toStringAsFixed(0))}'
                                  : '${TextUtil.formatComma3(_swapRows[_rightSelectIndex].baseTokenAmount.toStringAsFixed(0))}',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: MyColors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          Container(
                            child: Text(
                              '  ${_swapRows[_leftSelectIndex].swapTokenName}',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: MyColors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: ClipOval(
                              child: Image.network(
                                '${_swapRows[_rightSelectIndex].swapPicUrl}',
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 6),
                            child: Text(
                              _swapRows[_leftSelectIndex].swapTokenType == 2 ? '${TextUtil.formatComma3(_swapRows[_leftSelectIndex].baseTokenAmount.toStringAsFixed(0))}'
                                  : '${TextUtil.formatComma3(_swapRows[_rightSelectIndex].swapTokenAmount.toStringAsFixed(0))}',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: MyColors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          Container(
                            child: Text(
                              '  ${_swapRows[_rightSelectIndex].swapTokenName}',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: MyColors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showPoolTokenTwoDialLog(BuildContext context) {
    showDialog(
      context: context,
      child: AlertDialog(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        content: Container(
          width: 450,
          height: 420,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children:<Widget> [
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              '${_swapRows[_leftSelectIndex].swapTokenName}-${_swapRows[_leftSelectIndex].baseTokenName}',
                              style: GoogleFonts.lato(
                                letterSpacing: 0.2,
                                fontSize: 16,
                                color: MyColors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 2),
                            child: Text(
                              '资金池',
                              style: GoogleFonts.lato(
                                letterSpacing: 0.2,
                                fontSize: 16,
                                color: MyColors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 0),
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '总流动性',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                letterSpacing: 0.2,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/usd.png',
                                      width: 22.5,
                                      height: 22.5,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text(
                                    '${TextUtil.formatComma3(_swapRows[_leftSelectIndex].totalLiquidity.toStringAsFixed(0))}',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: MyColors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '  USD',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: MyColors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '代币',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                letterSpacing: 0.2,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipOval(
                                    child: Image.network(
                                      '${_swapRows[_leftSelectIndex].swapPicUrl}',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text(
                                    '${TextUtil.formatComma3(_swapRows[_leftSelectIndex].swapTokenAmount.toStringAsFixed(0))}',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: MyColors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '  ${_swapRows[_leftSelectIndex].swapTokenName}',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: MyColors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipOval(
                                    child: Image.network(
                                      '${_swapRows[_leftSelectIndex].basePicUrl}',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text(
                                    '${TextUtil.formatComma3(_swapRows[_leftSelectIndex].baseTokenAmount.toStringAsFixed(0))}',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: MyColors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '  ${_swapRows[_leftSelectIndex].baseTokenName}',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: MyColors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              '${_swapRows[_rightSelectIndex].baseTokenName}-${_swapRows[_rightSelectIndex].swapTokenName}',
                              style: GoogleFonts.lato(
                                letterSpacing: 0.2,
                                fontSize: 16,
                                color: MyColors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 2),
                            child: Text(
                              '资金池',
                              style: GoogleFonts.lato(
                                letterSpacing: 0.2,
                                fontSize: 16,
                                color: MyColors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 0),
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '总流动性',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                letterSpacing: 0.2,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/usd.png',
                                      width: 22.5,
                                      height: 22.5,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text(
                                    '${TextUtil.formatComma3(_swapRows[_rightSelectIndex].totalLiquidity.toStringAsFixed(0))}',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: MyColors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '  USD',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: MyColors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '代币',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                letterSpacing: 0.2,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipOval(
                                    child: Image.network(
                                      '${_swapRows[_rightSelectIndex].basePicUrl}',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text(
                                    '${TextUtil.formatComma3(_swapRows[_rightSelectIndex].baseTokenAmount.toStringAsFixed(0))}',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: MyColors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '  ${_swapRows[_rightSelectIndex].baseTokenName}',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: MyColors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipOval(
                                    child: Image.network(
                                      '${_swapRows[_rightSelectIndex].swapPicUrl}',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text(
                                    '${TextUtil.formatComma3(_swapRows[_rightSelectIndex].swapTokenAmount.toStringAsFixed(0))}',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: MyColors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '  ${_swapRows[_rightSelectIndex].swapTokenName}',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: MyColors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _reloadAccountFlag = false;

  _reloadAccount() async {
    _getAccount();
    _timer2 = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      if (_reloadAccountFlag) {
        _getAccount();
      }
    });
  }

  _getAccount() async {
    _reloadAccountFlag = false;
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
    _reloadAccountFlag = true;
  }

  SwapData _swapData;

  List<SwapRow> _swapRows = [];

  bool _reloadSwapDataFlag = false;

  var _balanceMap = Map<String, String>();

  _reloadSwapData() async {
    _getSwapData();
    _timer1 = Timer.periodic(Duration(milliseconds: 2000), (timer) async {
      if (_reloadSwapDataFlag) {
        _getSwapData();
      }
    });
  }

  void _getSwapData() async {
    _reloadSwapDataFlag = false;
    try {
      String url = servicePath['swapQuery'];
      await requestGet(url).then((value) {
        var respData = Map<String, dynamic>.from(value);
        SwapRespModel respModel = SwapRespModel.fromJson(respData);
        if (respModel != null && respModel.code == 0) {
          _swapData = respModel.data;
          if (_swapData != null && _swapData.rows != null && _swapData.rows.length > 0) {
            _swapRows = _swapData.rows;
          }
        }
      });
      _flag1 = _swapRows.length > 0 ? true : false;
      _flag2 = _swapRows.length > 1 ? true : false;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
    _reloadSwapDataFlag = true;
  }

  bool _reloadTokenBalanceFlag = false;

  _reloadTokenBalance() async {
    js.context['setBalance']=setBalance;
    _getTokenBalance();
    _timer3 = Timer.periodic(Duration(milliseconds: 2000), (timer) async {
      if (_reloadTokenBalanceFlag) {
        _getTokenBalance();
      }
    });
  }

  _getTokenBalance() async {
    _reloadTokenBalanceFlag = false;
    String account = Provider.of<IndexProvider>(context, listen: false).account;
    if (account != '') {
      for (int i=0; i<_swapRows.length; i++) {
        js.context.callMethod('getTokenBalance', [i.toString(), _swapRows[i].swapTokenType, _swapRows[i].swapTokenAddress, account]);
      }
    }
    _reloadTokenBalanceFlag = true;
  }

  void setBalance(index, tokenAddress, balance) {
    //print('setBalance index: ${index.toString()}, tokenAddress: ${tokenAddress.toString()}, balance: ${balance.toString()}');
    if (_swapRows.length > index) {
      _balanceMap['${tokenAddress.toString()}'] = balance.toString();
      setState(() {});
    }
  }

}
