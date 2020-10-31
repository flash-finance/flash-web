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
  String _account = '';
  bool _layoutFlag = false;
  bool tronFlag = false;
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
          _topWidget(context),
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
          SizedBox(height: ScreenUtil().setHeight(30)),
          Expanded(
            child: _bodyWidget(context),
          ),
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
                      'Flash  Farm',
                      style: GoogleFonts.lato(
                        fontSize: ScreenUtil().setSp(40),
                        color: MyColors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                    child: Text(
                      '${S.of(context).aboutTips02}',
                      style: GoogleFonts.lato(fontSize: ScreenUtil().setSp(22), color: MyColors.white),
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
        itemCount: _farmRows.length,
        itemBuilder: (context, index) {
          return _bizWidget(context, _farmRows[index], index);
        },
      ),
    );
  }

  Widget _bizWidget(BuildContext context, FarmRow item, int index) {
    return Container(
      child: Column(
        children: <Widget>[
          !_layoutFlag ? _oneWidget(context, item, index) : (_layoutIndex == index ? _twoWidget(context, item, index) : _oneWidget(context, item, index)),
          SizedBox(height: ScreenUtil().setHeight(10)),
          SizedBox(height: index == _farmRows.length - 1 ? ScreenUtil().setHeight(30) : ScreenUtil().setHeight(0)),
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

  Widget _twoWidget(BuildContext context, FarmRow item, int index) {
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

  Widget _topBizWidget(BuildContext context, FarmRow item, int index, int type) {
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
                child: Image.network(
                  '${item.pic1}',
                  width: ScreenUtil().setWidth(55),
                  height: ScreenUtil().setWidth(55),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(20)),
            Container(
              width: ScreenUtil().setWidth(100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${item.depositTokenName}',
                      style: GoogleFonts.lato(
                        fontSize: ScreenUtil().setSp(26),
                        color: MyColors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(8)),
                  Container(
                    child: Text(
                      item.poolType == 1 ? 'Token': 'LP Token',
                      style: GoogleFonts.lato(
                        fontSize: ScreenUtil().setSp(20),
                        color: MyColors.grey800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(20)),
            Container(
              width: ScreenUtil().setWidth(200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${item.depositTokenValue.toStringAsFixed(0)}',
                      style: GoogleFonts.lato(
                        fontSize: ScreenUtil().setSp(26),
                        color: MyColors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(8)),
                  Container(
                    child: Text(
                      '${S.of(context).farmStakedWap}',
                      style: GoogleFonts.lato(
                        fontSize: ScreenUtil().setSp(20),
                        color: MyColors.grey800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(20)),
            Container(
              width: ScreenUtil().setWidth(100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${(item.apy * 100).toStringAsFixed(2)}%',
                      style: GoogleFonts.lato(
                        fontSize: ScreenUtil().setSp(26),
                        color: MyColors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  Container(
                    child: Text(
                      '${S.of(context).farmApy}',
                      style: GoogleFonts.lato(
                        fontSize: ScreenUtil().setSp(20),
                        color: MyColors.grey800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(15)),
            Expanded(
              child: InkWell(
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
            ),
            SizedBox(width: ScreenUtil().setWidth(20)),
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
                          color: MyColors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey[200]), borderRadius: BorderRadius.all(Radius.circular(25.0))),
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
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), top: ScreenUtil().setHeight(10), bottom: ScreenUtil().setHeight(10), right: ScreenUtil().setWidth(40)),
                      backgroundColor: MyColors.blue500,
                          label: !_depositLoadFlag ? Container(
                            child: Text(
                              _depositEnoughFlag ? '${S.of(context).farmDeposit}' : '${S.of(context).swapTokenNotEnough}',
                              style: GoogleFonts.lato(
                                letterSpacing: 0.5,
                                color: MyColors.white,
                                fontSize: ScreenUtil().setSp(24),
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
                          color: MyColors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey[200]), borderRadius: BorderRadius.all(Radius.circular(25.0))),
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
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), top: ScreenUtil().setHeight(10), bottom: ScreenUtil().setHeight(10), right: ScreenUtil().setWidth(40)),
                          backgroundColor: MyColors.blue500,
                          label: !_withdrawLoadFlag ? Container(
                            child: Text(
                              _withdrawEnoughFlag ? '${S.of(context).farmWithdraw}' : '${S.of(context).swapTokenNotEnough}',
                              style: GoogleFonts.lato(
                                letterSpacing: 0.5,
                                color: MyColors.white,
                                fontSize: ScreenUtil().setSp(24),
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
            ],
          ),
          SizedBox(height: 20),
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
                          color: MyColors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    InkWell(
                      onTap: () {
                        js.context['setAllowance4Farm']=setAllowance4Farm;
                        js.context['setStake4Farm']=setStake4Farm;
                        js.context['setHash4Farm']=setHash4Farm;
                        js.context['setError4Farm']=setError4Farm;

                        if(_tokenAmountMap[_key] == null ||  _tokenAmountMap[_key].harvestedAmount == null) {
                          return;
                        }

                        double value = double.parse(_tokenAmountMap[_key].harvestedAmount);
                        if (value <= 0) {
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
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), top: ScreenUtil().setHeight(10), bottom: ScreenUtil().setHeight(10), right: ScreenUtil().setWidth(40)),
                          backgroundColor: MyColors.blue500,
                          label: !_harvestLoadFlag ? Container(
                            child: Text(
                              '${S.of(context).farmHarvest}',
                              style: GoogleFonts.lato(
                                letterSpacing: 0.5,
                                color: MyColors.white,
                                fontSize: ScreenUtil().setSp(24),
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
            ],
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
                Application.router.navigateTo(context, 'wap/swap', transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.broken_image,
                color: _homeIndex == 0 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title: Text(
                '${S.of(context).actionTitle1}',
                style: GoogleFonts.lato(
                  fontSize: ScreenUtil().setSp(32),
                  color: _homeIndex == 1 ? Colors.black : Colors.grey[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  CommonProvider.changeHomeIndex(1);
                });
                Application.router.navigateTo(context, 'wap/farm', transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.assistant,
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
                _account == '' ? '${S.of(context).actionTitle4}' : _account.substring(0, 4) + '...' + _account.substring(_account.length - 4, _account.length),
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
                Navigator.pop(context);
                Util.showToast(S.of(context).swapSuccess);
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
    tronFlag = js.context.hasProperty('tronWeb');
    if (tronFlag) {
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
