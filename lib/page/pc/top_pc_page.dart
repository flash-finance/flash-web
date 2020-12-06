import 'package:flash_web/common/color.dart';
import 'package:flash_web/config/service_config.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/provider/common_provider.dart';
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
    bool langType = Provider.of<IndexProvider>(context, listen: true).langType;
    var screenSize = MediaQuery.of(context).size;
    return PreferredSize(
      preferredSize: Size(screenSize.width, 1500),
      child: Container(
        color: Theme.of(context).bottomAppBarColor.withOpacity(widget.opacity),
        child: Padding(
          padding: EdgeInsets.only(left: 40, top: 0, right: 40),
          child: Row(
            children: <Widget>[
              Opacity(
                opacity: 0.8,
                child: Container(
                  child: Image.asset('images/logo.png', fit: BoxFit.contain, width: 80, height: 80),
                ),
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
                    SizedBox(width: 10),
                    _actionAccountWidget(context),
                    SizedBox(width: 10),
                    _actionLangWidget(context),
                    SizedBox(width: 20),
                    Container(
                      height: 50.0,
                      width: 50.0,
                      child: Opacity(
                        opacity: 0.9,
                        child: Center(
                          child: Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: IconButton(
                              icon: Icon(IconData(0xe8e9, fontFamily: 'ICON'), size: 23.0, color: Colors.grey[900]),
                              color: Colors.grey[900],
                              onPressed: () {
                                launch(twitter).catchError((error) {
                                  print('launch error:$error');
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                        height: 50.0,
                        width: 50.0,
                        child: Opacity(
                          opacity: 0.9,
                          child: Center(
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: IconButton(
                                icon: Icon(IconData(0xe600, fontFamily: 'ICON'), size: 20.0, color: Colors.grey[900]),
                                color: Colors.grey[900],
                                onPressed: () {
                                  launch(flashGithub).catchError((error) {
                                    print('launch error:$error');
                                  });
                                },
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
        ),
      ),
    );
  }

  Widget _actionItemWidget(BuildContext context, String name, int index) {
    bool flag = CommonProvider.homeIndex == index;
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
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              '$name',
              style: Util.textStyle4PcAppbar(
                  context, 1,
                  flag ? Colors.blue[200] : (_isHovering[index] ? Colors.blue[200] : Colors.white),
                  spacing: 0.2, size: 15),
            ),
          ),
          SizedBox(height: 5),
          Visibility(
            maintainAnimation: true,
            maintainState: true,
            maintainSize: true,
            visible: flag ? true : _isHovering[index],
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
        child: Opacity(
          opacity: 0.9,
          child: Chip(
            elevation: 1,
            padding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
            backgroundColor: Colors.white,
            label: Text(
              widget.account == '' ? '${S.of(context).actionTitle5}' : widget.account.substring(0, 4) + '...' + widget.account.substring(widget.account.length - 4, widget.account.length),
              style: Util.textStyle4PcAppbar(context, 1, Colors.black87, spacing: 0.2, size: 14),
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
          Util.showToast4Pc(S.of(context).success, timeValue: 1);
        },
        child: Container(
          margin: EdgeInsets.only(left: 15),
          child: Opacity(
            opacity: 0.9,
            child: Chip(
              elevation: 1,
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
              backgroundColor: Colors.white,
              label: Text(
                'English/中文',
                style: Util.textStyle4PcAppbar(context, 1, Colors.black87, spacing: 0.2, size: 14),
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
                          color: Colors.grey[900],
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