import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_kundol/api/api_provider.dart';
import 'package:flutter_kundol/api/responses/settings_response.dart';
import 'package:flutter_kundol/blocs/detail_screen/detail_screen_bloc.dart';
import 'package:flutter_kundol/blocs/products_search/products_search_bloc.dart';
import 'package:flutter_kundol/blocs/wishlist/wishlist_bloc.dart';
import 'package:flutter_kundol/constants/app_constants.dart';
import 'package:flutter_kundol/constants/app_data.dart';
import 'package:flutter_kundol/constants/app_styles.dart';
import 'package:flutter_kundol/models/cart_data.dart';
import 'package:flutter_kundol/models/products/product.dart';
import 'package:flutter_kundol/repos/cart_repo.dart';
import 'package:flutter_kundol/repos/products_repo.dart';
import 'package:flutter_kundol/ui/detail_screen.dart';
import 'package:flutter_kundol/ui/widgets/app_bar.dart';
import 'package:flutter_kundol/ui/widgets/card_style_10.dart';
import 'package:flutter_kundol/ui/widgets/card_style_11.dart';
import 'package:flutter_kundol/ui/widgets/card_style_12.dart';
import 'package:flutter_kundol/ui/widgets/card_style_13.dart';
import 'package:flutter_kundol/ui/widgets/card_style_14.dart';
import 'package:flutter_kundol/ui/widgets/card_style_15.dart';
import 'package:flutter_kundol/ui/widgets/card_style_16.dart';
import 'package:flutter_kundol/ui/widgets/card_style_17.dart';
import 'package:flutter_kundol/ui/widgets/card_style_18.dart';
import 'package:flutter_kundol/ui/widgets/card_style_19.dart';
import 'package:flutter_kundol/ui/widgets/card_style_2.dart';
import 'package:flutter_kundol/ui/widgets/card_style_20.dart';
import 'package:flutter_kundol/ui/widgets/card_style_21.dart';
import 'package:flutter_kundol/ui/widgets/card_style_22.dart';
import 'package:flutter_kundol/ui/widgets/card_style_23.dart';
import 'package:flutter_kundol/ui/widgets/card_style_24.dart';
import 'package:flutter_kundol/ui/widgets/card_style_25.dart';
import 'package:flutter_kundol/ui/widgets/card_style_26.dart';
import 'package:flutter_kundol/ui/widgets/card_style_27.dart';
import 'package:flutter_kundol/ui/widgets/card_style_3.dart';
import 'package:flutter_kundol/ui/widgets/card_style_4.dart';
import 'package:flutter_kundol/ui/widgets/card_style_5.dart';
import 'package:flutter_kundol/ui/widgets/card_style_6.dart';
import 'package:flutter_kundol/ui/widgets/card_style_7.dart';
import 'package:flutter_kundol/ui/widgets/card_style_8.dart';
import 'package:flutter_kundol/ui/widgets/card_style_9.dart';
import 'package:flutter_kundol/ui/widgets/card_style_new_1.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_config.dart';
import '../tweaks/app_localization.dart';

class SearchScreen extends StatefulWidget {
  final Function(Widget widget)? navigateToNext;

  SearchScreen(this.navigateToNext);

  @override
  _ShippingState createState() => _ShippingState();
}

