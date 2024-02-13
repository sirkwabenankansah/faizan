import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/api/responses/settings_response.dart';
import 'package:flutter_kundol/blocs/auth/auth_bloc.dart';
import 'package:flutter_kundol/blocs/language/language_bloc.dart';
import 'package:flutter_kundol/blocs/currency/currency_bloc.dart';
import 'package:flutter_kundol/blocs/server_settings/server_settings_bloc.dart';
import 'package:flutter_kundol/constants/app_data.dart';
import 'package:flutter_kundol/models/currency_date.dart';
import 'package:flutter_kundol/models/language_data.dart';
import 'package:flutter_kundol/models/user.dart';
import 'package:flutter_kundol/tweaks/shared_pref_service.dart';

import '../main_screen.dart';
//TODO: need to change splash screen types.
class SplashScreen extends StatefulWidget {
 // const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ServerSettingsBloc serverSettingsBloc;

  @override
  void initState() {
    super.initState();

    checkIfUserLoggedIn();

    // ignore: close_sinks
    serverSettingsBloc = BlocProvider.of<ServerSettingsBloc>(context);
    serverSettingsBloc.add(const GetServerSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServerSettingsBloc, ServerSettingsState>(
      listener: (context, state) {
        if (state is ServerSettingsLoaded) {
          AppData.settingsResponse = state.settingsResponse;

          AppData.settingsResponse?.setKeyValue(SettingsResponse.HOME_STYLE, AppData.settingsResponse!.getKeyValue(SettingsResponse.HOME_STYLE).replaceAll(RegExp(r'[^0-9]'),''));
          AppData.settingsResponse?.setKeyValue(SettingsResponse.CATEGORY_STYLE, AppData.settingsResponse!.getKeyValue(SettingsResponse.CATEGORY_STYLE).replaceAll(RegExp(r'[^0-9]'),''));
          AppData.settingsResponse?.setKeyValue(SettingsResponse.BANNER_STYLE, AppData.settingsResponse!.getKeyValue(SettingsResponse.BANNER_STYLE).replaceAll(RegExp(r'[^0-9]'),''));
          AppData.settingsResponse?.setKeyValue(SettingsResponse.CARD_STYLE, AppData.settingsResponse!.getKeyValue(SettingsResponse.CARD_STYLE).replaceAll(RegExp(r'[^0-9]'),''));

          CurrencyData currencyData = CurrencyData();

          currencyData.title = AppData.settingsResponse!.getKeyValue(SettingsResponse.CURRENCY_CODE).trim();
          currencyData.currencyId = int.parse(AppData.settingsResponse!.getKeyValue(SettingsResponse.CURRENCY_ID).toString());
          currencyData.code = AppData.settingsResponse!.getKeyValue(SettingsResponse.CURRENCY_SYMBOL).trim();

          BlocProvider.of<CurrencyBloc>(context).add(CurrencyLoadServer(currencyData));

          LanguageData languageData = LanguageData();

          languageData.languageName = AppData.settingsResponse?.getKeyValue(SettingsResponse.LANGUAGE_CODE).toUpperCase().trim();
          languageData.id = int.parse(AppData.settingsResponse!.getKeyValue(SettingsResponse.LANGUAGE_ID).toString());
          languageData.code = AppData.settingsResponse?.getKeyValue(SettingsResponse.LANGUAGE_CODE).toLowerCase().trim();

          BlocProvider.of<LanguageBloc>(context).add(LanguageLoadServer(languageData));

          Future.microtask(() => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen())));
        } else if (state is ServerSettingsError) {
          showSnackbar(context, state.error);
        }
      },
      child: ScreenUi(),
    );
  }

  void showSnackbar(context, String error) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(error),
          duration: const Duration(days: 1),
        ))
        .closed
        .then((reason) {
      if (reason == SnackBarClosedReason.swipe) showSnackbar(context, error);
    });
  }

  Future<void> checkIfUserLoggedIn() async {
    final sharedPrefService = await SharedPreferencesService.instance;
    int? userId = sharedPrefService.userId;
    if (userId != null) {
      User user = User();
      user.id = userId;
      user.firstName = sharedPrefService.userFirstName;
      user.lastName = sharedPrefService.userLastName;
      user.email = sharedPrefService.userEmail;
      user.token = sharedPrefService.userToken;
      AppData.user = user;
      AppData.accessToken = user.token;
      BlocProvider.of<AuthBloc>(context).add(PerformAutoLogin(user));
    }
  }
}

class ScreenUi extends StatelessWidget {
  // const ScreenUi({
  //   Key key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset("assets/images/splash.jpg", fit: BoxFit.cover,),
          /*child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child: Image.asset(
                          "assets/images/icon.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Text(
                        "Flutter Ecommerce",
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 25),
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 50),
                        child: Text("By Themes Coder"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),*/
        ),
      ),
    );
  }
}
