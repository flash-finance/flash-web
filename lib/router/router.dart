import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'handler.dart';

class Routes {
  static String root = '/';

  static void configure(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('error => route was not found');
      return null;
    });

    router.define('/swap', handler: swapPcHandler);
    router.define('/farm', handler: farmPcHandler);
    router.define('/lend', handler: lendPcHandler);
    router.define('/wallet', handler: walletPcHandler);
    router.define('/about', handler: aboutPcHandler);

    router.define('/wap/swap', handler: swapWapHandler);
    router.define('/wap/farm', handler: farmWapHandler);
    router.define('/wap/lend', handler: lendWapHandler);
    router.define('/wap/wallet', handler: walletWapHandler);
    router.define('/wap/about', handler: aboutWapHandler);

  }
}