class _ShippingState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor :  Colors.white,
      appBar:AppConfig.APP_BAR_COLOR == 2 ?
      AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate("Search")!,
          style: TextStyle(
            color:AppConfig.APP_BAR_COLOR == 2 ?
                    Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black :
                    Colors.white,
          ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined,
            color:AppConfig.APP_BAR_COLOR == 2 ?
                    Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black :
                    Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor:Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
        elevation: 0.0,
      ):
          AppConfig.APP_BAR_COLOR == 1 ?
      AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate("Search")!,
          style: TextStyle(
            color:AppConfig.APP_BAR_COLOR == 1 ?
                    Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black :
                    Colors.white,
          ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined,
            color:AppConfig.APP_BAR_COLOR == 1 ?
                    Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black :
                    Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
        elevation: 0.0,
      ): null,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppConfig.APP_BAR_COLOR == 1 ?
          MyAppBar(
            centerWidget: Container(
              height: 35.0,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: AppStyles.COLOR_SEARCH_BAR,
                borderRadius:
                BorderRadius.all(Radius.circular(AppStyles.CARD_RADIUS)),
              ),
              child: Row(
                children: [
                  SvgPicture.asset("assets/icons/ic_search_new.svg",
                    color:AppConfig.APP_BAR_COLOR == 1 ?
                    Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black :
                    Colors.white,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 12.0, bottom: 0.0,top: 6),
                      height: 25,
                      child: TextField(
                        onSubmitted: (value) {
                          if (value.isNotEmpty)
                            BlocProvider.of<ProductsSearchBloc>(context)
                                .add(GetSearchProducts(value));
                        },
                        textInputAction: TextInputAction.search,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText:
                          AppLocalizations.of(context)!.translate("What are you looking for"),
                          hintStyle: TextStyle(fontSize: 15.0, color:AppConfig.APP_BAR_COLOR == 1 ?
                          Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black :
                          Colors.white,),
                          border: InputBorder.none,
                         // hintStyle: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

          ):
          AppConfig.APP_BAR_COLOR == 2 ?
          MyAppBar(
          centerWidget: Container(
          height: 40.0,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
          color: AppStyles.COLOR_SEARCH_BAR,
          borderRadius:
          BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
          children: [
          Icon(
          Icons.search_outlined,
          size: 18.0,
          ),
          Expanded(
          child: Container(
          margin: EdgeInsets.only(left: 12.0, bottom: 6.0),
          height: 25,
    child: TextField(
    onSubmitted: (value) {
    if (value.isNotEmpty)
    BlocProvider.of<ProductsSearchBloc>(context)
        .add(GetSearchProducts(value));
    },
    textInputAction: TextInputAction.search,
    textAlignVertical: TextAlignVertical.center,
    decoration: InputDecoration(
    hintText: "What are you looking for?",
    border: InputBorder.none,
    hintStyle: Theme.of(context).textTheme.caption!.copyWith(fontSize: 10),
    ),
    ),
    ),
    )
    ],
    ),
    ),
    // trailingWidget: Padding(
    // padding: EdgeInsets.symmetric(horizontal: 10),
    // child: TextButton(
    // onPressed: () {
    // Navigator.pop(context);
    // },
    // child: Text("Cancel"))),
    ):AppConfig.APP_BAR_COLOR == 3 ?
    MyAppBar(
    centerWidget: Container(
    height: 30.0,
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
    color: AppStyles.COLOR_SEARCH_BAR,
    borderRadius:
    BorderRadius.all(Radius.circular(15)),
    ),
    child: Row(
    children: [
    Icon(
    Icons.search_outlined,
    size: 16.0,
    ),
    Expanded(
    child: Container(
    margin: EdgeInsets.only(left: 12.0, bottom: 6.0),
    height: 25,
    child: TextField(
    onSubmitted: (value) {
    if (value.isNotEmpty)
    BlocProvider.of<ProductsSearchBloc>(context)
        .add(GetSearchProducts(value));
    },
    textInputAction: TextInputAction.search,
    textAlignVertical: TextAlignVertical.center,
    decoration: InputDecoration(
    hintText: "What are you looking for?",
    border: InputBorder.none,
    hintStyle: Theme.of(context).textTheme.caption!.copyWith(fontSize: 10),
    ),
    ),
    ),
    )
    ],
    ),
    ),
    trailingWidget: Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: TextButton(
    onPressed: () {
    Navigator.pop(context);
    },
    child: Text("Cancel")
    ))
    ):Container(),
          Container(width: double.maxFinite,
              child: Column(
                children: [
                  // Here Chips Widget
                  // chipList(),

                ],
              )
          ),
          Expanded(
            child: BlocBuilder<ProductsSearchBloc, ProductsSearchState>(
              builder: (context, state) {
                if (state is ProductsSearchState) {
                  switch (state.status) {
                    case ProductsSearchStatus.initial:
                      return Container();
                    case ProductsSearchStatus.success:
                      if (state.products!.isEmpty)
                        return Center(child: Text(
                            AppLocalizations.of(context)!.translate("Empty")!
                        ));
                      else
                        return Container(
                          margin: EdgeInsets.all(12.0),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppStyles.GRID_SPACING,
                              mainAxisSpacing: AppStyles.GRID_SPACING,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: state.products?.length,
                            itemBuilder: (context, index) {
                              return getDefaultCard(state.products![index], index);
                            },
                          ),
                        );
                      break;
                    case ProductsSearchStatus.failure:
                      return Text(
                          AppLocalizations.of(context)!.translate("Error")!
                      );
                    case ProductsSearchStatus.loading:
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                        ),
                      );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  bool checkForWishlist(int productId) {
    for (int i = 0; i < AppData.wishlistData!.length; i++) {
      if (productId == AppData.wishlistData![i].productId) {
        return true;
      }
    }
    return false;
  }

  Widget getDefaultCard(Product product, int index) {
    switch (int.parse(
        AppData.settingsResponse!.getKeyValue(SettingsResponse.CARD_STYLE))) {
      case 1:
        return CardStyleNew1(widget.navigateToNext!, product, getCardBackground(index));
      case 2:
        return CardStyle2(widget.navigateToNext!, product, getCardBackground(index));
      case 3:
        return CardStyle3(widget.navigateToNext!, product, getCardBackground(index));
      case 4:
        return CardStyle4(widget.navigateToNext!, product, getCardBackground(index));
      case 5:
        return CardStyle5(widget.navigateToNext!, product, getCardBackground(index));
      case 6:
        return CardStyle6(widget.navigateToNext!, product, getCardBackground(index));
      case 7:
        return CardStyle7(widget.navigateToNext!, product, getCardBackground(index));
      case 8:
        return CardStyle8(widget.navigateToNext!, product, getCardBackground(index));
      case 9:
        return CardStyle9(widget.navigateToNext!, product, getCardBackground(index));
      case 10:
        return CardStyle10(widget.navigateToNext!, product, getCardBackground(index));
      case 11:
        return CardStyle11(widget.navigateToNext!, product, getCardBackground(index));
      case 12:
        return CardStyle12(widget.navigateToNext!, product, getCardBackground(index));
      case 13:
        return CardStyle13(widget.navigateToNext!, product, getCardBackground(index));
      case 14:
        return CardStyle14(widget.navigateToNext!, product, getCardBackground(index));
      case 15:
        return CardStyle15(widget.navigateToNext!, product, getCardBackground(index));
      case 16:
        return CardStyle16(widget.navigateToNext!, product, getCardBackground(index));
      case 17:
        return CardStyle17(widget.navigateToNext!, product, getCardBackground(index));
      case 18:
        return CardStyle18(widget.navigateToNext!, product, getCardBackground(index));
      case 19:
        return CardStyle19(widget.navigateToNext!, product, getCardBackground(index));
      case 20:
        return CardStyle20(widget.navigateToNext!, product, getCardBackground(index));
      case 21:
        return CardStyle21(widget.navigateToNext!, product, getCardBackground(index));
      case 22:
        return CardStyle22(widget.navigateToNext!, product, getCardBackground(index));
      case 23:
        return CardStyle23(widget.navigateToNext!, product, getCardBackground(index));
      case 24:
        return CardStyle24(widget.navigateToNext!, product, getCardBackground(index));
      case 25:
        return CardStyle25(widget.navigateToNext!, product, getCardBackground(index));
      case 26:
        return CardStyle26(widget.navigateToNext!, product, getCardBackground(index));
      case 27:
        return CardStyle27(widget.navigateToNext!, product, getCardBackground(index));
      default:
        return CardStyleNew1(widget.navigateToNext!, product, getCardBackground(index));
    }
  }
  int cardColorindex=0;
  chipList() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: <Widget>[
        _buildChip(
            AppLocalizations.of(context)!.translate('Flat 50% OFF')!
        ),
        _buildChip(
            AppLocalizations.of(context)!.translate('Clearance Sale')!
        ),
        _buildChip(
            AppLocalizations.of(context)!.translate('Best Seller Item')!
        ),
        _buildChip(
            AppLocalizations.of(context)!.translate('Babies New look item')!
        ),
        _buildChip(
            AppLocalizations.of(context)!.translate('Flat 30% OFF')!
        ),
        _buildChip(
            AppLocalizations.of(context)!.translate('Best Item')!
        ),
        _buildChip(
            AppLocalizations.of(context)!.translate('Flat 50% OFF')!
        ),
      ],
    );
  }

  Color getCardBackground(int index) {
    Color tempColor = AppStyles.cardColors[cardColorindex];
    cardColorindex++;
    if (cardColorindex == 4) cardColorindex= 0;
    return tempColor;
  }

  Widget _buildChip(String label) {
    return Chip(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: Colors.grey,
            width: 1
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      labelPadding: EdgeInsets.all(2.0),

      label: Text(
        label,
      ),
      padding: EdgeInsets.all(5.0),
    );
  }

}
