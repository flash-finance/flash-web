import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:flash_web/common/color.dart';
import 'package:flash_web/config/service_config.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/model/farm2_model.dart';
import 'package:flash_web/model/farm_model.dart';
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

class FarmPcPage extends StatefulWidget {
  @override
  _FarmPcPageState createState() => _FarmPcPageState();
}

class _FarmPcPageState extends State<FarmPcPage> {
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
        CommonProvider.changeHomeIndex(1);
      });
    }
    Provider.of<IndexProvider>(context, listen: false).init();

    _reloadFarmData();
    _getMineInfo();
    //_getApy();
    //_reloadAccount();
    //_reloadAmount();
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
    LocalScreenUtil.instance = LocalScreenUtil.getInstance()..init(context);
    _toDepositAmountController =  TextEditingController.fromValue(TextEditingValue(text: _toDepositAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _toDepositAmount.length))));
    _toWithdrawAmountController =  TextEditingController.fromValue(TextEditingValue(text: _toWithdrawAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _toWithdrawAmount.length))));
    _toHarvestAmountController =  TextEditingController.fromValue(TextEditingValue(text: _toHarvestAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _toHarvestAmount.length))));

    return Material(
      color: MyColors.white,
      child: Scaffold(
        backgroundColor: MyColors.white,
        key: _scaffoldKey,
        appBar: _appBarWidget(context),
        body: Column(
          children: <Widget>[
            Expanded(
              child: _mainWidget(context),
            ),
            //FooterPage(),
          ],
        ),
      ),
    );
  }

  Widget _mainWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      color: MyColors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _topWidget(context),
                _bodyWidget(context),
              ],
            ),
          ),
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
                      'Flash  Farm',
                      style: GoogleFonts.lato(
                        fontSize: 30,
                        color: MyColors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      '${S.of(context).aboutTips3}',
                      style: GoogleFonts.lato(fontSize: 15, color: MyColors.white),
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

  Widget _bodyWidget(BuildContext context) {
    return Container(
      color: MyColors.white,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _farm2Rows.length,
        itemBuilder: (context, index) {
          return _bizWidget(context, _farm2Rows[index], index);
        },
      ),
    );
  }

  Widget _bizWidget(BuildContext context, FarmRow item, int index) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: index == 0 ? 10 : 0),
          !_layoutFlag ? _oneWidget(context, item, index) : (_layoutIndex == index ? _twoWidget(context, item, index) : _oneWidget(context, item, index)),
          SizedBox(height: 10),
          SizedBox(height: index == _farmRows.length - 1 ? 50 : 0),
        ],
      ),
    );
  }

  Widget _oneWidget(BuildContext context, FarmRow item, int index) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 1000,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Container(
                padding: EdgeInsets.only(top: 25, bottom: 25),
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

  Widget _twoWidget(BuildContext context, FarmRow item, int index) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 1000,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Container(
                padding: EdgeInsets.only(top: 25, bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _topBizWidget(context, item, index, 2),
                    SizedBox(height: 30),
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

  Widget _topBizWidget(BuildContext context, FarmRow item, int index, int type) {
    var time = DateTime.fromMillisecondsSinceEpoch(item.endTime * 1000);
    String timeStr = DateUtil.formatDate(time, format: 'yyyy-MM-dd HH:mm');
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
        width: 1000,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: ClipOval(
                child: Image.network(
                  '${item.pic1}',
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 50),
            Container(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${item.depositTokenName}',
                      style: GoogleFonts.lato(
                        fontSize: 17,
                        color: MyColors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Text(
                     item.poolType == 1 ? 'Token': 'LP Token',
                      style: GoogleFonts.lato(
                        fontSize: 14.5,
                        color: MyColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 50),
            Container(
              width: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Container(
                    child: Text(
                      '${item.depositTokenValue.toStringAsFixed(0)}  USD',
                      style: GoogleFonts.lato(
                        fontSize: 17,
                        color: MyColors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Text(
                      '${S.of(context).farmStaked}',
                      style: GoogleFonts.lato(
                        fontSize: 14.5,
                        color: MyColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 50),
            Container(
              width: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '$timeStr',
                      style: GoogleFonts.lato(
                        fontSize: 17,
                        color: MyColors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Text(
                      '${S.of(context).farmDeadline}',
                      style: GoogleFonts.lato(
                        fontSize: 14.5,
                        color: MyColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 50),
            Container(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${(item.apy * 100).toStringAsFixed(2)}%',
                      style: GoogleFonts.lato(
                        fontSize: 17,
                        color: MyColors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Text(
                      '${S.of(context).farmApy}',
                      style: GoogleFonts.lato(
                        fontSize: 14.5,
                        color: MyColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 50),
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
                padding: EdgeInsets.only(left: 5, top: 15, bottom: 15, right: 5),
                backgroundColor: MyColors.blue500,
                label: Icon(
                  !_layoutFlag ? CupertinoIcons.down_arrow : (_layoutIndex == index ? CupertinoIcons.up_arrow : CupertinoIcons.down_arrow),
                  size: 23,
                  color: MyColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBizWidget(BuildContext context, FarmRow item) {
    //String balanceAmount = (Decimal.tryParse(item.balanceAmount)/Decimal.fromInt(10).pow(item.depositTokenDecimal)).toStringAsFixed(3);
    //String depositedAmount = (Decimal.tryParse(item.depositedAmount)/Decimal.fromInt(10).pow(item.depositTokenDecimal)).toStringAsFixed(3);
    //String harvestedAmount = (Decimal.tryParse(item.harvestedAmount)/Decimal.fromInt(10).pow(item.mineTokenDecimal)).toStringAsFixed(4);
    String balanceAmount = '';
    String depositedAmount = '';
    String harvestedAmount = '';

    String account = Provider.of<IndexProvider>(context).account;

    return Container(
      width: 1000,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 300,
            child: Column(
              children: <Widget>[
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: Text(
                    '${S.of(context).farmBalance}:   $balanceAmount ${item.depositTokenName}',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: MyColors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(side: BorderSide(width: 1.5, color: Colors.grey[300]), borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: MaterialButton(
                    color: MyColors.white,
                    disabledColor: MyColors.white,
                    child: Container(
                      width: 300,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _toDepositAmountController,
                        enableInteractiveSelection: false,
                        cursorColor: MyColors.black87,
                        decoration: InputDecoration(
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
                          fontSize: 16,
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
                    shape: StadiumBorder(side: BorderSide(color: MyColors.white)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _rateWidget(context, 1, item, 25),
                      SizedBox(width: 5),
                      _rateWidget(context, 1, item, 50),
                      SizedBox(width: 5),
                      _rateWidget(context, 1, item, 75),
                      SizedBox(width: 5),
                      _rateWidget(context, 1, item, 100),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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
                      padding: EdgeInsets.only(left: 50, top: 15, bottom: 15, right: 50),
                      backgroundColor: MyColors.blue500,
                      label: Text(
                        '${S.of(context).farmDeposit}',
                        style: GoogleFonts.lato(
                          letterSpacing: 0.5,
                          color: MyColors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 15),
          Container(
            width: 300,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${S.of(context).farmDeposited}:   $depositedAmount ${item.depositTokenName}',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: MyColors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(side: BorderSide(width: 1.5, color: Colors.grey[300]), borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: MaterialButton(
                    elevation: 3,
                    color: MyColors.white,
                    disabledColor: MyColors.white,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _toWithdrawAmountController,
                        enableInteractiveSelection: false,
                        cursorColor: MyColors.black87,
                        decoration: InputDecoration(
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
                          fontSize: 16,
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
                    shape: StadiumBorder(side: BorderSide(color: MyColors.white)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _rateWidget(context, 2, item, 25),
                      SizedBox(width: 0),
                      _rateWidget(context, 2, item, 50),
                      SizedBox(width: 0),
                      _rateWidget(context, 2, item, 75),
                      SizedBox(width: 0),
                      _rateWidget(context, 2, item, 100),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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
                      //_shoTipsLog('${S.of(context).farmTips1}');
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
                      padding: EdgeInsets.only(left: 50, top: 15, bottom: 15, right: 50),
                      backgroundColor: MyColors.blue500,
                      label: Text(
                        '${S.of(context).farmWithdraw}',
                        style: GoogleFonts.lato(
                          letterSpacing: 0.5,
                          color: MyColors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Container(
            width: 300,
            color: MyColors.white,
            child: Column(
              children: <Widget>[
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: Text(
                    '${S.of(context).farmReward}:   $harvestedAmount ${item.mineTokenName}',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: MyColors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(side: BorderSide(width: 1.5, color: Colors.grey[300]), borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: MaterialButton(
                    elevation: 3,
                    color: MyColors.white,
                    disabledColor: MyColors.white,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _toHarvestAmountController,
                        enableInteractiveSelection: false,
                        readOnly: true,
                        cursorColor: MyColors.black87,
                        decoration: InputDecoration(
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
                          fontSize: 16,
                        ),
                        inputFormatters: [MyNumberTextInputFormatter(digit:4)],
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
                    shape: StadiumBorder(side: BorderSide(color: MyColors.white)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _rateWidget(context, 3, item, 100),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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
                      padding: EdgeInsets.only(left: 50, top: 15, bottom: 15, right: 50),
                      backgroundColor: MyColors.blue500,
                      label: Text(
                        '${S.of(context).farmHarvest}',
                        style: GoogleFonts.lato(
                          letterSpacing: 0.5,
                          color: MyColors.white,
                          fontSize: 15,
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
    /*if (type != 3) {
      String account = Provider.of<IndexProvider>(context, listen: false).account;
      if(account != '') {
        js.context.callMethod('getAmount', [0, account, _farmRows[0].depositTokenAddress, _farmRows[0].poolAddress]);
      }
    }*/
  }

  Widget _rateWidget(BuildContext context, int type, FarmRow item, int rate) {
    //double balanceAmount = (Decimal.tryParse(item.balanceAmount)/Decimal.fromInt(10).pow(item.depositTokenDecimal)).toDouble();
    //double depositedAmount = (Decimal.tryParse(item.depositedAmount)/Decimal.fromInt(10).pow(item.depositTokenDecimal)).toDouble();
    //double harvestedAmount = (Decimal.tryParse(item.harvestedAmount)/Decimal.fromInt(10).pow(item.mineTokenDecimal)).toDouble();

    double balanceAmount = 0;
    double depositedAmount = 0;
    double harvestedAmount = 0;

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
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
          padding: EdgeInsets.only(left: 15, top: 8, bottom: 8, right: 15),
          child: Text(
            '$rate%',
            style: GoogleFonts.lato(
              letterSpacing: 0.5,
              color: Colors.blue[800],
              fontSize: 14,
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



  Farm2Data _farm2data;

  List<FarmRow> _farm2Rows = [];

  bool _reloadFarmDataFlag = false;

  _reloadFarmData() async {
    _getFarmData();
    _timer1 = Timer.periodic(Duration(milliseconds: 2000), (timer) async {
      if (_reloadFarmDataFlag) {
        _getFarmData();
      }
    });
  }

  void _getFarmData() async {
    try {
      String url = servicePath['farmQuery'];
      await requestGet(url).then((value) {
        var respData = Map<String, dynamic>.from(value);
        FarmRespModel respModel = FarmRespModel.fromJson(respData);
        if (respModel != null && respModel.code == 0) {
          _farm2data = respModel.data;
          if (_farm2data != null && _farm2data.rows != null && _farm2data.rows.length > 0) {
            _farm2Rows = _farm2data.rows;
          }
        }
      });
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
    _reloadFarmDataFlag = true;
  }


  _getMineInfo() async {
    _getFarmData();
    /*js.context['setMineInfo']=setMineInfo;
    _timer3 = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      for (int i=0; i<_farmRows.length; i++) {
        js.context.callMethod('getMineInfo', [i.toString(), _farmRows[i].poolAddress, _farmRows[i].depositLpToken, _farmRows[i].mineLpToken]);
      }
    });*/
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

  _getFarm2Data() async {
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
