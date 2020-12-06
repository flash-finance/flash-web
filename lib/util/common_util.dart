import 'package:common_utils/common_utils.dart';
import 'package:flash_web/common/color.dart';
import 'package:flash_web/common/screen_utils.dart';
import 'package:flash_web/provider/index_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Util {

  static showToast(String value, {int timeValue}) {
    int times = 3;
    if (timeValue != null && timeValue > 0) {
      times = timeValue;
    }
    Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: times,
      backgroundColor: Colors.blue[500],
      textColor: Colors.white,
      fontSize: 16.0,
      webBgColor: "linear-gradient(to bottom, #1976D2, #2196F3)",
      webPosition: "center",
    );
  }

  static showToast4Pc(String value, {int timeValue}) {
    int times = 3;
    if (timeValue != null && timeValue > 0) {
      times = timeValue;
    }
    Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: times,
      backgroundColor: MyColors.blueColor1,
      textColor: Colors.white,
      fontSize: 16.0,
      webBgColor: "linear-gradient(to bottom, #003399, #003399)",
      webPosition: "center",
    );
  }

  static TextStyle textStyle4PcAppbar(BuildContext context, int type, Color color, {double spacing, double size}) {
    double letterSpacing = spacing != null ? spacing : 0.0;
    double fontSize = size != null ? size : 12.0;
    bool langType = Provider.of<IndexProvider>(context, listen: true).langType;
    return TextStyle(
      fontFamily: type == 1 ? 'SHS-R' : 'SHS-M',
      letterSpacing: langType ? letterSpacing : 0.0,
      color: color,
      fontSize: fontSize,
    );
  }

  static TextStyle textStyle4Pc(BuildContext context, int type, Color color, {double spacing, double size}) {
    double letterSpacing = spacing != null ? spacing : 0.0;
    double fontSize = size != null ? size : 12.0;
    bool langType = Provider.of<IndexProvider>(context, listen: true).langType;
    return langType ? TextStyle(
      fontFamily: type == 1 ? 'SHS-R' : 'SHS-M',
      letterSpacing: letterSpacing,
      color: color,
      fontSize: fontSize,
    ) :GoogleFonts.lato(
      letterSpacing: 0.0,
      color: color,
      fontSize: fontSize,
    );
  }

  static TextStyle textStyle4Wap(BuildContext context, int type, Color color, {double spacing, double size}) {
    double letterSpacing = spacing != null ? spacing : 0.0;
    double fontSize = size != null ? size : 23.0;
    bool langType = Provider.of<IndexProvider>(context, listen: true).langType;
    return langType ? TextStyle(
      fontFamily: type == 1 ? 'SHS-R' : 'SHS-M',
      letterSpacing: letterSpacing,
      color: color,
      fontSize: ScreenUtil().setSp(fontSize),
    ) : GoogleFonts.lato(
      letterSpacing: 0.0,
      color: color,
      fontSize: ScreenUtil().setSp(fontSize),
    );
  }

  static String removeDecimalZeroFormat(double x){
    int i = x.truncate() ;
    if(x == i){
      return i.toString();
    }
    return x.toString();
  }

  static String formatNumber4CN(double n) {
    if (n >= 10000 && n < 100000000) {
      double d = n / 10000;
      return '${formatNumberSub(d, 3)}万';
    } else if (n >= 100000000) {
      double d = n / 100000000;
      return '${formatNumberSub(d, 3)}亿';
    }
    return formatNumberSub(n, 3);
  }

  static String formatNumber(double n, position) {
    if (n >= 1000 && n < 1000000) {
      double d = n / 1000;
      return '${formatNumberSub(d, position)}K';
    } else if (n >= 1000000 && n < 1000000000) {
      double d = n / 1000000;
      return '${formatNumberSub(d, position)}M';
    } else if (n >= 1000000000) {
      double d = n / 1000000000;
      return '${formatNumberSub(d, position)}B';
    }
    return formatNumberSub(n, position);
  }

  static String formatNumberSub(double num, int position) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) < position) {
      return num.toStringAsFixed(position).substring(0, num.toString().lastIndexOf(".") + position + 1).toString();
    } else {
      return num.toString().substring(0, num.toString().lastIndexOf(".") + position + 1).toString();
    }
  }

  static String formatNum(double num,int position){
    if((num.toString().length-num.toString().lastIndexOf(".")-1)<position){
      return num.toStringAsFixed(position).substring(0,num.toString().lastIndexOf(".")+position+1).toString();
    }else{
      return num.toString().substring(0,num.toString().lastIndexOf(".")+position+1).toString();
    }
  }

  static int getDayTime(DateTime dateTime) {
    String dateStr = DateUtil.formatDateMs(dateTime.millisecondsSinceEpoch, format: DateFormats.y_mo_d);
    DateTime dt = DateUtil.getDateTime(dateStr);
    int dtInt = int.parse((dt.millisecondsSinceEpoch / 1000).toString().split('.')[0]);
    return dtInt;
  }

  static bool isEmpty(String value) {
    return value == null || value.trim() == '';
  }
}



class MyNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;

  ///允许的小数位数，-1代表不限制位数
  int digit;

  MyNumberTextInputFormatter({this.digit = -1});

  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  ///获取目前的小数位数
  static int getValueDigit(String value) {
    if (value.contains(".")) {
      return value.split(".")[1].length;
    } else {
      return -1;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if (value == "-") {
      value = "-";
      selectionIndex++;
    } else if (value != "" &&
        value != defaultDouble.toString() &&
        strToFloat(value, defaultDouble) == defaultDouble ||
        getValueDigit(value) > digit) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    return new TextEditingValue(
      text: value,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }

}