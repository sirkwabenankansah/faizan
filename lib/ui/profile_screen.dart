
import 'package:flutter/material.dart';
import 'package:flutter_kundol/constants/app_data.dart';

import '../tweaks/app_localization.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController signInEmailController = TextEditingController();
    TextEditingController signInPasswordController =
        TextEditingController();

    return Scaffold(
      body: Column(
        children: [
          Text("${AppData.user?.firstName} ${AppData.user?.lastName}"),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      )
                  )
              ),
              onPressed: () {}, child: Text(
              AppLocalizations.of(context)!.translate( "Logout")!
          )),
        ],
      ),
    );
  }
}
