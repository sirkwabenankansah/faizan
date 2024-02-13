import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/blocs/orders/orders_bloc.dart';
import 'package:flutter_kundol/repos/orders_repo.dart';
import 'package:flutter_kundol/ui/orders_screen.dart';
import 'package:flutter_svg/svg.dart';

import '../tweaks/app_localization.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen();

  @override
  _ThankYouState createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYouScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor :  Colors.white,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
              AppLocalizations.of(context)!.translate("Checkout")!,
              style: Theme.of(context).textTheme.headline6),
          elevation: 0.0,
        ),
        body: Column(
          children: [
            const SizedBox(height: 50,),
            SvgPicture.asset("assets/icons/ic_check_finish.svg",color: Theme.of(context).primaryColor,),
            const SizedBox(height: 10,),
            Text(
              AppLocalizations.of(context)!.translate("Congratulations!")!,
              style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor),),
            Center(child: Text(
                AppLocalizations.of(context)!.translate("Your Order Has been Placed")!
            )),
            const SizedBox(height: 30,),
            SizedBox(
              width: 280,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),

                          )
                      )
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                            create: (BuildContext context) {
                              return OrdersBloc(RealOrdersRepo())
                                ..add(const GetOrders());
                            },
                            child: OrdersScreen()),
                      ),
                      (route) => route.isFirst,
                    );
                  },
                  child: Text(
                      AppLocalizations.of(context)!.translate("Order Status")!
                  )),
            ),
            SizedBox(
              width: 280,
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side: BorderSide(width:1, color:Theme.of(context).primaryColor),

                      ),


                    ),
                    backgroundColor: MaterialStateProperty.all( Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor :  Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate("Continue Shopping")!,
                    style: TextStyle(color:Theme.of(context).primaryColor),)),
            ),
          ],
        ),
      ),
    );
  }
}
