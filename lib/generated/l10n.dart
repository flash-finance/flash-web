// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Farm`
  String get actionTitle0 {
    return Intl.message(
      'Farm',
      name: 'actionTitle0',
      desc: '',
      args: [],
    );
  }

  /// `Swap`
  String get actionTitle1 {
    return Intl.message(
      'Swap',
      name: 'actionTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get actionTitle2 {
    return Intl.message(
      'Wallet',
      name: 'actionTitle2',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get actionTitle3 {
    return Intl.message(
      'About',
      name: 'actionTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Connect Wallet`
  String get actionTitle4 {
    return Intl.message(
      'Connect Wallet',
      name: 'actionTitle4',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get farmBalance {
    return Intl.message(
      'Balance',
      name: 'farmBalance',
      desc: '',
      args: [],
    );
  }

  /// `Deposited`
  String get farmDeposited {
    return Intl.message(
      'Deposited',
      name: 'farmDeposited',
      desc: '',
      args: [],
    );
  }

  /// `Reward`
  String get farmReward {
    return Intl.message(
      'Reward',
      name: 'farmReward',
      desc: '',
      args: [],
    );
  }

  /// `APY`
  String get farmApy {
    return Intl.message(
      'APY',
      name: 'farmApy',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get farmDeposit {
    return Intl.message(
      'Deposit',
      name: 'farmDeposit',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get farmWithdraw {
    return Intl.message(
      'Withdraw',
      name: 'farmWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `Harvest`
  String get farmHarvest {
    return Intl.message(
      'Harvest',
      name: 'farmHarvest',
      desc: '',
      args: [],
    );
  }

  /// `please enter the correct value`
  String get farmTips1 {
    return Intl.message(
      'please enter the correct value',
      name: 'farmTips1',
      desc: '',
      args: [],
    );
  }

  /// `coming soon`
  String get swapTips1 {
    return Intl.message(
      'coming soon',
      name: 'swapTips1',
      desc: '',
      args: [],
    );
  }

  /// `digital wallet:  open source, security, convenience`
  String get walletTips1 {
    return Intl.message(
      'digital wallet:  open source, security, convenience',
      name: 'walletTips1',
      desc: '',
      args: [],
    );
  }

  /// `in the ecosystem of TRON DeFi, the team of Flash Finance hopes to make a series of products: mining, vault, trading, lending and digital wallet, etc.`
  String get aboutTips1 {
    return Intl.message(
      'in the ecosystem of TRON DeFi, the team of Flash Finance hopes to make a series of products: mining, vault, trading, lending and digital wallet, etc.',
      name: 'aboutTips1',
      desc: '',
      args: [],
    );
  }

  /// `the team is committed to the rapid development of products. currently, no private placement or currency issuance`
  String get aboutTips2 {
    return Intl.message(
      'the team is committed to the rapid development of products. currently, no private placement or currency issuance',
      name: 'aboutTips2',
      desc: '',
      args: [],
    );
  }

  /// `mining:  directly to the platform of SUN,  no handling fees`
  String get aboutTips3 {
    return Intl.message(
      'mining:  directly to the platform of SUN,  no handling fees',
      name: 'aboutTips3',
      desc: '',
      args: [],
    );
  }

  /// `trading:  directly to the platform of JustSwap,  0.1% handling fees`
  String get aboutTips4 {
    return Intl.message(
      'trading:  directly to the platform of JustSwap,  0.1% handling fees',
      name: 'aboutTips4',
      desc: '',
      args: [],
    );
  }

  /// `to do: mining, vault, trading, lending, digital wallet, etc.`
  String get aboutTips5 {
    return Intl.message(
      'to do: mining, vault, trading, lending, digital wallet, etc.',
      name: 'aboutTips5',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}