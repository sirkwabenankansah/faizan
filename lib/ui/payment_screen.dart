import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/api/responses/shipment_city.dart';
import 'package:flutter_kundol/blocs/checkout/checkout_bloc.dart';
import 'package:flutter_kundol/blocs/payment_methods/payment_methods_bloc.dart';
import 'package:flutter_kundol/models/address_data.dart';
import 'package:flutter_kundol/models/cart_data.dart';
import 'package:flutter_kundol/models/coupon_data.dart';
import 'package:flutter_kundol/repos/checkout_repo.dart';
import 'package:flutter_kundol/ui/checkout_screen.dart';
import '../blocs/shipmentwithcity/shipment_bloc.dart';
import '../repos/shipmentcity_repo.dart';
import '../tweaks/app_localization.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartData> cartItems;
  final CouponData? couponData;
  final AddressData addressData;

  const PaymentScreen(this.cartItems, this.couponData, this.addressData,);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<PaymentScreen> {
  late PaymentMethodsBloc paymentMethodsBloc;

  @override
  void initState() {
    super.initState();

    paymentMethodsBloc = BlocProvider.of<PaymentMethodsBloc>(context);
    paymentMethodsBloc.add(const GetPaymentMethods());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor :  Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
            AppLocalizations.of(context)!.translate("Payment")!,
            style: Theme.of(context).textTheme.headline6),
        elevation: 0.0,
      ),
      body: BlocBuilder<PaymentMethodsBloc, PaymentMethodsState>(
        bloc: paymentMethodsBloc,
        builder: (context, state) {
          if (state is PaymentMethodsLoaded) {
            return ListView.builder(
              itemCount: state.paymentMethodsResponse.data?.length,
              itemBuilder: (context, index) {
              //  if(
              //  state.paymentMethodsResponse.data![index].paymentMethodStatus == 1
              //  )
              //  {
                 return ListTile(
                   onTap: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) =>
                          MultiBlocProvider(
                          providers: [
                          BlocProvider(
                           create: (BuildContext context) {
                             return CheckoutBloc(RealCheckoutRepo());
                           }
                           ),
                           BlocProvider(
                           create: (BuildContext context) {
                             return ShipmentBloc(RealShipmentRepo());
                           }
                           ),
  ],
   child: CheckoutScreen(
    
                             widget.cartItems,
                             widget.couponData,
                             widget.addressData,
                             state.paymentMethodsResponse.data![index],
                          
                           ),
   )
                        //   BlocProvider(
                        //    create: (BuildContext context) {
                        //      return CheckoutBloc(RealCheckoutRepo());
                        //    },
                        //    child: CheckoutScreen(
                        //      widget.cartItems,
                        //      widget.couponData,
                        //      widget.addressData,
                        //      state.paymentMethodsResponse.data![index],
                        //    ),
                        //  ),
                       ),
                     );
                   },
                   enabled: true,
                   leading: const Icon(Icons.payment),
                   title: Text(state.paymentMethodsResponse.data![index].paymentMethodTitle.toString()),
                 );
             //  }
               return Container();
              },
            );
          } else if (state is PaymentMethodsError) {
            return Text(state.error);
          } else {
            return Center(child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
            ),);
          }
        },
      ),
    );
  }
}
