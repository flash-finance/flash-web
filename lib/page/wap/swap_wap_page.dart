import 'dart:async';

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
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'dart:js' as js;

import 'package:provider/provider.dart';

class SwapWapPage extends StatefulWidget {
  @override
  _SwapWapPageState createState() => _SwapWapPageState();
}

class _SwapWapPageState extends State<SwapWapPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String _account = '';
  String _leftKey = '';
  String _rightKey = '';
  bool _tronFlag = false;
  Timer _timer1;
  Timer _timer2;
  Timer _timer3;

  bool _flag1 = false;
  bool _flag2 = false;

  int _leftSelectIndex = 0;
  int _rightSelectIndex = 1;

  String _leftPrice = '0.0';
  String _rightPrice = '0.0';
  String _leftBalanceAmount = '0.0';
  String _rightBalanceAmount = '0.0';

  String _leftSwapAmount = '';
  String _rightSwapAmount = '';

  String _leftSwapValue = '0';
  String _rightSwapValue = '0';

  TextEditingController _leftSwapAmountController;
  TextEditingController _rightSwapAmountController;

  bool _swapFlag = true;

  bool _loadFlag = false;


  @override
  void initState() {
    super.initState();
    CommonProvider.changeHomeIndex(0);
    Provider.of<IndexProvider>(context, listen: false).init();
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
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);
    bool langType = Provider.of<IndexProvider>(context, listen: true).langType;

    _leftSwapAmountController =  TextEditingController.fromValue(TextEditingValue(text: _leftSwapAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _leftSwapAmount.length))));
    _rightSwapAmountController =  TextEditingController.fromValue(TextEditingValue(text: _rightSwapAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _rightSwapAmount.length))));

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.white,
      appBar: _appBarWidget(context),
      drawer: _drawerWidget(context),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _mainWidget(context),
        ],
      ),
    );
  }

  Widget _mainWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      width: ScreenUtil().setWidth(750),
      color: MyColors.white,
      child: Column(
        children: <Widget>[
          _topWidget(context),
          SizedBox(height: ScreenUtil().setHeight(30)),
          Expanded(
            child: _bodyWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      child: ListView(
        children: <Widget>[
          _bizWidget(context),
        ],
      ),
    );
  }

  Widget _topWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25), right: ScreenUtil().setWidth(25)),
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
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(30), bottom: ScreenUtil().setHeight(30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Flash  Swap',
                      style: Util.textStyle4WapEn(context, 1, Colors.white, spacing: 0.0, size: 40),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                    child: Text(
                      '${S.of(context).swapTips01}',
                      style: Util.textStyle4Wap(context, 2, Colors.white, spacing: 0.0, size: 22),
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
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25), right: ScreenUtil().setWidth(25)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(0), top: ScreenUtil().setHeight(20), right: ScreenUtil().setWidth(0), bottom: ScreenUtil().setHeight(20)),
        child: Column(
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(60)),
            _dataWidget(context),
            SizedBox(height: ScreenUtil().setHeight(10)),
            _poolWidget(context),
            SizedBox(height: ScreenUtil().setHeight(60)),
            _swapWidget(context),
            SizedBox(height: ScreenUtil().setHeight(60)),
          ],
        ),
      ),
    );
  }

  Widget _dataWidget(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            _dataLeftWidget(context),
            SizedBox(height: ScreenUtil().setHeight(0)),
            _dataMidWidget(context),
            SizedBox(height: ScreenUtil().setHeight(0)),
            _dataRightWidget(context),
          ],
        )
    );
  }

  Widget _dataLeftWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right: ScreenUtil().setWidth(30)),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
                  child: Text(
                    '${S.of(context).swapSend}',
                    style: Util.textStyle4Wap(context, 2, Colors.grey[800], spacing: 0.0, size: 28),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(2)),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${S.of(context).swapBalance}:  ',
                          style: Util.textStyle4Wap(context, 2, Colors.grey[700], spacing: 0.0, size: 28),
                        ),
                        TextSpan(
                          text: '${Util.formatNum(double.parse(_leftBalanceAmount), 4)}',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: ScreenUtil().setSp(28),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(width: 0.5, color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _showSwapTokenDialLog(context, 1);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(5)),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: ScreenUtil().setWidth(15)),
                          Container(
                            child: ClipOval(
                              child: _flag1 ? Image.network(
                                '${_swapRows[_leftSelectIndex].swapPicUrl}',
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                fit: BoxFit.cover,
                              ) : Container(
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                              ),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(10)),
                          Container(
                            width: ScreenUtil().setWidth(80),
                            alignment: Alignment.center,
                            child: Text(
                              _flag1 ? '${_swapRows[_leftSelectIndex].swapTokenName}' : '',
                              style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.0, size: 28),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(5)),
                          Container(
                            child: Icon(Icons.arrow_drop_down, size: ScreenUtil().setSp(35), color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    width: ScreenUtil().setWidth(360),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(3), bottom: ScreenUtil().setHeight(3)),
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      controller: _leftSwapAmountController,
                      enableInteractiveSelection: false,
                      cursorColor: MyColors.black87,
                      decoration: InputDecoration(
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: ScreenUtil().setSp(28), letterSpacing: 0.5),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.grey[850],
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [MyNumberTextInputFormatter(digit:6)],
                      onChanged: (String value) {
                        if (value != null && value != '' && double.parse(value) >= 0) {
                          _leftSwapAmount = value;
                          double leftAmount = Decimal.tryParse(_leftSwapAmount).toDouble();
                          _leftSwapValue = (Decimal.tryParse(_leftSwapAmount) * Decimal.fromInt(10).pow(_swapRows[_leftSelectIndex].swapTokenPrecision)).toStringAsFixed(0);

                          if (_flag1 && _flag2 && _swapRows[_rightSelectIndex].swapTokenPrice1 > 0) {
                            double rightAmount = leftAmount * _swapRows[_leftSelectIndex].swapTokenPrice1 /_swapRows[_rightSelectIndex].swapTokenPrice1;
                            _rightSwapAmount = Util.formatNum(rightAmount, 6);
                            _rightSwapValue = (Decimal.tryParse(rightAmount.toString()) * Decimal.fromInt(10).pow(_swapRows[_rightSelectIndex].swapTokenPrecision)).toStringAsFixed(0);

                            if (leftAmount > double.parse(_leftBalanceAmount)) {
                              _swapFlag = false;
                            } else {
                              _swapFlag = true;
                            }
                            setState(() {});
                          }
                        } else {
                          _leftSwapAmount = '';
                          _leftSwapValue = '';
                          _rightSwapAmount = '';
                          _rightSwapValue = '';
                          _swapFlag = true;
                          setState(() {});
                        }
                      },
                      onSaved: (String value) {},
                      onEditingComplete: () {},
                    )
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _leftSwapAmount = Util.formatNum(double.parse(_leftBalanceAmount), 6);
                      double leftAmount = Decimal.tryParse(_leftBalanceAmount).toDouble();

                      if (_flag1 && _flag2) {
                        if (_balanceMap[_leftKey] != null) {
                          _leftSwapValue = _balanceMap[_leftKey];
                        }

                        if (_swapRows[_rightSelectIndex].swapTokenPrice1 > 0) {
                          double rightAmount = leftAmount * _swapRows[_leftSelectIndex].swapTokenPrice1 /_swapRows[_rightSelectIndex].swapTokenPrice1;
                          _rightSwapAmount = Util.formatNum(rightAmount, 6);
                          _rightSwapValue = (Decimal.tryParse(rightAmount.toString()) * Decimal.fromInt(10).pow(_swapRows[_rightSelectIndex].swapTokenPrecision)).toStringAsFixed(0);

                          if (leftAmount > double.parse(_leftBalanceAmount)) {
                            _swapFlag = false;
                          } else {
                            _swapFlag = true;
                          }
                          setState(() {});
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(3), bottom: ScreenUtil().setHeight(3)),
                      alignment: Alignment.center,
                      child: Text(
                        'MAX',
                        style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.0, size: 27),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          _flag1 && _flag2 ? Container(
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(5)),
                  child: Text(
                    '1  ${_swapRows[_leftSelectIndex].swapTokenName} ≈ ${Util.formatNum(double.parse(_leftPrice), 4)}  ${_swapRows[_rightSelectIndex].swapTokenName}',
                    style: Util.textStyle4WapEn(context, 2, Colors.grey[700], spacing: 0.0, size: 23),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(5)),
                  child: Text(
                    ' ≈ ${Util.formatNum(_swapRows[_leftSelectIndex].swapTokenPrice2, 4)}  USD',
                    style: Util.textStyle4WapEn(context, 2, Colors.grey[700], spacing: 0.0, size: 23),
                  ),
                ),
              ],
            ),
          ) : Container(),
        ],
      ),
    );
  }

  Widget _dataMidWidget(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20), bottom: ScreenUtil().setHeight(0)),
      child: InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            int temp1 = _leftSelectIndex;
            _leftSelectIndex = _rightSelectIndex;
            _rightSelectIndex = temp1;

            String temp2 = _leftSwapAmount;
            _leftSwapAmount = _rightSwapAmount;
            _rightSwapAmount = temp2;
            String temp3 = _leftSwapValue;
            _leftSwapValue = _rightSwapValue;
            _rightSwapValue = temp3;

            String temp4 = _leftBalanceAmount;
            _leftBalanceAmount = _rightBalanceAmount;
            _rightBalanceAmount = temp4;

            String temp5 = _leftPrice;
            _leftPrice = _rightPrice;
            _rightPrice = temp5;

            if (_leftSwapAmount != '' && _leftBalanceAmount != '') {
              double value1 = double.parse(_leftSwapAmount);
              double value2 = double.parse(_leftBalanceAmount);
              if (value1 > value2) {
                _swapFlag = false;
              } else {
                _swapFlag = true;
              }
            }

            setState(() {});
          },
          child: Container(
            color: MyColors.white,
            alignment: Alignment.center,
            child: Icon(
              Icons.swap_horiz,
              size: ScreenUtil().setSp(45),
              color: Colors.grey[700],
            ),
          )
      ),
    );
  }

  Widget _dataRightWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right: ScreenUtil().setWidth(30)),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
                  child: Text(
                    '${S.of(context).swapReceive}',
                    style: Util.textStyle4Wap(context, 2, Colors.grey[800], spacing: 0.0, size: 28),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(2)),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${S.of(context).swapBalance}:  ',
                          style: Util.textStyle4Wap(context, 2, Colors.grey[700], spacing: 0.0, size: 28),
                        ),
                        TextSpan(
                          text: '${Util.formatNum(double.parse(_rightBalanceAmount), 4)}',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: ScreenUtil().setSp(28),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(width: 0.5, color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _showSwapTokenDialLog(context, 2);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(5)),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: ScreenUtil().setWidth(15)),
                          Container(
                            child: ClipOval(
                              child: _flag2 ? Image.network(
                                '${_swapRows[_rightSelectIndex].swapPicUrl}',
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                fit: BoxFit.cover,
                              ) : Container(
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                              ),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(10)),
                          Container(
                            width: ScreenUtil().setWidth(80),
                            alignment: Alignment.center,
                            child: Text(
                              _flag2 ? '${_swapRows[_rightSelectIndex].swapTokenName}' : '',
                              style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.0, size: 28),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(5)),
                          Container(
                            child: Icon(Icons.arrow_drop_down, size: ScreenUtil().setSp(35), color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    width: ScreenUtil().setWidth(360),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(3), bottom: ScreenUtil().setHeight(3)),
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      controller: _rightSwapAmountController,
                      enableInteractiveSelection: false,
                      cursorColor: MyColors.black87,
                      decoration: InputDecoration(
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: ScreenUtil().setSp(30), letterSpacing: 0.5), border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.grey[850],
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [MyNumberTextInputFormatter(digit:6)],
                      onChanged: (String value) {
                        if (value != null && value != '' && double.parse(value) >= 0) {
                          _rightSwapAmount = value;
                          double rightAmount = Decimal.tryParse(_rightSwapAmount).toDouble();
                          _rightSwapValue = (Decimal.tryParse(_rightSwapAmount) * Decimal.fromInt(10).pow(_swapRows[_rightSelectIndex].swapTokenPrecision)).toStringAsFixed(0);

                          if (_flag1 && _flag2 && _swapRows[_leftSelectIndex].swapTokenPrice1 > 0) {
                            double leftAmount = rightAmount * _swapRows[_rightSelectIndex].swapTokenPrice1 /_swapRows[_leftSelectIndex].swapTokenPrice1;
                            _leftSwapAmount = Util.formatNum(leftAmount, 6);
                            _leftSwapValue = (Decimal.tryParse(leftAmount.toString()) * Decimal.fromInt(10).pow(_swapRows[_leftSelectIndex].swapTokenPrecision)).toStringAsFixed(0);

                            if (_balanceMap[_leftKey] != null && double.parse(_leftSwapValue) > double.parse(_balanceMap[_leftKey])) {
                              _swapFlag = false;
                            } else {
                              _swapFlag = true;
                            }
                            setState(() {});
                          }
                        } else {
                          _rightSwapAmount = '';
                          _rightSwapValue = '';
                          _leftSwapAmount = '';
                          _leftSwapValue = '';
                          _swapFlag = true;
                          setState(() {});
                        }
                      },
                      onSaved: (String value) {},
                      onEditingComplete: () {},
                    )
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_flag1 && _flag2) {
                        _rightSwapAmount = Util.formatNum(double.parse(_rightBalanceAmount), 6);
                        double rightAmount = Decimal.tryParse(_rightBalanceAmount).toDouble();

                        if (_flag1 && _flag2) {
                          if (_balanceMap[_rightKey] != null) {
                            _rightSwapValue = _balanceMap[_rightKey];
                          }

                          if (_swapRows[_leftSelectIndex].swapTokenPrice1 > 0) {
                            double leftAmount = rightAmount * _swapRows[_rightSelectIndex].swapTokenPrice1 /_swapRows[_leftSelectIndex].swapTokenPrice1;
                            _leftSwapAmount = Util.formatNum(leftAmount, 4);
                            _leftSwapValue = (Decimal.tryParse(leftAmount.toString()) * Decimal.fromInt(10).pow(_swapRows[_leftSelectIndex].swapTokenPrecision)).toStringAsFixed(0);

                            if (_balanceMap[_leftKey] != null && double.parse(_leftSwapValue) > double.parse(_balanceMap[_leftKey])) {
                              _swapFlag = false;
                            } else {
                              _swapFlag = true;
                            }
                            setState(() {});
                          }
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(3), bottom: ScreenUtil().setHeight(3)),
                      alignment: Alignment.center,
                      child: Text(
                          'MAX',
                        style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.0, size: 27),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          _flag1 && _flag2 ? Container(
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(5)),
                  child: Text(
                    '1  ${_swapRows[_rightSelectIndex].swapTokenName} ≈ ${Util.formatNum(double.parse(_rightPrice), 4)}  ${_swapRows[_leftSelectIndex].swapTokenName}',
                    style: Util.textStyle4WapEn(context, 2, Colors.grey[700], spacing: 0.0, size: 23),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(5)),
                  child: Text(
                    ' ≈ ${Util.formatNum(_swapRows[_rightSelectIndex].swapTokenPrice2, 4)}  USD',
                    style: Util.textStyle4WapEn(context, 2, Colors.grey[700], spacing: 0.0, size: 23),
                  ),
                ),
              ],
            ),
          ) : Container(),
        ],
      ),
    );
  }

  Widget _poolWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right: ScreenUtil().setWidth(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
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
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue[500],
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(18), top: ScreenUtil().setHeight(12), bottom: ScreenUtil().setHeight(12), right: ScreenUtil().setWidth(18)),
              child: Text(
                '${S.of(context).swapPooledTokens}',
                style: Util.textStyle4Wap(context, 2, Colors.white, spacing: 0.0, size: 23),
              ),
            ),
          ),
        ],
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
          width: ScreenUtil().setWidth(600),
          height: ScreenUtil().setHeight(650),
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
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
      width: ScreenUtil().setWidth(600),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              width: ScreenUtil().setWidth(300),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
              child: Text(
                '${S.of(context).swapTokenName}',
                style: Util.textStyle4Wap(context, 2, Colors.grey[700], spacing: 0.0, size: 26),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(8)),
              child: Text(
                '${S.of(context).swapTokenPrice}',
                style: Util.textStyle4Wap(context, 2, Colors.grey[700], spacing: 0.0, size: 26),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
  }

  Widget _selectSwapTokenWidget(BuildContext context, int index, SwapRow item, int type) {
    bool flag = false;
    if (type == 1) {
      flag = index == _leftSelectIndex ? true : false;
    } else if (type == 2) {
      flag = index == _rightSelectIndex ? true : false;
    }

    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      onTap: () {
        if (type == 1 && index != _rightSelectIndex) {
          _leftSelectIndex = index;
          _leftSwapAmount = '';
          _leftSwapValue = '';
          _rightSwapAmount = '';
          _rightSwapValue = '';
          _reloadSub();
          setState(() {});
          Navigator.pop(context);
        } else if (type == 2 && index != _leftSelectIndex) {
          _rightSelectIndex = index;
          _leftSwapAmount = '';
          _leftSwapValue = '';
          _rightSwapAmount = '';
          _rightSwapValue = '';
          _reloadSub();
          setState(() {});
          Navigator.pop(context);
        }

      },
      child: Container(
        width: ScreenUtil().setWidth(600),
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(18), bottom: ScreenUtil().setHeight(18)),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: flag ? Colors.grey[100] : null,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(300),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              child: Row(
                children: <Widget>[
                  Container(
                    child: ClipOval(
                      child: Image.network(
                        '${item.swapPicUrl}',
                        width: ScreenUtil().setWidth(35),
                        height: ScreenUtil().setWidth(35),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    alignment: Alignment.centerLeft,
                    child: type == 1 ? Text(
                      '${item.swapTokenName}',
                      style: Util.textStyle4WapEn(context, 2, index != _rightSelectIndex  ? Colors.grey[800] :Colors.grey[500], spacing: 0.0, size: 26),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ) : Text(
                      '${item.swapTokenName}',
                      style: Util.textStyle4WapEn(context, 2, index != _leftSelectIndex  ? Colors.grey[800] :Colors.grey[500], spacing: 0.0, size: 26),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                child: type == 1 ? Text(
                  '${Util.formatNum(item.swapTokenPrice2, 6)}',
                  style: TextStyle(
                    color: index != _rightSelectIndex  ? Colors.grey[800] :Colors.grey[500],
                    fontSize: ScreenUtil().setSp(26),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ) : Text(
                  '${Util.formatNum(item.swapTokenPrice2, 6)}',
                  style: TextStyle(
                    color: index != _leftSelectIndex  ? Colors.grey[800] :Colors.grey[500],
                    fontSize: ScreenUtil().setSp(26),
                    fontWeight: FontWeight.w500,
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
          width: ScreenUtil().setWidth(600),
          height: ScreenUtil().setHeight(380),
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
          child: ListView(
            children:<Widget> [
              Container(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(10), bottom: ScreenUtil().setHeight(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${_swapRows[_leftSelectIndex].swapTokenName}/${_swapRows[_rightSelectIndex].swapTokenName}',
                        style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.0, size: 30),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0),
              Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(20), bottom:  ScreenUtil().setHeight(20), right: ScreenUtil().setWidth(20)),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${S.of(context).swapTotalLiquidity}',
                        style: Util.textStyle4Wap(context, 2, Colors.grey[700], spacing: 0.2, size: 26),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(15)),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: ClipOval(
                              child: Image.asset(
                                'images/usd.png',
                                width: ScreenUtil().setWidth(38),
                                height: ScreenUtil().setWidth(38),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                            child: Text(
                              _swapRows[_leftSelectIndex].swapTokenType == 2 ? '${_swapRows[_leftSelectIndex].totalLiquidity.toStringAsFixed(0)}'
                                  : '${_swapRows[_rightSelectIndex].totalLiquidity.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: ScreenUtil().setSp(26),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          Container(
                            child: Text(
                              '  USD',
                              style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.2, size: 26),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40)),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${S.of(context).swapToken}',
                        style: Util.textStyle4WapEn(context, 2, Colors.grey[700], spacing: 0.2, size: 26),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(15)),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: ClipOval(
                              child: Image.network(
                                '${_swapRows[_leftSelectIndex].swapPicUrl}',
                                width: ScreenUtil().setWidth(35),
                                height: ScreenUtil().setWidth(35),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                            child: Text(
                              _swapRows[_leftSelectIndex].swapTokenType == 2 ? '${_swapRows[_leftSelectIndex].swapTokenAmount.toStringAsFixed(0)}'
                                  : '${_swapRows[_rightSelectIndex].baseTokenAmount.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: ScreenUtil().setSp(26),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          Container(
                            child: Text(
                              '  ${_swapRows[_leftSelectIndex].swapTokenName}',
                              style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.0, size: 26),

                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(15)),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: ClipOval(
                              child: Image.network(
                                '${_swapRows[_rightSelectIndex].swapPicUrl}',
                                width: ScreenUtil().setWidth(35),
                                height: ScreenUtil().setWidth(35),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                            child: Text(
                              _swapRows[_leftSelectIndex].swapTokenType == 2 ? '${_swapRows[_leftSelectIndex].baseTokenAmount.toStringAsFixed(0)}'
                                  : '${_swapRows[_rightSelectIndex].swapTokenAmount.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: ScreenUtil().setSp(26),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          Container(
                            child: Text(
                              '  ${_swapRows[_rightSelectIndex].swapTokenName}',
                              style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.2, size: 26),
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
          width: ScreenUtil().setWidth(600),
          height: ScreenUtil().setHeight(700),
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
          child: ListView(
            children:<Widget> [
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10), bottom: ScreenUtil().setHeight(0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              '${_swapRows[_leftSelectIndex].swapTokenName}/${_swapRows[_leftSelectIndex].baseTokenName}',
                              style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.0, size: 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 0),
                    Container(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(20), bottom:  ScreenUtil().setHeight(20), right: ScreenUtil().setWidth(20)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${S.of(context).swapTotalLiquidity}',
                              style: Util.textStyle4Wap(context, 2, Colors.grey[700], spacing: 0.2, size: 26),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(15)),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/usd.png',
                                      width: ScreenUtil().setWidth(38),
                                      height: ScreenUtil().setWidth(38),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                                  child: Text(
                                    '${_swapRows[_leftSelectIndex].totalLiquidity.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: ScreenUtil().setSp(26),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '  USD',
                                    style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.0, size: 26),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${S.of(context).swapToken}',
                              style: Util.textStyle4WapEn(context, 2, Colors.grey[700], spacing: 0.0, size: 26),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(15)),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipOval(
                                    child: Image.network(
                                      '${_swapRows[_leftSelectIndex].swapPicUrl}',
                                      width: ScreenUtil().setWidth(35),
                                      height: ScreenUtil().setWidth(35),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                                  child: Text(
                                    '${_swapRows[_leftSelectIndex].swapTokenAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: ScreenUtil().setSp(26),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '  ${_swapRows[_leftSelectIndex].swapTokenName}',
                                    style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.0, size: 26),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(15)),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipOval(
                                    child: Image.network(
                                      '${_swapRows[_leftSelectIndex].basePicUrl}',
                                      width: ScreenUtil().setWidth(35),
                                      height: ScreenUtil().setWidth(35),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                                  child: Text(
                                    '${_swapRows[_leftSelectIndex].baseTokenAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: ScreenUtil().setSp(26),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '  ${_swapRows[_leftSelectIndex].baseTokenName}',
                                    style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.0, size: 30),
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
              SizedBox(height: ScreenUtil().setHeight(20)),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10), bottom: ScreenUtil().setHeight(0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              '${_swapRows[_rightSelectIndex].baseTokenName}/${_swapRows[_rightSelectIndex].swapTokenName}',
                              style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.0, size: 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 0),
                    Container(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(20), bottom:  ScreenUtil().setHeight(20), right: ScreenUtil().setWidth(20)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${S.of(context).swapTotalLiquidity}',
                              style: Util.textStyle4Wap(context, 2, Colors.grey[700], spacing: 0.0, size: 26),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(15)),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/usd.png',
                                      width: ScreenUtil().setWidth(38),
                                      height: ScreenUtil().setWidth(38),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                                  child: Text(
                                    '${_swapRows[_rightSelectIndex].totalLiquidity.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: ScreenUtil().setSp(26),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '  USD',
                                    style: Util.textStyle4WapEn(context, 2, Colors.grey[800], spacing: 0.0, size: 26),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${S.of(context).swapToken}',
                              style: Util.textStyle4Wap(context, 2, Colors.grey[700], spacing: 0.0, size: 26),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(15)),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipOval(
                                    child: Image.network(
                                      '${_swapRows[_rightSelectIndex].basePicUrl}',
                                      width: ScreenUtil().setWidth(35),
                                      height: ScreenUtil().setWidth(35),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                                  child: Text(
                                    '${_swapRows[_rightSelectIndex].baseTokenAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: ScreenUtil().setSp(26),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '  ${_swapRows[_rightSelectIndex].baseTokenName}',
                                    style: Util.textStyle4Wap(context, 2, Colors.grey[800], spacing: 0.0, size: 26),

                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(15)),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipOval(
                                    child: Image.network(
                                      '${_swapRows[_rightSelectIndex].swapPicUrl}',
                                      width: ScreenUtil().setWidth(35),
                                      height: ScreenUtil().setWidth(35),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                                  child: Text(
                                    '${_swapRows[_rightSelectIndex].swapTokenAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: ScreenUtil().setSp(26),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '  ${_swapRows[_rightSelectIndex].swapTokenName}',
                                    style: Util.textStyle4Wap(context, 2, Colors.grey[800], spacing: 0.0, size: 26),
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

  Widget _swapWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        js.context['setAllowance'] = setAllowance;
        js.context['setApprove'] = setApprove;
        js.context['setTrxToTokenSwap'] = setTrxToTokenSwap;
        js.context['setTokenToTrxSwap'] = setTokenToTrxSwap;
        js.context['setTokenToTokenSwap'] = setTokenToTokenSwap;
        js.context['setError'] = setError;
        if (_account != '' && _flag1 && _flag2 && _swapFlag) {
          double value1 = double.parse(_leftSwapValue);
          double value2 = double.parse(_rightSwapValue);
          if (value1 > 0 && value2 > 0) {
            setState(() {
              _loadFlag = true;
            });
            if (_swapRows[_leftSelectIndex].swapTokenType == 2) {
              js.context.callMethod('allowance', [_swapRows[_leftSelectIndex].lpTokenAddress, 2, _swapRows[_rightSelectIndex].swapTokenType, _swapRows[_leftSelectIndex].swapTokenAddress, _swapRows[_rightSelectIndex].swapTokenAddress, _account, _leftSwapValue, _rightSwapValue]);
            } else if (_swapRows[_leftSelectIndex].swapTokenType == 1 && _swapRows[_rightSelectIndex].swapTokenType == 2){
              js.context.callMethod('trxToTokenSwap', [_swapRows[_rightSelectIndex].swapTokenAddress, _swapRows[_rightSelectIndex].lpTokenAddress, 1, _leftSwapValue, _account]);
            }
          }
        }
      },
      child: Container(
        color: Colors.white,
        child: Chip(
          padding: _swapFlag ? EdgeInsets.only(left: ScreenUtil().setWidth(80), top: ScreenUtil().setHeight(20), right: ScreenUtil().setWidth(80), bottom: ScreenUtil().setHeight(20)) : EdgeInsets.only(left: ScreenUtil().setWidth(60), top: ScreenUtil().setHeight(20), right: ScreenUtil().setWidth(60), bottom: ScreenUtil().setHeight(20)),
          backgroundColor:  MyColors.blue500,
          label: !_loadFlag ? Container(
            child: Text(
              _swapFlag ? '${S.of(context).swapSwap}' : '${S.of(context).swapTokenNotEnough}',
              style: Util.textStyle4Wap(context, 2, Colors.white, spacing: 0.5, size: 28),
            ),
          ) : Container(
            color: Colors.blue[500],
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _appBarWidget(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0.0,
      title: Container(
        child: Image.asset('images/logo150.png', fit: BoxFit.contain, width: ScreenUtil().setWidth(110), height: ScreenUtil().setWidth(110)),
      ),
      leading: IconButton(
        hoverColor: MyColors.white,
        icon: Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
          child: Icon(Icons.menu, size: ScreenUtil().setWidth(55), color: Colors.grey[800]),
        ),
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
      ),
      centerTitle: true,
    );
  }

  Widget _drawerWidget(BuildContext context) {
    int _homeIndex = CommonProvider.homeIndex;
    return Drawer(
      child: Container(
        color: MyColors.white,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            ListTile(
              title: Text(
                '${S.of(context).actionTitle0}',
                style: Util.textStyle4Wap(context, 2, _homeIndex == 0 ? Colors.black : Colors.grey[700], spacing: 0.0, size: 32),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  CommonProvider.changeHomeIndex(0);
                });
                Application.router.navigateTo(context, 'wap/swap', transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.donut_small,
                color: _homeIndex == 0 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title: Text(
                '${S.of(context).actionTitle2}',
                style: Util.textStyle4Wap(context, 2, _homeIndex == 2 ? Colors.black : Colors.grey[700], spacing: 0.0, size: 32),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  CommonProvider.changeHomeIndex(2);
                });
                Application.router.navigateTo(context, 'wap/lend', transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.broken_image,
                color: _homeIndex == 2 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title: Text(
                '${S.of(context).actionTitle3}',
                style: Util.textStyle4Wap(context, 2, _homeIndex == 3 ? Colors.black : Colors.grey[700], spacing: 0.0, size: 32),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  CommonProvider.changeHomeIndex(3);
                });
                Application.router.navigateTo(context, 'wap/wallet', transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.account_balance_wallet,
                color: _homeIndex == 3 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title:  Text(
                '${S.of(context).actionTitle4}',
                style: Util.textStyle4Wap(context, 2, _homeIndex == 4 ? Colors.black : Colors.grey[700], spacing: 0.0, size: 32),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                setState(() {
                  CommonProvider.changeHomeIndex(4);
                });
                Application.router.navigateTo(context, 'wap/about', transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.file_copy_sharp,
                color: _homeIndex == 4 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title: Text(
                _account == '' ? '${S.of(context).connectAccount}' : _account.substring(0, 4) + '...' + _account.substring(_account.length - 4, _account.length),
                style: Util.textStyle4Wap(context, 2, Colors.grey[700], spacing: 0.0, size: 32),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
              },
              leading: Icon(
                Icons.account_circle,
                color: Colors.grey[700],
              ),
            ),
            ListTile(
              title: Text(
                 'English/中文',
                style: Util.textStyle4Wap(context, 2, Colors.grey[700], spacing: 0.0, size: 32),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Provider.of<IndexProvider>(context, listen: false).changeLangType();
                Navigator.pop(context);
                Util.showToast4Wap(S.of(context).success, timeValue: 2);
              },
              leading: Icon(
                Icons.language,
                color: Colors.grey[700],
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
    _timer2 = Timer.periodic(Duration(milliseconds: 2000), (timer) async {
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
            if (_flag1 && _flag2) {
              _leftKey = '$_account+${_swapRows[_leftSelectIndex].swapTokenAddress}';
              _rightKey = '$_account+${_swapRows[_rightSelectIndex].swapTokenAddress}';
            }
          });
        }
        _getTokenBalance(1);
      }
    } else {
      if (mounted) {
        setState(() {
          _account = '';
          if (_flag1 && _flag2) {
            _leftKey = '$_account+${_swapRows[_leftSelectIndex].swapTokenAddress}';
            _rightKey = '$_account+${_swapRows[_rightSelectIndex].swapTokenAddress}';
          }
        });
      }
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
      _reloadSub();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
    _reloadSwapDataFlag = true;
  }

  void _reloadSub() {
    if (_flag1 && _flag2) {
      _leftKey = '$_account+${_swapRows[_leftSelectIndex].swapTokenAddress}';
      _rightKey = '$_account+${_swapRows[_rightSelectIndex].swapTokenAddress}';
    }

    if (_flag1 && _flag2 && _swapRows[_leftSelectIndex].swapTokenPrecision > 0 && _balanceMap[_leftKey] != null) {
      _leftBalanceAmount = (Decimal.tryParse(_balanceMap[_leftKey])/Decimal.fromInt(10).pow(_swapRows[_leftSelectIndex].swapTokenPrecision)).toString();
    }
    if (_flag1 && _flag2 && _swapRows[_rightSelectIndex].swapTokenPrecision > 0 && _balanceMap[_rightKey] != null) {
      _rightBalanceAmount = (Decimal.tryParse(_balanceMap[_rightKey])/Decimal.fromInt(10).pow(_swapRows[_rightSelectIndex].swapTokenPrecision)).toString();
    }

    if (_flag1 && _flag2 && _swapRows[_rightSelectIndex].swapTokenPrice1 > 0) {
      _leftPrice = (_swapRows[_leftSelectIndex].swapTokenPrice1/_swapRows[_rightSelectIndex].swapTokenPrice1).toString();
    }
    if (_flag1 && _flag2 && _swapRows[_leftSelectIndex].swapTokenPrice1 > 0) {
      _rightPrice = (_swapRows[_rightSelectIndex].swapTokenPrice1/_swapRows[_leftSelectIndex].swapTokenPrice1).toString();
    }
  }

  bool _reloadTokenBalanceFlag = false;

  _reloadTokenBalance() async {
    js.context['setBalance']=setBalance;
    _getTokenBalance(1);
    _timer3 = Timer.periodic(Duration(milliseconds: 2000), (timer) async {
      if (_reloadTokenBalanceFlag) {
        _getTokenBalance(2);
      }
    });
  }

  _getTokenBalance(int type) async {
    _reloadTokenBalanceFlag = false;
    if (_account != '') {
      for (int i=0; i<_swapRows.length; i++) {
        String _key = '$_account+${_swapRows[i].swapTokenAddress}';
        if (type == 1 || _balanceMap[_key] == null) {
          js.context.callMethod('getTokenBalance', [_swapRows[i].swapTokenType, _swapRows[i].swapTokenAddress, _account]);
        }
      }
    }
    _reloadTokenBalanceFlag = true;
  }

  void setBalance(tokenAddress, balance) {
    try {
      double.parse(balance.toString());
    } catch (e) {
      print('setBalance double.parse error');
      return;
    }
    if (_account != '') {
      String _key = '$_account+${tokenAddress.toString()}';
      _balanceMap[_key] = balance.toString();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void setAllowance(lpTokenAddress, swapTokenType, baseTokenType, swapTokenAddress, baseTokenAddress, swapTradeValue, baseTradeValue, allowanceAmount) {
    double allowanceValue = Decimal.tryParse(allowanceAmount.toString()).toDouble();
    double swapValue = double.parse(swapTradeValue.toString());
    if (swapValue > allowanceValue) {
      js.context.callMethod('approve', [lpTokenAddress, swapTokenType, baseTokenType, swapTokenAddress, baseTokenAddress, swapTradeValue, baseTradeValue]);
    } else {
      if (_account != '' && swapTokenType.toString() == '2' && baseTokenType.toString() == '1') {
        js.context.callMethod('tokenToTrxSwap', [swapTokenAddress, lpTokenAddress, swapTradeValue, 1, _account]);
      } else if (_account != '' && swapTokenType.toString() == '2' && baseTokenType.toString() == '2') {
        js.context.callMethod('tokenToTokenSwap', [swapTokenAddress, lpTokenAddress, swapTradeValue, 1, 1, _account, baseTokenAddress]);
      }
    }
  }

  void setApprove(lpTokenAddress, swapTokenType, baseTokenType, swapTokenAddress, baseTokenAddress, swapTradeValue, baseTradeValue) {
    if (_account != '' && swapTokenType.toString() == '2' && baseTokenType.toString() == '1') {
      js.context.callMethod('tokenToTrxSwap', [swapTokenAddress, lpTokenAddress, swapTradeValue, 1, _account]);
    } else if (_account != '' && swapTokenType.toString() == '2' && baseTokenType.toString() == '2') {
      js.context.callMethod('tokenToTokenSwap', [swapTokenAddress, lpTokenAddress, swapTradeValue, 1, 1, _account, baseTokenAddress]);
    }
  }

  void setTrxToTokenSwap(swapToken, result) async {
    setState(() {
      _loadFlag = false;
    });
    Util.showToast4Wap(S.of(context).success, timeValue: 2);
    for (int i = 0; i < 3; i++) {
      await Future.delayed(Duration(milliseconds: 2000), (){
        js.context.callMethod('getTokenBalance', [1, 'TRX', _account]);
        js.context.callMethod('getTokenBalance', [2, swapToken, _account]);
        if (i == 0) {
          setState(() {
            _leftSwapAmount = '';
            _leftSwapValue = '';
            _rightSwapAmount = '';
            _rightSwapValue = '';
          });
        }
      });
    }
  }

  void setTokenToTrxSwap(swapToken, result) async {
    setState(() {
      _loadFlag = false;
    });
    Util.showToast4Wap(S.of(context).success, timeValue: 2);
    for (int i = 0; i < 3; i++) {
      await Future.delayed(Duration(milliseconds: 2000), (){
        js.context.callMethod('getTokenBalance', [2, swapToken, _account]);
        js.context.callMethod('getTokenBalance', [1, 'TRX', _account]);
        if (i == 0) {
          setState(() {
            _leftSwapAmount = '';
            _leftSwapValue = '';
            _rightSwapAmount = '';
            _rightSwapValue = '';
          });
        }
      });
    }
  }

  void setTokenToTokenSwap(leftToken, rightToken, result) async {
    setState(() {
      _loadFlag = false;
    });
    Util.showToast4Wap(S.of(context).success, timeValue: 2);
    for (int i = 0; i < 3; i++) {
     await  Future.delayed(Duration(milliseconds: 2000), (){
        js.context.callMethod('getTokenBalance', [2, leftToken, _account]);
        js.context.callMethod('getTokenBalance', [2, rightToken, _account]);
        if (i == 0) {
          setState(() {
            _leftSwapAmount = '';
            _leftSwapValue = '';
            _rightSwapAmount = '';
            _rightSwapValue = '';
          });
        }
      });
    }
  }

  void setError(msg) {
    print('setError: ${msg.toString()}');
    Util.showToast4Wap('${msg.toString()}');
    setState(() {
      _loadFlag = false;
    });
  }


}
