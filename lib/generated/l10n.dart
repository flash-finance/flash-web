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

  /// `Swap`
  String get actionTitle0 {
    return Intl.message(
      'Swap',
      name: 'actionTitle0',
      desc: '',
      args: [],
    );
  }

  /// `Farm`
  String get actionTitle1 {
    return Intl.message(
      'Farm',
      name: 'actionTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Lend`
  String get actionTitle2 {
    return Intl.message(
      'Lend',
      name: 'actionTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get actionTitle3 {
    return Intl.message(
      'Wallet',
      name: 'actionTitle3',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get actionTitle4 {
    return Intl.message(
      'About',
      name: 'actionTitle4',
      desc: '',
      args: [],
    );
  }

  /// `Connect Wallet`
  String get actionTitle5 {
    return Intl.message(
      'Connect Wallet',
      name: 'actionTitle5',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Please login with TronLink`
  String get connectWallet {
    return Intl.message(
      'Please login with TronLink',
      name: 'connectWallet',
      desc: '',
      args: [],
    );
  }

  /// `Haven't installed TronLink yet? Click here>>`
  String get installWallet {
    return Intl.message(
      'Haven\'t installed TronLink yet? Click here>>',
      name: 'installWallet',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get swapSend {
    return Intl.message(
      'Send',
      name: 'swapSend',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get swapReceive {
    return Intl.message(
      'Receive',
      name: 'swapReceive',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get swapBalance {
    return Intl.message(
      'Balance',
      name: 'swapBalance',
      desc: '',
      args: [],
    );
  }

  /// `Pooled Tokens`
  String get swapPooledTokens {
    return Intl.message(
      'Pooled Tokens',
      name: 'swapPooledTokens',
      desc: '',
      args: [],
    );
  }

  /// `Swap`
  String get swapSwap {
    return Intl.message(
      'Swap',
      name: 'swapSwap',
      desc: '',
      args: [],
    );
  }

  /// `Token Name`
  String get swapTokenName {
    return Intl.message(
      'Token Name',
      name: 'swapTokenName',
      desc: '',
      args: [],
    );
  }

  /// `Price (USD)`
  String get swapTokenPrice {
    return Intl.message(
      'Price (USD)',
      name: 'swapTokenPrice',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get swapTokenBalance {
    return Intl.message(
      'Balance',
      name: 'swapTokenBalance',
      desc: '',
      args: [],
    );
  }

  /// `Pool`
  String get swapPool {
    return Intl.message(
      'Pool',
      name: 'swapPool',
      desc: '',
      args: [],
    );
  }

  /// `Total Liquidity`
  String get swapTotalLiquidity {
    return Intl.message(
      'Total Liquidity',
      name: 'swapTotalLiquidity',
      desc: '',
      args: [],
    );
  }

  /// `Token`
  String get swapToken {
    return Intl.message(
      'Token',
      name: 'swapToken',
      desc: '',
      args: [],
    );
  }

  /// `Token Not Enough`
  String get swapTokenNotEnough {
    return Intl.message(
      'Token Not Enough',
      name: 'swapTokenNotEnough',
      desc: '',
      args: [],
    );
  }

  /// `Staked`
  String get farmStaked {
    return Intl.message(
      'Staked',
      name: 'farmStaked',
      desc: '',
      args: [],
    );
  }

  /// `Deadline`
  String get farmDeadline {
    return Intl.message(
      'Deadline',
      name: 'farmDeadline',
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

  /// `Staked  USD`
  String get farmStakedWap {
    return Intl.message(
      'Staked  USD',
      name: 'farmStakedWap',
      desc: '',
      args: [],
    );
  }

  /// `trading:  directly to the platform of JustSwap`
  String get aboutTips01 {
    return Intl.message(
      'trading:  directly to the platform of JustSwap',
      name: 'aboutTips01',
      desc: '',
      args: [],
    );
  }

  /// `mining:  directly to the platform of SUN`
  String get aboutTips02 {
    return Intl.message(
      'mining:  directly to the platform of SUN',
      name: 'aboutTips02',
      desc: '',
      args: [],
    );
  }

  /// `lending:  open source, security, convenience`
  String get aboutTips03 {
    return Intl.message(
      'lending:  open source, security, convenience',
      name: 'aboutTips03',
      desc: '',
      args: [],
    );
  }

  /// `lending:  open source, security, convenience`
  String get aboutTips04 {
    return Intl.message(
      'lending:  open source, security, convenience',
      name: 'aboutTips04',
      desc: '',
      args: [],
    );
  }

  /// `talk is cheap.  show me the code`
  String get aboutTips05 {
    return Intl.message(
      'talk is cheap.  show me the code',
      name: 'aboutTips05',
      desc: '',
      args: [],
    );
  }

  /// `github:  https://github.com/flash-finance`
  String get aboutTips06 {
    return Intl.message(
      'github:  https://github.com/flash-finance',
      name: 'aboutTips06',
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

  /// `mining:  directly to the platform of SUN`
  String get aboutTips3 {
    return Intl.message(
      'mining:  directly to the platform of SUN',
      name: 'aboutTips3',
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