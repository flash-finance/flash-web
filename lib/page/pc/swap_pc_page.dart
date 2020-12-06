import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flash_web/common/color.dart';
import 'package:flash_web/config/service_config.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/model/swap_model.dart';
import 'package:flash_web/provider/common_provider.dart';
import 'package:flash_web/provider/index_provider.dart';
import 'package:flash_web/service/method_service.dart';
import 'package:flash_web/util/common_util.dart';
import 'package:flash_web/util/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'dart:js' as js;

import 'common/bottom_pc_page.dart';
import 'common/header_pc_page.dart';
import 'common/top_pc_page.dart';

class SwapPcPage extends StatefulWidget {
  @override
  _SwapPcPageState createState() => _SwapPcPageState();
}

class _SwapPcPageState extends State<SwapPcPage> {
  bool _tronFlag = false;
  String _account = '';
  String _leftKey = '';
  String _rightKey = '';
  Timer _timer0;
  Timer _timer1;
  Timer _timer2;

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
    if (mounted) {
      setState(() {
        CommonProvider.changeHomeIndex(0);
      });
    }

    Provider.of<IndexProvider>(context, listen: false).init();
    _reloadSwapData();
    _reloadAccount();
    _reloadTokenBalance();
  }

  @override
  void dispose() {
    print('SwapPcPage dispose');
    if (_timer0 != null) {
      if (_timer0.isActive) {
        _timer0.cancel();
      }
    }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocalScreenUtil.instance = LocalScreenUtil.getInstance()..init(context);
    bool langType = Provider.of<IndexProvider>(context, listen: true).langType;

    _leftSwapAmountController =  TextEditingController.fromValue(TextEditingValue(text: _leftSwapAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _leftSwapAmount.length))));
    _rightSwapAmountController =  TextEditingController.fromValue(TextEditingValue(text: _rightSwapAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _rightSwapAmount.length))));

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
          )
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
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Flash  Swap',
                      style: Util.textStyle4Pc(context, 1, Colors.white, spacing: 0.0, size: 30),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      '${S.of(context).swapTips01}',
                      style: Util.textStyle4Pc(context, 1, Colors.grey[300], spacing: 0.0, size: 15),
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
        padding: EdgeInsets.only(left: 80, top: 30, right: 80, bottom: 60),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            _dataWidget(context),
            SizedBox(height: 60),
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
                    '${S.of(context).swapSend}',
                    style: Util.textStyle4Pc(context, 1, Colors.black87, spacing: 0.0, size: 16),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 2),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${S.of(context).swapBalance}:  ',
                          style: Util.textStyle4Pc(context, 1, Colors.grey[700], spacing: 0.0, size: 16),
                        ),
                        TextSpan(
                          text: '${Util.formatNum(double.parse(_leftBalanceAmount), 4)}',
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
                            alignment: Alignment.center,
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
                            child: Icon(Icons.arrow_drop_down, size: 23, color: Colors.black54),
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
                        color: MyColors.black87,
                        fontSize: 16,
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
                    '1  ${_swapRows[_leftSelectIndex].swapTokenName}  ≈  ${Util.formatNum(double.parse(_leftPrice), 4)}  ${_swapRows[_rightSelectIndex].swapTokenName}',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 0, right: 3),
                  child: Text(
                    '≈  ${Util.formatNum(_swapRows[_leftSelectIndex].swapTokenPrice2, 4)}  USD',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: MyColors.grey700,
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
                      color: MyColors.blueColor1.withOpacity(0.86),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.only(left: 12, top: 7, bottom: 7, right: 12),
                    child: Text(
                      '${S.of(context).swapPooledTokens}',
                      style: Util.textStyle4Pc(context, 1, Colors.white, spacing: 0.0, size: 12),
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
            width: 50,
            height: 50,
            color: MyColors.white,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 30),
            child: Icon(
              Icons.sync,
              size: 25,
              color: Colors.grey[700],
            ),
          )
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
                    '${S.of(context).swapReceive}',
                    style: Util.textStyle4Pc(context, 1, Colors.black87, spacing: 0.0, size: 16),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 2),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${S.of(context).swapBalance}:  ',
                          style: Util.textStyle4Pc(context, 1, Colors.grey[700], spacing: 0.0, size: 16),
                        ),
                        TextSpan(
                          text: '${Util.formatNum(double.parse(_rightBalanceAmount), 4)}',
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
                            alignment: Alignment.center,
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
                            child: Icon(Icons.arrow_drop_down, size: 23, color: Colors.black54),
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
                        color: MyColors.black87,
                        fontSize: 16,
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
                    '1  ${_swapRows[_rightSelectIndex].swapTokenName}  ≈  ${Util.formatNum(double.parse(_rightPrice), 4)}  ${_swapRows[_leftSelectIndex].swapTokenName}',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    '≈  ${Util.formatNum(_swapRows[_rightSelectIndex].swapTokenPrice2, 4)}  USD',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: MyColors.grey700,
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
                    padding: EdgeInsets.only(left: 12, top: 7, bottom: 7, right: 12),
                    child: Text(
                      '${S.of(context).swapPooledTokens}',
                      style: Util.textStyle4Pc(context, 1, Colors.white, spacing: 0.0, size: 12),
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
                '${S.of(context).swapTokenName}',
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
                '${S.of(context).swapTokenPrice}',
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
                  '${S.of(context).swapTokenBalance}',
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
    String balanceAmount = '0.0000';
    String _key = '$_account+${item.swapTokenAddress}';
    if (item.swapTokenPrecision > 0 && _balanceMap[_key] != null) {
      String temp = (Decimal.tryParse(_balanceMap[_key])/Decimal.fromInt(10).pow(item.swapTokenPrecision)).toString();
      balanceAmount = Util.formatNum(double.parse(temp), 4);
    }
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
                '${Util.formatNum(item.swapTokenPrice2, 6)}',
                style: TextStyle(
                  color: index != _rightSelectIndex  ? Colors.black87 :Colors.black26,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ) : Text(
                '${Util.formatNum(item.swapTokenPrice2, 6)}',
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
                        '${_swapRows[_leftSelectIndex].swapTokenName}/${_swapRows[_rightSelectIndex].swapTokenName}',
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
                        ' ${S.of(context).swapPool}',
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
                        '${S.of(context).swapTotalLiquidity}',
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
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              _swapRows[_leftSelectIndex].swapTokenType == 2 ? '${_swapRows[_leftSelectIndex].totalLiquidity.toStringAsFixed(0)}'
                                  : '${_swapRows[_rightSelectIndex].totalLiquidity.toStringAsFixed(0)}',
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
                        '${S.of(context).swapToken}',
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
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              _swapRows[_leftSelectIndex].swapTokenType == 2 ? '${_swapRows[_leftSelectIndex].swapTokenAmount.toStringAsFixed(0)}'
                                  : '${_swapRows[_rightSelectIndex].baseTokenAmount.toStringAsFixed(0)}',
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
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              _swapRows[_leftSelectIndex].swapTokenType == 2 ? '${_swapRows[_leftSelectIndex].baseTokenAmount.toStringAsFixed(0)}'
                                  : '${_swapRows[_rightSelectIndex].swapTokenAmount.toStringAsFixed(0)}',
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
                              '${_swapRows[_leftSelectIndex].swapTokenName}/${_swapRows[_leftSelectIndex].baseTokenName}',
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
                              '  ${S.of(context).swapPool}',
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
                              '${S.of(context).swapTotalLiquidity}',
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
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    '${_swapRows[_leftSelectIndex].totalLiquidity.toStringAsFixed(0)}',
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
                              '${S.of(context).swapToken}',
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
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    '${_swapRows[_leftSelectIndex].swapTokenAmount.toStringAsFixed(0)}',
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
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    '${_swapRows[_leftSelectIndex].baseTokenAmount.toStringAsFixed(0)}',
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
                              '${_swapRows[_rightSelectIndex].baseTokenName}/${_swapRows[_rightSelectIndex].swapTokenName}',
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
                              ' ${S.of(context).swapPool}',
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
                              '${S.of(context).swapTotalLiquidity}',
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
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    '${_swapRows[_rightSelectIndex].totalLiquidity.toStringAsFixed(0)}',
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
                              '${S.of(context).swapToken}',
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
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    '${_swapRows[_rightSelectIndex].baseTokenAmount.toStringAsFixed(0)}',
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
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    '${_swapRows[_rightSelectIndex].swapTokenAmount.toStringAsFixed(0)}',
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
          padding: _swapFlag ? EdgeInsets.only(left: 55, top: 15, right: 55, bottom: 15) : EdgeInsets.only(left: 40, top: 15, right: 40, bottom: 15),
          backgroundColor: MyColors.blueColor1.withOpacity(0.86),
          label: !_loadFlag ? Container(
            child: Text(
              _swapFlag ? '${S.of(context).swapSwap}' : '${S.of(context).swapTokenNotEnough}',
              style: Util.textStyle4Pc(context, 1, Colors.white, spacing: _swapFlag ? 0.7 : 0.2, size: 15),
            ),
          ) : Container(
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
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
    _timer2 = Timer.periodic(Duration(milliseconds: 2000), (timer) async {
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
    Util.showToast4Pc(S.of(context).success);
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
    Util.showToast4Pc(S.of(context).success);
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
    Util.showToast4Pc(S.of(context).success);
    for (int i = 0; i < 3; i++) {
      await Future.delayed(Duration(milliseconds: 2000), (){
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
    Util.showToast4Pc('${msg.toString()}');
    setState(() {
      _loadFlag = false;
    });
  }

}
