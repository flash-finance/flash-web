import 'package:flash_web/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class IndexProvider with ChangeNotifier {

  void init() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getInt(_langTypeKey) != null) {
        bool temp = true;
        if (prefs.getBool(_langTypeKey) != null) {
          temp = prefs.getBool(_langTypeKey);
        }
        _langType = temp;
      }
      if (_langType) {
        S.load(Locale('zh', ''));
      } else {
        S.load(Locale('en', ''));
      }
      notifyListeners();
    });
  }



  bool _tronFlag = false;

  bool get tronFlag => _tronFlag;

  String _account = '';

  String get account => _account;

  void changeAccount(String value) {
    _account = value;
    notifyListeners();
  }

  bool _langType = true;

  bool get langType => _langType;

  String _langTypeKey =  'langTypeKey';

  changeLangType() async {
    _langType = !_langType;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_langTypeKey, _langType);
    if (_langType) {
      S.load(Locale('zh', ''));
    } else {
      S.load(Locale('en', ''));
    }
    notifyListeners();
  }

}
