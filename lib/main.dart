import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flash_web/page/pc/swap_pc_page.dart';
import 'package:flash_web/page/wap/swap_wap_page.dart';
import 'package:flash_web/provider/index_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'common/platform.dart';
import 'generated/l10n.dart';
import 'router/application.dart';
import 'router/router.dart';

void main() {
  final router = FluroRouter();
  Routes.configure(router);
  Application.router = router;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => IndexProvider()..init()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final isNotMobile = !PlatformDetector().isMobile();
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) {
        return ThemeData(
          primarySwatch: Colors.blueGrey,
          backgroundColor: Colors.white,
          cardColor: Colors.white,
          primaryTextTheme: TextTheme(
            button: TextStyle(
              color: Colors.blueGrey,
              decorationColor: Colors.blueGrey[300],
            ),
            subtitle2: TextStyle(
              color: Colors.blueGrey[900],
            ),
            subtitle1: TextStyle(
              color: Colors.black,
            ),
            headline1: TextStyle(color: Colors.blueGrey[800]),
          ),
          bottomAppBarColor: Colors.blueGrey[800],
          iconTheme: IconThemeData(color: Colors.blueGrey),
          brightness: brightness,
        );
      },
      themedWidgetBuilder: (context, data) => MaterialApp(
        title: 'Flash Finance',
        theme: data,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Application.router.generator,
        home: isNotMobile ? SwapPcPage() : SwapWapPage(),
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        localeListResolutionCallback: (locales, supportedLocales) {
          print(locales);
          return;
        },
      ),
    );
  }
}
