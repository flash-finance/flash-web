import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:flash_web/common/color.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/model/farm_model.dart';
import 'package:flash_web/provider/common_provider.dart';
import 'package:flash_web/provider/index_provider.dart';
import 'package:flash_web/router/application.dart';
import 'package:flash_web/util/common_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:js' as js;

import 'package:provider/provider.dart';

class FarmWapPage extends StatefulWidget {
  @override
  _FarmWapPageState createState() => _FarmWapPageState();
}

class _FarmWapPageState extends State<FarmWapPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  int _layoutIndex = -1;
  bool _layoutFlag = false;
  bool tronFlag = false;
  Timer _timer1;
  Timer _timer2;
  Timer _timer3;
  Timer _timer4;
  String _toDepositAmount = '0.00';
  String _toWithdrawAmount = '0.00';
  String _toHarvestAmount = '0.00';

  String _toDepositValue = '0.00';
  String _toWithdrawValue = '0.00';
  String _toHarvestValue = '0.00';

  TextEditingController _toDepositAmountController;
  TextEditingController _toWithdrawAmountController;
  TextEditingController _toHarvestAmountController;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        CommonProvider.changeHomeIndex(0);
      });
    }
    _getMineInfo();
    _getApy();
    _reloadAccount();
    _reloadAmount();
  }

  @override
  void dispose() {
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
    if (_timer4 != null) {
      if (_timer4.isActive) {
        _timer4.cancel();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);
    _toDepositAmountController =  TextEditingController.fromValue(TextEditingValue(text: _toDepositAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _toDepositAmount.length))));
    _toWithdrawAmountController =  TextEditingController.fromValue(TextEditingValue(text: _toWithdrawAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _toWithdrawAmount.length))));
    _toHarvestAmountController =  TextEditingController.fromValue(TextEditingValue(text: _toHarvestAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _toHarvestAmount.length))));

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.white,
      appBar: _appBarWidget(context),
      drawer: _drawerWidget(context),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _mainWidget(context),
          ),
          //FooterPage(),
        ],
      ),
    );
  }

  Widget _mainWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, top: 0, right: 0),
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
      color: MyColors.white,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _farmRows.length,
        itemBuilder: (context, index) {
          return _bizWidget(context, _farmRows[index], index);
        },
      ),
    );
  }

  Widget _bizWidget(BuildContext context, FarmRows item, int index) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: index == 0 ? ScreenUtil().setHeight(30) : ScreenUtil().setHeight(0)),
          !_layoutFlag ? _oneWidget(context, item, index) : (_layoutIndex == index ? _twoWidget(context, item, index) : _oneWidget(context, item, index)),
          SizedBox(height: ScreenUtil().setHeight(10)),
          SizedBox(height: index == _farmRows.length - 1 ? ScreenUtil().setHeight(30) : ScreenUtil().setHeight(0)),
        ],
      ),
    );
  }

  Widget _oneWidget(BuildContext context, FarmRows item, int index) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(700),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Container(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(25), bottom: ScreenUtil().setHeight(25)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _topBizWidget(context, item, index, 1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _twoWidget(BuildContext context, FarmRows item, int index) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(700),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Container(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(25), bottom: ScreenUtil().setHeight(25)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _topBizWidget(context, item, index, 2),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    _bottomBizWidget(context, item),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBizWidget(BuildContext context, FarmRows item, int index, int type) {
    return InkWell(
      onTap: () {
        setState(() {
          _layoutIndex = index;
          if (type == 1) {
            _layoutFlag = true;
          } else {
            _layoutFlag = false;
          }
          _toDepositAmount = '';
          _toWithdrawAmount = '';
          _toHarvestAmount = '';

          _toDepositValue = '';
          _toWithdrawValue = '';
          _toHarvestValue = '';
        });
      },
      child: Container(
        color: MyColors.white,
        width: ScreenUtil().setWidth(700),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: ClipOval(
                child: Image.asset(
                  '${item.pic1}',
                  width: ScreenUtil().setWidth(55),
                  height: ScreenUtil().setWidth(55),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(50)),
            Container(
              width: ScreenUtil().setWidth(160),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${item.depositTokenName}',
                      style: GoogleFonts.lato(
                        fontSize: ScreenUtil().setSp(30),
                        color: MyColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(8)),
                  Container(
                    child: Text(
                      '${item.depositTokenName}',
                      style: GoogleFonts.lato(
                        fontSize: ScreenUtil().setSp(20),
                        color: MyColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(50)),
            Container(
              width: ScreenUtil().setWidth(160),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${item.apy}%',
                      style: GoogleFonts.lato(
                        fontSize: ScreenUtil().setSp(30),
                        color: MyColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  Container(
                    child: Text(
                      '${S.of(context).farmApy}',
                      style: GoogleFonts.lato(
                        fontSize: ScreenUtil().setSp(20),
                        color: MyColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(50)),

            InkWell(
              onTap: () {
                setState(() {
                  _layoutIndex = index;
                  if (type == 1) {
                    _layoutFlag = true;
                  } else {
                    _layoutFlag = false;
                  }
                  _toDepositAmount = '';
                  _toWithdrawAmount = '';
                  _toHarvestAmount = '';

                  _toDepositValue = '';
                  _toWithdrawValue = '';
                  _toHarvestValue = '';
                });
              },
              child: Chip(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(6), top: ScreenUtil().setHeight(20), bottom: ScreenUtil().setHeight(20), right: ScreenUtil().setWidth(6)),
                backgroundColor: MyColors.blue500,
                label: Icon(
                  !_layoutFlag ? CupertinoIcons.down_arrow : (_layoutIndex == index ? CupertinoIcons.up_arrow : CupertinoIcons.down_arrow),
                  size: ScreenUtil().setSp(32),
                  color: MyColors.white,
                ),
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(25)),
          ],
        ),
      ),
    );
  }

  Widget _bottomBizWidget(BuildContext context, FarmRows item) {
    String balanceAmount = (Decimal.tryParse(item.balanceAmount)/Decimal.fromInt(10).pow(item.depositTokenDecimal)).toStringAsFixed(3);
    String depositedAmount = (Decimal.tryParse(item.depositedAmount)/Decimal.fromInt(10).pow(item.depositTokenDecimal)).toStringAsFixed(3);
    String harvestedAmount = (Decimal.tryParse(item.harvestedAmount)/Decimal.fromInt(10).pow(item.mineTokenDecimal)).toStringAsFixed(4);

    String account = Provider.of<IndexProvider>(context).account;

    return Container(
      width: ScreenUtil().setWidth(700),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(340),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${S.of(context).farmBalance}:   $balanceAmount ${item.depositTokenName}',
                        style: GoogleFonts.lato(
                          fontSize: ScreenUtil().setSp(23),
                          color: MyColors.grey700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(side: BorderSide(width: 1.2, color: Colors.grey[300]), borderRadius: BorderRadius.all(Radius.circular(25.0))),
                      child: Container(
                        width: ScreenUtil().setWidth(280),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30), top: ScreenUtil().setHeight(1), bottom: ScreenUtil().setHeight(1)),
                        child: TextFormField(
                          controller: _toDepositAmountController,
                          enableInteractiveSelection: false,
                          cursorColor: MyColors.black87,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: '',
                            hintStyle: GoogleFonts.lato(
                              color: Colors.grey[500],
                              fontSize: ScreenUtil().setSp(23),
                              letterSpacing: 0.5,
                            ),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.lato(
                            color: MyColors.black87,
                            fontSize: ScreenUtil().setSp(26),
                          ),
                          inputFormatters: [MyNumberTextInputFormatter(digit:3)],
                          onChanged: (String value) {
                            if (value != null && value != '') {
                              _toDepositAmount = value;
                              _toDepositValue = value;
                            } else {
                              _toDepositAmount = '';
                              _toDepositValue = '';
                            }
                            setState(() {});
                          },
                          onSaved: (String value) {},
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Container(
                      width: ScreenUtil().setWidth(350),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _rateWidget(context, 1, item, 25),
                          SizedBox(width: ScreenUtil().setWidth(0)),
                          _rateWidget(context, 1, item, 50),
                          SizedBox(width: ScreenUtil().setWidth(0)),
                          _rateWidget(context, 1, item, 75),
                          SizedBox(width: ScreenUtil().setWidth(0)),
                          _rateWidget(context, 1, item, 100),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    InkWell(
                      onTap: () {
                        js.context['setAllowance']=setAllowance;
                        js.context['setStake']=setStake;
                        js.context['setHash']=setHash;

                        if (_toDepositValue == '' || item.balanceAmount == '') {
                          return;
                        }
                        double value1 =  (Decimal.tryParse(_toDepositValue) * Decimal.fromInt(10).pow(item.depositTokenDecimal)).toDouble();
                        if (value1 <= 0) {
                          //_shoTipsLog('${S.of(context).farmTips1}');
                          return;
                        }
                        double value2 = double.parse(item.balanceAmount);
                        if (value1 > value2) {
                          return;
                        }
                        if (account != '' && item.depositTokenType != 1) {
                          js.context.callMethod('allowance', [item.depositTokenType, value1, account, item.depositTokenAddress, item.poolAddress]);
                        } else {
                          js.context.callMethod('stake', [item.depositTokenType, value1, item.poolAddress]);
                        }
                      },
                      child: Container(
                        color: MyColors.white,
                        child: Chip(
                          elevation: 2,
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(10), bottom: ScreenUtil().setHeight(10), right: ScreenUtil().setWidth(20)),
                          backgroundColor: MyColors.blue500,
                          label: Text(
                            '${S.of(context).farmDeposit}',
                            style: GoogleFonts.lato(
                              letterSpacing: 0.5,
                              color: MyColors.white,
                              fontSize: ScreenUtil().setSp(24),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(340),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${S.of(context).farmDeposited}:   $depositedAmount ${item.depositTokenName}',
                        style: GoogleFonts.lato(
                          fontSize: ScreenUtil().setSp(23),
                          color: MyColors.grey700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(side: BorderSide(width: 1.2, color: Colors.grey[300]), borderRadius: BorderRadius.all(Radius.circular(25.0))),
                      child: Container(
                        width: ScreenUtil().setWidth(280),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30), top: ScreenUtil().setHeight(1), bottom: ScreenUtil().setHeight(1)),
                        child: TextFormField(
                          controller: _toWithdrawAmountController,
                          enableInteractiveSelection: false,
                          cursorColor: MyColors.black87,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: '',
                            hintStyle: GoogleFonts.lato(
                              color: Colors.grey[500],
                              fontSize: ScreenUtil().setSp(26),
                              letterSpacing: 0.5,
                            ),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.lato(
                            color: MyColors.black87,
                            fontSize: ScreenUtil().setSp(26),
                          ),
                          inputFormatters: [MyNumberTextInputFormatter(digit:3)],
                          onChanged: (String value) {
                            if (value != null && value != '') {
                              _toWithdrawAmount = value;
                              _toWithdrawValue = value;
                            } else {
                              _toWithdrawAmount = '';
                              _toWithdrawValue = '';
                            }
                            setState(() {});
                          },
                          onSaved: (String value) {},
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Container(
                      width: ScreenUtil().setWidth(350),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _rateWidget(context, 2, item, 25),
                          SizedBox(width: ScreenUtil().setWidth(0)),
                          _rateWidget(context, 2, item, 50),
                          SizedBox(width: ScreenUtil().setWidth(0)),
                          _rateWidget(context, 2, item, 75),
                          SizedBox(width: ScreenUtil().setWidth(0)),
                          _rateWidget(context, 2, item, 100),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    InkWell(
                      onTap: () {
                        js.context['setAllowance']=setAllowance;
                        js.context['setStake']=setStake;
                        js.context['setHash']=setHash;

                        if (_toWithdrawValue == '' || item.depositedAmount == '') {
                          return;
                        }
                        double value1 =  (Decimal.tryParse(_toWithdrawValue) * Decimal.fromInt(10).pow(item.depositTokenDecimal)).toDouble();
                        if (value1 <= 0) {
                          return;
                        }
                        double value2 = double.parse(item.depositedAmount);
                        if (value1 > value2) {
                          return;
                        }
                        js.context.callMethod('withdraw', [value1, item.poolAddress]);
                      },
                      child: Container(
                        color: MyColors.white,
                        child: Chip(
                          elevation: 2,
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(10), bottom: ScreenUtil().setHeight(10), right: ScreenUtil().setWidth(20)),
                          backgroundColor: MyColors.blue500,
                          label: Text(
                            '${S.of(context).farmWithdraw}',
                            style: GoogleFonts.lato(
                              letterSpacing: 0.5,
                              color: MyColors.white,
                              fontSize: ScreenUtil().setSp(24),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(680),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(340),
                      alignment: Alignment.center,
                      child: Text(
                        '${S.of(context).farmReward}:   $harvestedAmount ${item.mineTokenName}',
                        style: GoogleFonts.lato(
                          fontSize: ScreenUtil().setSp(23),
                          color: MyColors.grey700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(side: BorderSide(width: 1.2, color: Colors.grey[300]), borderRadius: BorderRadius.all(Radius.circular(25.0))),
                      child: Container(
                        width: ScreenUtil().setWidth(350),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30), top: ScreenUtil().setHeight(1), bottom: ScreenUtil().setHeight(1)),
                        child: TextFormField(
                          controller: _toHarvestAmountController,
                          enableInteractiveSelection: false,
                          readOnly: true,
                          cursorColor: MyColors.black87,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: '',
                            hintStyle: GoogleFonts.lato(
                              color: Colors.grey[500],
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.lato(
                            color: MyColors.black87,
                            fontSize: ScreenUtil().setSp(26),
                          ),
                          inputFormatters: [MyNumberTextInputFormatter(digit:6)],
                          onChanged: (String value) {
                            if (value != null && value != '') {
                              _toHarvestAmount = value;
                              _toHarvestValue = value;
                            } else {
                              _toHarvestAmount = '';
                              _toHarvestValue = '';
                            }
                            setState(() {});
                          },
                          onSaved: (String value) {},
                          onEditingComplete: () {},
                        ),
                      ),
                      ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Container(
                      width: ScreenUtil().setWidth(350),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _rateWidget(context, 3, item, 100),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    InkWell(
                      onTap: () {
                        js.context['setAllowance']=setAllowance;
                        js.context['setStake']=setStake;
                        js.context['setHash']=setHash;

                        if (_toHarvestValue == '' || item.harvestedAmount == '') {
                          return;
                        }
                        double value1 = double.parse(_toHarvestValue);
                        if (value1 <= 0) {
                          return;
                        }
                        double value2 = double.parse(item.harvestedAmount);
                        if (value2 <= 0) {
                          return;
                        }
                        js.context.callMethod('getReward', [item.poolAddress]);
                      },
                      child: Container(
                        color: MyColors.white,
                        child: Chip(
                          elevation: 2,
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(10), bottom: ScreenUtil().setHeight(10), right: ScreenUtil().setWidth(20)),
                          backgroundColor: MyColors.blue500,
                          label: Text(
                            '${S.of(context).farmHarvest}',
                            style: GoogleFonts.lato(
                              letterSpacing: 0.5,
                              color: MyColors.white,
                              fontSize: ScreenUtil().setSp(24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rateWidget(BuildContext context, int type, FarmRows item, int rate) {
    double balanceAmount = (Decimal.tryParse(item.balanceAmount)/Decimal.fromInt(10).pow(item.depositTokenDecimal)).toDouble();
    double depositedAmount = (Decimal.tryParse(item.depositedAmount)/Decimal.fromInt(10).pow(item.depositTokenDecimal)).toDouble();
    double harvestedAmount = (Decimal.tryParse(item.harvestedAmount)/Decimal.fromInt(10).pow(item.mineTokenDecimal)).toDouble();

    double amount = 0.0;
    if (type == 1) {
      amount = balanceAmount;
    } else if (type == 2) {
      amount = depositedAmount;
    } else if (type == 3) {
      amount = harvestedAmount;
    }

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: InkWell(
        hoverColor: Colors.white,
        splashColor: Color(0x802196F3),
        highlightColor: Color(0x802196F3),
        onTap: () {
          String account = Provider.of<IndexProvider>(context, listen: false).account;
          double rateDouble = NumUtil.divide(rate, 100);
          if(account != '') {
            double value = NumUtil.multiply(amount, rateDouble);
            setState(() {
              if (type == 1) {
                _toDepositAmount = value.toStringAsFixed(3);
                _toDepositValue = value.toStringAsFixed(item.depositTokenDecimal);
              } else if (type == 2) {
                _toWithdrawAmount = value.toStringAsFixed(3);
                _toWithdrawValue = value.toStringAsFixed(item.depositTokenDecimal);
              } else if (type == 3) {
                _toHarvestAmount = value.toStringAsFixed(4);
                _toHarvestValue = value.toStringAsFixed(item.mineTokenDecimal);
              }
            });
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(15), top: ScreenUtil().setHeight(8), bottom: ScreenUtil().setHeight(8), right: ScreenUtil().setWidth(15)),
          child: Text(
            '$rate%',
            style: GoogleFonts.lato(
              letterSpacing: 0.5,
              color: Colors.blue[800],
              fontSize: ScreenUtil().setSp(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBarWidget(BuildContext context) {
    return AppBar(
      backgroundColor:  MyColors.lightBg,
      elevation: 0,
      titleSpacing: 0.0,
      title: Container(
        child: Image.asset('images/logo.png', fit: BoxFit.contain, width: ScreenUtil().setWidth(110), height: ScreenUtil().setWidth(110)),
      ),
      leading: IconButton(
        hoverColor: MyColors.white,
        icon: Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
          child: Icon(Icons.menu, size: ScreenUtil().setWidth(55), color: Colors.black87),
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
    String account = Provider.of<IndexProvider>(context).account;
    return Drawer(
      child: Container(
        color: MyColors.white,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            ListTile(
              title: Text(
                '${S.of(context).actionTitle0}',
                style: GoogleFonts.lato(
                  fontSize: ScreenUtil().setSp(32),
                  color: _homeIndex == 0 ? Colors.black : Colors.grey[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  CommonProvider.changeHomeIndex(0);
                });
                Application.router.navigateTo(context, 'wap/farm', transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.assistant,
                color: _homeIndex == 0 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title:  Text(
                '${S.of(context).actionTitle1}',
                style: GoogleFonts.lato(
                  fontSize: ScreenUtil().setSp(32),
                  color: _homeIndex == 1 ? Colors.black : Colors.grey[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                setState(() {
                  CommonProvider.changeHomeIndex(1);
                });
                Application.router.navigateTo(context, 'wap/swap', transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.broken_image,
                color: _homeIndex == 1 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title:  Text(
                '${S.of(context).actionTitle3}',
                style: GoogleFonts.lato(
                  fontSize: ScreenUtil().setSp(32),
                  color: _homeIndex == 2 ? Colors.black : Colors.grey[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                setState(() {
                  CommonProvider.changeHomeIndex(2);
                });
                Application.router.navigateTo(context, 'wap/about', transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.file_copy_sharp,
                color: _homeIndex == 2 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title: Text(
                account == '' ? '${S.of(context).actionTitle4}' : account.substring(0, 4) + '...' + account.substring(account.length - 4, account.length),
                style: GoogleFonts.lato(
                  fontSize: ScreenUtil().setSp(32),
                  color: Colors.grey[700],
                ),
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
                style: GoogleFonts.lato(
                  fontSize: ScreenUtil().setSp(32),
                  color: Colors.grey[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Provider.of<IndexProvider>(context, listen: false).changeLangType();
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


  void setAllowance(tokenType, stakeAmount, tokenAddress, poolAddress, allowanceAmount) {
    double allowanceValue = Decimal.tryParse(allowanceAmount.toString()).toDouble();
    double stakeValue= double.parse(stakeAmount.toString());
    if (stakeValue > allowanceValue) {
      js.context.callMethod('approve', [tokenType, stakeAmount, tokenAddress, poolAddress]);
    } else {
      js.context.callMethod('stake', [tokenType, stakeAmount, poolAddress]);
    }
  }

  void setStake(tokenType, stakeAmount, poolAddress) {
    js.context.callMethod('stake', [tokenType, stakeAmount, poolAddress]);
  }

  void setHash(type, hash) {
    setState(() {
      if (type == 1) {
        _toDepositAmount = '';
        _toDepositValue = '';
      } else if (type == 2) {
        _toWithdrawAmount = '';
        _toWithdrawValue = '';
      } else if (type == 3) {
        _toHarvestAmount = '';
        _toHarvestValue = '';
      }
    });
  }

  _reloadAccount() async {
    _timer1 = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
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

  _reloadAmount() async {
    js.context['setAmount']=setAmount;
    _timer2 = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      String account = Provider.of<IndexProvider>(context, listen: false).account;
      if (account != '') {
        for (int i=0; i<_farmRows.length; i++) {
          js.context.callMethod('getAmount', [i.toString(), account, _farmRows[i].depositTokenAddress, _farmRows[i].poolAddress]);
        }
      } else {
        for (int i=0; i<_farmRows.length; i++) {
          setAmount(i, '0', '0', '0');
        }
      }
    });
  }

  void setAmount(index, balanceAmount, depositedAmount, harvestedAmount) {
    int i = int.parse(index.toString());
    if (_farmRows.length > i) {
      if (balanceAmount.toString() != '') {
        _farmRows[i].balanceAmount = balanceAmount.toString();
      }
      if (depositedAmount.toString() != '') {
        _farmRows[i].depositedAmount = depositedAmount.toString();
      }
      if (harvestedAmount.toString() != '') {
        _farmRows[i].harvestedAmount = harvestedAmount.toString();
      }
      setState(() {});
    }
  }

  _getMineInfo() async {
    _getFarmData();
    js.context['setMineInfo']=setMineInfo;
    _timer3 = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      for (int i=0; i<_farmRows.length; i++) {
        js.context.callMethod('getMineInfo', [i.toString(), _farmRows[i].poolAddress, _farmRows[i].depositLpToken, _farmRows[i].mineLpToken]);
      }
    });
  }

  void setMineInfo(index, totalSupply, depositTokenPrice, mineTokenPrice) {
    int i = int.parse(index.toString());
    if (_farmRows.length > i) {
      double total = (Decimal.tryParse(totalSupply.toString())/Decimal.fromInt(10).pow(_farmRows[i].depositTokenDecimal)).toDouble();
      _farmRows[i].depositTotalSupply = total;
      double depositPrice = (Decimal.tryParse(depositTokenPrice.toString())/Decimal.fromInt(10).pow(_farmRows[i].depositTokenDecimal)).toDouble();
      double minePrice = (Decimal.tryParse(mineTokenPrice.toString())/Decimal.fromInt(10).pow(_farmRows[i].mineTokenDecimal)).toDouble();
      if (depositPrice > 0) {
        _farmRows[i].depositTokenPrice = 1/depositPrice;
      }
      if (minePrice > 0) {
        _farmRows[i].mineTokenPrice = 1/minePrice;
      }
      setState(() {});
    }
  }

  _getApy() async {
    _timer4 = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      String account = Provider.of<IndexProvider>(context, listen: false).account;
      if (account != '') {
        for (int i=0; i<_farmRows.length; i++) {
          if (_farmRows[i].depositTotalSupply > 0 && _farmRows[i].depositTokenPrice > 0 && _farmRows[i].mineTokenPrice > 0) {
            double value = (_farmRows[i].produceAmount * _farmRows[i].mineTokenPrice* 365*100) /(_farmRows[i].depositTotalSupply*_farmRows[i].depositTokenPrice);
            _farmRows[i].apy = value.toStringAsFixed(2);
          }
        }
      }
    });
  }

  List<FarmRows> _farmRows = List<FarmRows>();

  _getFarmData() async {
    _farmRows.add(FarmRows(
      id: 0,
      poolType: 1,
      poolAddress: 'TQjaZ9FD473QBTdUzMLmSyoGB6Yz1CGpux',
      depositTokenName: 'TRX',
      depositTokenType: 1,
      depositTokenAddress: '',
      depositTokenDecimal: 6,
      mineTokenName: 'SUN',
      mineTokenType: 2,
      mineTokenAddress: 'TKkeiboTkxXKJpbmVFbv4a8ov5rAfRDMf9',
      mineTokenDecimal: 18,
      pic1: 'images/trx.png',
      pic2: 'images/trx.png',
      apy: '0.00',
      balanceAmount: '0',
      depositedAmount: '0',
      harvestedAmount: '0',
      depositTotalSupply: 0,
      produceAmount: 2400,
      depositTokenPrice: 0,
      mineTokenPrice: 0,
      depositLpToken: '',
      mineLpToken: 'TUEYcyPAqc4hTg1fSuBCPc18vGWcJDECVw',
    ));
    _farmRows.add(FarmRows(
      id: 1,
      poolType: 1,
      poolAddress: 'TTSV7bKDPoJQ8HsMBseNbgQrDCDtAFnAA6',
      depositTokenName: 'SUN',
      depositTokenType: 2,
      depositTokenAddress: 'TKkeiboTkxXKJpbmVFbv4a8ov5rAfRDMf9',
      depositTokenDecimal: 18,
      mineTokenName: 'SUN',
      mineTokenType: 2,
      mineTokenAddress: 'TKkeiboTkxXKJpbmVFbv4a8ov5rAfRDMf9',
      mineTokenDecimal: 18,
      pic1: 'images/sun.png',
      pic2: 'images/sun.png',
      apy: '0.00',
      balanceAmount: '0',
      depositedAmount: '0',
      harvestedAmount: '0',
      depositTotalSupply: 0,
      produceAmount: 1600,
      depositTokenPrice: 0,
      mineTokenPrice: 1,
      depositLpToken: 'TUEYcyPAqc4hTg1fSuBCPc18vGWcJDECVw',
      mineLpToken: 'TUEYcyPAqc4hTg1fSuBCPc18vGWcJDECVw',
    ));
    setState(() {});
  }


}
