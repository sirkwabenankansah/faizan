import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_kundol/blocs/auth/auth_bloc.dart';
import 'package:flutter_kundol/blocs/language/language_bloc.dart';
import 'package:flutter_kundol/blocs/page/page_bloc.dart';
import 'package:flutter_kundol/blocs/theme/theme_bloc.dart';
import 'package:flutter_kundol/constants/app_data.dart';
import 'package:flutter_kundol/tweaks/shared_pref_service.dart';

import '../tweaks/app_localization.dart';

class ContentScreen extends StatefulWidget {
  final int pageNo;

  ContentScreen(this.pageNo);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  String title = "";

  @override
  void initState() {
    super.initState();
    switch (widget.pageNo) {
      case 1:
        title ="About US";
        break;
      case 2:
        title ="Refund Policy";
        break;
      case 3:
        title ="Privacy Policy";
        break;
      case 4:
        title ="Terms & Conditions";
        break;
    }
    BlocProvider.of<GetPageBloc>(context).add(GetPage(widget.pageNo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title,style: TextStyle( color: Theme.of(context).brightness ==
            Brightness.dark
            ? Colors.white
            : Colors.black,),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).brightness ==
              Brightness.dark
              ? Colors.white
              : Colors.black,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<GetPageBloc, PageState>(
          builder: (context, state) {
            if (state is GetPageLoaded) {
              return Html(
                  data: state.pageResponse.data!.detail!.first.description);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
