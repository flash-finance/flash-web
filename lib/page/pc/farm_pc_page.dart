import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:flash_web/common/color.dart';
import 'package:flash_web/config/service_config.dart';
import 'package:flash_web/generated/l10n.dart';
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
  String _account = '';
  bool _layoutFlag = false;
  bool _tronFlag = false;
  Timer _timer1;
  Timer _timer2;
  Timer _timer3;
  String _toDepositAmount = '0.00';
  String _toWithdrawAmount = '0.00';
  String _toHarvestAmount = '0.00';

  String _toDepositValue = '0.00';
  String _toWithdrawValue = '0.00';
  String _toHarvestValue = '0.00';


  TextEditingController _toDepositAmountController;
  TextEditingController _toWithdrawAmountController;
  TextEditingController _toHarvestAmountController;

  bool _depositLoadFlag = false;
  bool _withdrawLoadFlag = false;
  bool _harvestLoadFlag = false;

  bool _depositEnoughFlag = true;
  bool _withdrawEnoughFlag = true;

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
    _reloadAccount();
    _reloadTokenAmount();
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
          _topWidget(context),
          SizedBox(height: 10),
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
                      'Flash  Farm',
                      style: GoogleFonts.lato(
                        fontSize: 30,
                        color: MyColors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      '${S.of(context).aboutTips02}',
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

  Widget _bizWidget(BuildContext context) {
    return Container(
      color: MyColors.white,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _farmRows.length,
        itemBuilder: (context, index) {
          return _bizSubWidget(context, _farmRows[index], index);
        },
      ),
    );
  }

  Widget _bizSubWidget(BuildContext context, FarmRow item, int index) {
    return Container(
      child: Column(
        children: <Widget>[
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
    String _key = '$_account+${item.depositTokenAddress}';
    String balanceAmount = '0.00';
    String depositedAmount = '0.00';
    String harvestedAmount = '0.00';
    if(_tokenAmountMap[_key] != null &&  _tokenAmountMap[_key].balanceAmount != null) {
      String temp = _tokenAmountMap[_key].balanceAmount;
      balanceAmount =(Decimal.tryParse(temp)/Decimal.fromInt(10).pow(item.depositTokenDecimal)).toStringAsFixed(3);
    }
    if(_tokenAmountMap[_key] != null &&  _tokenAmountMap[_key].depositedAmount != null) {
      String temp = _tokenAmountMap[_key].depositedAmount;
      depositedAmount = (Decimal.tryParse(temp)/Decimal.fromInt(10).pow(item.depositTokenDecimal)).toStringAsFixed(3);
    }
    if(_tokenAmountMap[_key] != null &&  _tokenAmountMap[_key].depositedAmount != null) {
      String temp = _tokenAmountMap[_key].harvestedAmount;
      harvestedAmount = (Decimal.tryParse(temp)/Decimal.fromInt(10).pow(item.mineTokenDecimal)).toStringAsFixed(4);
    }

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
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [MyNumberTextInputFormatter(digit:3)],
                        onChanged: (String value) {
                          if (value != null && value != '') {
                            _toDepositAmount = value;
                            _toDepositValue = (Decimal.tryParse(_toDepositAmount) * Decimal.fromInt(10).pow(item.depositTokenDecimal)).toStringAsFixed(0);

                            if(_tokenAmountMap[_key] != null &&  _tokenAmountMap[_key].balanceAmount != null) {
                              double value1 = double.parse(_toDepositValue);
                              String temp = _tokenAmountMap[_key].balanceAmount;
                              double value2 = double.parse(temp);
                              if (value1 > value2) {
                                _depositEnoughFlag = false;
                              } else {
                                _depositEnoughFlag = true;
                              }
                            }

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
                    js.context['setAllowance4Farm']=setAllowance4Farm;
                    js.context['setStake4Farm']=setStake4Farm;
                    js.context['setHash4Farm']=setHash4Farm;
                    js.context['setError4Farm']=setError4Farm;

                    if(_tokenAmountMap[_key] == null ||  _tokenAmountMap[_key].balanceAmount == null) {
                      return;
                    }

                    if (_toDepositValue == '' ||  _tokenAmountMap[_key].balanceAmount == '') {
                      return;
                    }

                    double value1 =  Decimal.tryParse(_toDepositValue).toDouble();
                    if (value1 <= 0) {
                      return;
                    }
                    double value2 = double.parse(_tokenAmountMap[_key].balanceAmount);
                    if (value1 > value2) {
                      return;
                    }
                    if (_account != '' && item.depositTokenType == 2 && _depositEnoughFlag) {
                      setState(() {
                        _depositLoadFlag = true;
                      });
                      js.context.callMethod('allowance4Farm', [item.depositTokenType, _toDepositValue, _account, item.depositTokenAddress, item.poolAddress]);
                    } else if (_account != '' && item.depositTokenType == 1 && _depositEnoughFlag){
                      setState(() {
                        _depositLoadFlag = true;
                      });
                      js.context.callMethod('stake4Farm', [item.depositTokenType, _toDepositValue, item.poolAddress, item.depositTokenAddress]);
                    }
                  },
                  child: Container(
                    color: MyColors.white,
                    child: Chip(
                      elevation: 2,
                      padding: EdgeInsets.only(left: 50, top: 15, bottom: 15, right: 50),
                      backgroundColor: MyColors.blue500,
                      label: !_depositLoadFlag ? Container(
                        child: Text(
                          _depositEnoughFlag ? '${S.of(context).farmDeposit}' : '${S.of(context).swapTokenNotEnough}',
                          style: GoogleFonts.lato(
                            letterSpacing: _depositEnoughFlag ? 0.7 : 0.2,
                            color: MyColors.white,
                            fontSize: 15,
                          ),
                        ),
                      ) : Container(
                        color: Colors.blue[500],
                        child: CupertinoActivityIndicator(),
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
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [MyNumberTextInputFormatter(digit:3)],
                        onChanged: (String value) {
                          if (value != null && value != '') {
                            _toWithdrawAmount = value;
                            _toWithdrawValue = (Decimal.tryParse(_toWithdrawAmount) * Decimal.fromInt(10).pow(item.depositTokenDecimal)).toStringAsFixed(0);

                            if(_tokenAmountMap[_key] != null &&  _tokenAmountMap[_key].depositedAmount != null) {
                              double value1 = double.parse(_toWithdrawValue);
                              String temp = _tokenAmountMap[_key].depositedAmount;
                              double value2 = double.parse(temp);
                              if (value1 > value2) {
                                _withdrawEnoughFlag = false;
                              } else {
                                _withdrawEnoughFlag = true;
                              }
                            }
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
                    js.context['setAllowance4Farm']=setAllowance4Farm;
                    js.context['setStake4Farm']=setStake4Farm;
                    js.context['setHash4Farm']=setHash4Farm;
                    js.context['setError4Farm']=setError4Farm;

                    if(_tokenAmountMap[_key] == null ||  _tokenAmountMap[_key].depositedAmount == null) {
                      return;
                    }

                    if (_toWithdrawValue == '' ||  _tokenAmountMap[_key].depositedAmount == '') {
                      return;
                    }

                    double value1 =  Decimal.tryParse(_toWithdrawValue).toDouble();
                    if (value1 <= 0) {
                      return;
                    }
                    double value2 = double.parse( _tokenAmountMap[_key].depositedAmount);

                    if (value1 > value2) {
                      return;
                    }
                    setState(() {
                      _withdrawLoadFlag = true;
                    });
                    if (_account != '' && _withdrawEnoughFlag) {
                      js.context.callMethod('withdraw4Farm', [_toWithdrawValue, item.poolAddress, item.depositTokenAddress]);
                    }
                  },
                  child: Container(
                    color: MyColors.white,
                    child: Chip(
                      elevation: 2,
                      padding: EdgeInsets.only(left: 50, top: 15, bottom: 15, right: 50),
                      backgroundColor: MyColors.blue500,
                      label: !_withdrawLoadFlag ? Container(
                        child: Text(
                          _withdrawEnoughFlag ? '${S.of(context).farmWithdraw}' : '${S.of(context).swapTokenNotEnough}',
                          style: GoogleFonts.lato(
                            letterSpacing: _withdrawEnoughFlag ? 0.7 : 0.2,
                            color: MyColors.white,
                            fontSize: 15,
                          ),
                        ),
                      ) : Container(
                        color: Colors.blue[500],
                        child: CupertinoActivityIndicator(),
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
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [MyNumberTextInputFormatter(digit:4)],
                        onChanged: (String value) {
                          if (value != null && value != '') {
                            _toHarvestAmount = value;
                            _toHarvestValue = (Decimal.tryParse(_toHarvestAmount) * Decimal.fromInt(10).pow(item.mineTokenDecimal)).toStringAsFixed(0);
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
                    js.context['setAllowance4Farm']=setAllowance4Farm;
                    js.context['setStake4Farm']=setStake4Farm;
                    js.context['setHash4Farm']=setHash4Farm;
                    js.context['setError4Farm']=setError4Farm;

                    if(_tokenAmountMap[_key] == null ||  _tokenAmountMap[_key].harvestedAmount == null) {
                      return;
                    }

                    if (_toHarvestValue == '' ||  _tokenAmountMap[_key].harvestedAmount == '') {
                      return;
                    }

                    double value1 = Decimal.tryParse(_toHarvestValue).toDouble();
                    if (value1 <= 0) {
                      return;
                    }
                    double value2 = double.parse(_tokenAmountMap[_key].harvestedAmount);
                    if (value2 <= 0) {
                      return;
                    }
                    setState(() {
                      _harvestLoadFlag = true;
                    });
                    if (_account != '') {
                      js.context.callMethod('getReward4Farm', [item.poolAddress, item.depositTokenAddress]);
                    }
                  },
                  child: Container(
                    color: MyColors.white,
                    child: Chip(
                      elevation: 2,
                      padding: EdgeInsets.only(left: 50, top: 15, bottom: 15, right: 50),
                      backgroundColor: MyColors.blue500,
                      label: !_harvestLoadFlag ? Container(
                        child: Text(
                          '${S.of(context).farmHarvest}',
                          style: GoogleFonts.lato(
                            letterSpacing: 0.5,
                            color: MyColors.white,
                            fontSize: 15,
                          ),
                        ),
                      ) :  Container(
                    color: Colors.blue[500],
                      child: CupertinoActivityIndicator(),
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

  Widget _rateWidget(BuildContext context, int type, FarmRow item, int rate) {
    double balanceAmount = 0;
    double depositedAmount = 0;
    double harvestedAmount = 0;

    String _key = '$_account+${item.depositTokenAddress}';
    if(_tokenAmountMap[_key] != null &&  _tokenAmountMap[_key].balanceAmount != null) {
      String temp = _tokenAmountMap[_key].balanceAmount;
      balanceAmount =(Decimal.tryParse(temp)/Decimal.fromInt(10).pow(item.depositTokenDecimal)).toDouble();
    }
    if(_tokenAmountMap[_key] != null &&  _tokenAmountMap[_key].depositedAmount != null) {
      String temp = _tokenAmountMap[_key].depositedAmount;
      depositedAmount = (Decimal.tryParse(temp)/Decimal.fromInt(10).pow(item.depositTokenDecimal)).toDouble();
    }
    if(_tokenAmountMap[_key] != null &&  _tokenAmountMap[_key].harvestedAmount != null) {
      String temp = _tokenAmountMap[_key].harvestedAmount;
      harvestedAmount = (Decimal.tryParse(temp)/Decimal.fromInt(10).pow(item.mineTokenDecimal)).toDouble();
    }

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
          double rateDouble = NumUtil.divide(rate, 100);
          if(_account != '') {
            double value = NumUtil.multiply(amount, rateDouble);
            setState(() {
              if (type == 1) {
                _toDepositAmount = value.toStringAsFixed(3);
                String temp = value.toStringAsFixed(item.depositTokenDecimal);
                if (rate != 100) {
                  _toDepositValue = (Decimal.tryParse(temp) * Decimal.fromInt(10).pow(item.depositTokenDecimal)).toString();
                } else {
                  _toDepositValue = _tokenAmountMap[_key].balanceAmount;
                }
              } else if (type == 2) {
                _toWithdrawAmount = value.toStringAsFixed(3);
                String temp = value.toStringAsFixed(item.depositTokenDecimal);
                if (rate != 100) {
                  _toWithdrawValue = (Decimal.tryParse(temp) * Decimal.fromInt(10).pow(item.depositTokenDecimal)).toString();
                } else {
                  _toWithdrawValue = _tokenAmountMap[_key].depositedAmount;
                }
              } else if (type == 3) {
                _toHarvestAmount = value.toStringAsFixed(4);
                String temp = value.toStringAsFixed(item.mineTokenDecimal);
                if (rate != 100) {
                  _toHarvestValue = (Decimal.tryParse(temp) * Decimal.fromInt(10).pow(item.mineTokenDecimal)).toString();
                } else {
                  _toHarvestValue = _tokenAmountMap[_key].harvestedAmount;
                }
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
              _account == '' ? '$actionTitle' : _account.substring(0, 4) + '...' + _account.substring(_account.length - 4, _account.length),
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
          } else if (index == 4 && _account == '') {
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


  FarmData _farmData;

  List<FarmRow> _farmRows = [];

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
          _farmData = respModel.data;
          if (_farmData != null && _farmData.rows != null && _farmData.rows.length > 0) {
            _farmRows = _farmData.rows;
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
          });
        }
        _getTokenAmount(1);
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

  var _tokenAmountMap = Map<String, FarmTokenAmount>();

  bool _reloadTokenAmountFlag = false;

  _reloadTokenAmount() async {
    js.context['setTokenAmount4Farm']=setTokenAmount4Farm;
    _getTokenAmount(1);
    _timer3 = Timer.periodic(Duration(milliseconds: 2000), (timer) async {
      if (_reloadTokenAmountFlag) {
        _getTokenAmount(2);
      }
    });
  }

  _getTokenAmount(int type) async {
    _reloadTokenAmountFlag = false;
    if (_account != '') {
      for (int i=0; i<_farmRows.length; i++) {
        String _key = '$_account+${_farmRows[i].depositTokenAddress}';
        if (type == 1 || _tokenAmountMap[_key] == null || _tokenAmountMap[_key].balanceAmount == null
             || _tokenAmountMap[_key].depositedAmount == null &&  _tokenAmountMap[_key].harvestedAmount == null) {
          js.context.callMethod('getAmount4Farm', [_farmRows[i].depositTokenType, _account, _farmRows[i].depositTokenAddress, _farmRows[i].poolAddress]);
        }
      }
    }
    _reloadTokenAmountFlag = true;
  }


  void setTokenAmount4Farm(tokenType, depositedToken, balanceAmount, depositedAmount, harvestedAmount) {
   //print('setAmount4Farm tokenType: $tokenType, depositedToken: $depositedToken, balanceAmount: $balanceAmount, depositedAmount:$depositedAmount, harvestedAmount: $harvestedAmount');
    try {
      double.parse(balanceAmount.toString());
      double.parse(depositedAmount.toString());
      double.parse(harvestedAmount.toString());
    } catch (e) {
      print('setAmount4Farm double.parse error');
      return;
    }
    if (_account != '') {
      String _key = '$_account+${depositedToken.toString()}';
      _tokenAmountMap[_key] = FarmTokenAmount();
      _tokenAmountMap[_key].balanceAmount = balanceAmount.toString();
      _tokenAmountMap[_key].depositedAmount = depositedAmount.toString();
      _tokenAmountMap[_key].harvestedAmount = harvestedAmount.toString();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void setAllowance4Farm(tokenType, stakeAmount, tokenAddress, poolAddress, allowanceAmount) {
    double allowanceValue = Decimal.tryParse(allowanceAmount.toString()).toDouble();
    double stakeValue= double.parse(stakeAmount.toString());
    if (stakeValue > allowanceValue) {
      js.context.callMethod('approve4Farm', [tokenType, stakeAmount, tokenAddress, poolAddress]);
    } else {
      js.context.callMethod('stake4Farm', [tokenType, stakeAmount, poolAddress, tokenAddress]);
    }
  }

  void setStake4Farm(tokenType, stakeAmount, poolAddress, tokenAddress) {
    js.context.callMethod('stake4Farm', [tokenType, stakeAmount, poolAddress, tokenAddress]);
  }


  void setHash4Farm(type, poolAddress, tokenAddress, hash) async {
    Util.showToast(S.of(context).swapSuccess);
    for (int i = 0; i < 3; i++) {
      await Future.delayed(Duration(milliseconds: 2000), (){
        if (tokenAddress.toString() != 'TRX') {
          js.context.callMethod('getAmount4Farm', [2, _account, tokenAddress, poolAddress]);
        } else {
          js.context.callMethod('getAmount4Farm', [1, _account, tokenAddress, poolAddress]);
        }
        if (i == 0) {
          setState(() {
            if (type == 1) {
              _depositLoadFlag = false;
              _toDepositAmount = '';
              _toDepositValue = '';
            } else if (type == 2) {
              _withdrawLoadFlag = false;
              _toWithdrawAmount = '';
              _toWithdrawValue = '';
            } else if (type == 3) {
              _harvestLoadFlag = false;
              _toHarvestAmount = '';
              _toHarvestValue = '';
            }
          });
        }
      });
    }
  }

  void setError4Farm(msg) {
    print('setError4Farm: ${msg.toString()}');
    setState(() {
      _depositLoadFlag = false;
      _withdrawLoadFlag = false;
      _harvestLoadFlag = false;
    });
  }

}
