/*


import 'package:flash_web/common/color.dart';
import 'package:flash_web/common/screen_utils.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/provider/common_provider.dart';
import 'package:flash_web/provider/index_provider.dart';
import 'package:flash_web/router/application.dart';
import 'package:flash_web/util/common_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Widget appBarWidget(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
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
        scaffoldKey.currentState.openDrawer();
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
              Icons.swap_horizontal_circle,
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
            title: Text(
              '${S.of(context).actionTitle2}',
              style: GoogleFonts.lato(
                fontSize: ScreenUtil().setSp(32),
                color: _homeIndex == 2 ? Colors.black : Colors.grey[700],
              ),
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
              style: GoogleFonts.lato(
                fontSize: ScreenUtil().setSp(32),
                color: _homeIndex == 3 ? Colors.black : Colors.grey[700],
              ),
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
              style: GoogleFonts.lato(
                fontSize: ScreenUtil().setSp(32),
                color: _homeIndex == 4 ? Colors.black : Colors.grey[700],
              ),
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
              Util.showToast(S.of(context).success, timeValue: 2);
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


*/
