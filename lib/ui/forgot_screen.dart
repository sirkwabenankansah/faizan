import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/blocs/auth/auth_bloc.dart';
import 'package:flutter_kundol/constants/app_styles.dart';

import '../tweaks/app_localization.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController _signInEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
              AppLocalizations.of(context)!.translate("Forgot Password")!,
              style: Theme.of(context).textTheme.headline6),
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: AppStyles.SCREEN_MARGIN_VERTICAL,
              horizontal: AppStyles.SCREEN_MARGIN_HORIZONTAL),
          child: Column(
            children: [
              TextField(
                autofocus: false,
                controller: _signInEmailController,
                decoration: InputDecoration(
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? AppStyles.COLOR_LITE_GREY_DARK
                        : AppStyles.COLOR_LITE_GREY_LIGHT,
                    filled: true,
                    border: InputBorder.none,
                    hintText:
                    AppLocalizations.of(context)!.translate("Enter your email"),
                    hintStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppStyles.COLOR_GREY_DARK
                            : AppStyles.COLOR_GREY_LIGHT,
                        fontSize: 14),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                    )),
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 40.0,
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: () {
                      if (_signInEmailController.text.isNotEmpty) {
                        BlocProvider.of<AuthBloc>(context).add(
                            PerformForgotPassword(
                                _signInEmailController.text.trim()));
                      }
                    },
                    child: Text(
                        AppLocalizations.of(context)!.translate("Send")!
                    )),
              ),
            ],
          ),
        ));
  }
}
