import 'package:flash_web/common/color.dart';
import 'package:flash_web/config/service_config.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/provider/index_provider.dart';
import 'package:flash_web/router/application.dart';
import 'package:flash_web/util/common_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TopPcPage extends StatefulWidget {
  final double opacity;
  final String account;

  TopPcPage(this.opacity, this.account);

  @override
  _TopPcPageState createState() => _TopPcPageState();
}

class _TopPcPageState extends State<TopPcPage> {
  final List _isHovering = [
    false,
    false,
    false,
    false,
    false
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return PreferredSize(
      preferredSize: Size(screenSize.width, 1500),
      child: Container(
        color: Theme.of(context).bottomAppBarColor.withOpacity(widget.opacity),
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 0, right: 20),
          child: Row(
            children: <Widget>[
              Container(
                child: Image.asset('images/logo.png', fit: BoxFit.contain, width: 80, height: 80),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _actionItemWidget(context, '${S.of(context).actionTitle0}', 0),
                    //_actionItemWidget(context, '${S.of(context).actionTitle1}', 1),
                    _actionItemWidget(context, '${S.of(context).actionTitle2}', 2),
                    _actionItemWidget(context, '${S.of(context).actionTitle3}', 3),
                    _actionItemWidget(context, '${S.of(context).actionTitle4}', 4),
                    SizedBox(width: 20),
                    _actionAccountWidget(context),
                    SizedBox(width: 20),
                    _actionLangWidget(context),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionItemWidget(BuildContext context, String name, int index) {
    return  InkWell(
      onHover: (value) {
        setState(() {
          value ? _isHovering[index] = true : _isHovering[index] = false;
        });
      },
      onTap: () {
        if (index == 0) {
          Application.router.navigateTo(context, 'swap', transition: TransitionType.fadeIn);
        } else if (index == 1) {
          Application.router.navigateTo(context, 'farm', transition: TransitionType.fadeIn);
        } else if (index == 2) {
          Application.router.navigateTo(context, 'lend', transition: TransitionType.fadeIn);
        } else if (index == 3) {
          Application.router.navigateTo(context, 'wallet', transition: TransitionType.fadeIn);
        } else if (index == 4) {
          Application.router.navigateTo(context, 'about', transition: TransitionType.fadeIn);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 60),
          Text(
            '$name',
            style: TextStyle(
              color: _isHovering[index] ? Colors.blue[200] : Colors.white,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 5),
          Visibility(
            maintainAnimation: true,
            maintainState: true,
            maintainSize: true,
            visible: _isHovering[index],
            child: Container(
              height: 2,
              width: 20,
              color: Colors.blue[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionAccountWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.account == '') {
          _showConnectWalletDialLog(context);
        }
      },
      child: Container(
        child: Chip(
          elevation: 1,
          padding: EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20),
          backgroundColor: Colors.blue[500].withOpacity(0.9),
          label: Text(
            widget.account == '' ? '${S.of(context).actionTitle5}' : widget.account.substring(0, 4) + '...' + widget.account.substring(widget.account.length - 4, widget.account.length),
            style: TextStyle(
              letterSpacing: 0.2,
              color: MyColors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionLangWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<IndexProvider>(context, listen: false).changeLangType();
        Util.showToast(S.of(context).success, timeValue: 1);
      },
      child: Container(
        margin: EdgeInsets.only(left: 15),
        child: Chip(
          elevation: 1,
          padding: EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20),
          backgroundColor: Colors.blue[500].withOpacity(0.9),
          label: Text(
            'English/中文',
            style: TextStyle(
              letterSpacing: 0.2,
              color: MyColors.white,
              fontSize: 14,
            ),
          ),
        ),
      )
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
                    '${S.of(context).connectWallet}',
                    style: GoogleFonts.lato(
                      fontSize: 18.0,
                      letterSpacing: 0.2,
                      color: MyColors.black87,
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
                        '${S.of(context).installWallet}',
                        style: GoogleFonts.lato(
                          fontSize: 14.0,
                          letterSpacing: 0.2,
                          color: Colors.grey[800],
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

}
