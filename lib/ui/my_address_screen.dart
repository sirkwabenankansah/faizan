import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/blocs/add_addressbook/add_addressbook_bloc.dart';
import 'package:flutter_kundol/blocs/address/address_bloc.dart';
import 'package:flutter_kundol/blocs/countries/countries_bloc.dart';
import 'package:flutter_kundol/constants/app_styles.dart';
import 'package:flutter_kundol/repos/address_repo.dart';
import 'package:flutter_kundol/ui/add_addressbook_screen.dart';

import '../blocs/cityy/city_bloc.dart';
import '../blocs/countryy/country_bloc.dart';
import '../blocs/statee/statee_bloc.dart';
import '../constants/app_config.dart';
import '../repos/cityy_repo.dart';
import '../repos/countries_repo.dart';
import '../repos/countryy_repo.dart';
import '../repos/statee_repo.dart';
import '../tweaks/app_localization.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen();

  @override
  _ShippingState createState() => _ShippingState();
}

class _ShippingState extends State<MyAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor :  Colors.white,
        appBar: AppConfig.APP_BAR_COLOR == 2 ?
        AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color:AppConfig.APP_BAR_COLOR == 2 ?
            Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black :
            Colors.white,
          ),
          backgroundColor:Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          title: Text(
            AppLocalizations.of(context)!.translate("Address book")!,
            style: TextStyle(
              color:AppConfig.APP_BAR_COLOR == 2 ?
              Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black :
              Colors.white,
            ),),
          elevation: 0.0,
        ):
            AppConfig.APP_BAR_COLOR == 1 ?
        AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color:AppConfig.APP_BAR_COLOR == 1 ?
            Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white :
            Colors.white,
          ),
          backgroundColor:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
          title: Text(
            AppLocalizations.of(context)!.translate("Address book")!,
            style: TextStyle(
              color:AppConfig.APP_BAR_COLOR == 1 ?
              Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white :
              Colors.white,
            ),),
          elevation: 0.0,
        ):
        AppConfig.APP_BAR_COLOR == 3 ?
        AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).brightness ==
                Brightness.dark
                ? Colors.white
                : Colors.black,),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Theme.of(context).cardColor,
          title: Text("Address book",
              style: Theme.of(context).textTheme.headline6),
          elevation: 0.0,
        ):null,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                              create: (context) =>
                                  AddAddressBookBloc(RealAddressRepo())),
                          BlocProvider(
                              create: (context) =>
                                  CountryyBloc(RealCountryyRepo())),
                                   BlocProvider(
                              create: (context) =>
                                  StateeBloc(RealStateeRepo())),
                                   BlocProvider(
                              create: (context) =>
                                  CityyBloc(RealCityyRepo())),
                        ],
                        child:AddAddressBookScreen(null),
                      );
                    },
                  ));
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 0,right: 0,top: 12,bottom: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        AppStyles.CARD_RADIUS),
                    child: Container(
                      decoration: AppConfig.APP_BAR_COLOR == 2 ?
                      BoxDecoration(
                        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,),
                        borderRadius: const BorderRadius.all(
                            Radius.circular( AppStyles.CARD_RADIUS) //                 <--- border radius here
                        ),
                      ):
                      BoxDecoration(
                        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,),
                        borderRadius: const BorderRadius.all(
                            Radius.circular( AppStyles.CARD_RADIUS) //                 <--- border radius here
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 40, bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppConfig.APP_BAR_COLOR == 2 ?
                          Icon(Icons.add,color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,):
                          Icon(Icons.add,color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              AppLocalizations.of(context)!.translate("Add A New Address")!
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BlocConsumer<AddressBloc, AddressState>(
                  bloc: BlocProvider.of<AddressBloc>(context),
                  builder: (context, state) {
                    if (state is AddressLoading) {
                      return  Center( child: CircularProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                      ),);
                    } else if (state is AddressLoaded) {
                      if (state.addressData.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.addressData.length,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(left: 0,right: 0,top: 12,bottom: 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  AppStyles.CARD_RADIUS),
                              child: Container(
                                padding: const EdgeInsets.only(top: 10),
                                decoration: AppConfig.APP_BAR_COLOR == 2 ?
                                BoxDecoration(
                                  border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular( AppStyles.CARD_RADIUS) //                 <--- border radius here
                                  ),
                                ):
                                BoxDecoration(
                                  border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular( AppStyles.CARD_RADIUS) //                 <--- border radius here
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    if (state.addressData[index].defaultAddress != 1) {
                                      BlocProvider.of<AddressBloc>(context).add(
                                          SetDefaultAddress(
                                              state.addressData[index].id!,
                                              state.addressData[index].customer!.customerFirstName!,
                                              state.addressData[index].customer! .customerLastName!,
                                              state.addressData[index].gender!,
                                              state.addressData[index].company!,
                                              state.addressData[index].streetAddress!,
                                              state.addressData[index].suburb!,
                                              state.addressData[index].postcode!,
                                              state.addressData[index].dob!,
                                        
                                              state.addressData[index].countryId!.countryId!,
                                              state.addressData[index].stateId!.countryId!,
                                             // state.addressData[index].city!.countryId.toString(),
                                             state.addressData[index].city!,
                                              state.addressData[index].lattitude!,
                                              state.addressData[index].longitude!,
                                              state.addressData[index].phone!));
                                    }
                                  },
                                  enabled: true,
                                  isThreeLine: true,
                                  leading: const Icon(Icons.location_pin),
                                  trailing:
                                      (state.addressData[index].defaultAddress == 1)
                                          ? const Icon(Icons.check)
                                          : null,
                                  title: Text("${state.addressData[index].customer
                                          ?.customerFirstName} ${state.addressData[index].customer
                                          ?.customerLastName}"),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                    //  Text(state.addressData[index].city!),
                                      Text(state.addressData[index].streetAddress!),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                BlocProvider.of<AddressBloc>(context)
                                                    .add(DeleteAddress(
                                                        state.addressData[index].id!));
                                              },
                                              icon: const Icon(Icons.delete)),
                                          const SizedBox(width: 12.0),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return MultiBlocProvider(
                                                      providers: [
                                                        BlocProvider(
                                                            create: (context) =>
                                                                AddAddressBookBloc(
                                                                    RealAddressRepo())),
                                                        BlocProvider(
                                                            create: (context) =>
                                                                CountryyBloc(RealCountryyRepo())),
                                                                BlocProvider(
                                                            create: (context) =>
                                                                StateeBloc(RealStateeRepo())),
                                                                BlocProvider(
                                                            create: (context) =>
                                                                CityyBloc(RealCityyRepo())),
                                                      ],
                                                      child: AddAddressBookScreen(
                                                          state.addressData[index]),
                                                    );
                                                  },
                                                ));
                                              },
                                              icon: const Icon(Icons.edit)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Center(child: Text(
                            AppLocalizations.of(context)!.translate("Empty")!
                        ));
                      }
                    }
                    else if (state is AddressError) {
                      // ScaffoldMessenger.of(context)
                      //     .showSnackBar(SnackBar(content: Text(state.error)));
                      return Center( child: CircularProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                      ),);
                    }
                    else {
                      return Container();
                    }
                  },
                  listener: (context, state) {
                    if (state is AddressError) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
