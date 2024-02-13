import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/api/responses/settings_response.dart';
import 'package:flutter_kundol/blocs/detail_screen/detail_screen_bloc.dart';
import 'package:flutter_kundol/blocs/top_selling_products/top_selling_products_bloc.dart';
import 'package:flutter_kundol/constants/app_data.dart';
import 'package:flutter_kundol/constants/app_styles.dart';
import 'package:flutter_kundol/models/products/product.dart';
import 'package:flutter_kundol/repos/cart_repo.dart';
import 'package:flutter_kundol/repos/products_repo.dart';
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


import '../../tweaks/app_localization.dart';
import '../detail_screen.dart';

class TopSellingProductsWidget extends StatefulWidget {
  final Function(Widget widget) navigateToNext;

  const TopSellingProductsWidget(this.navigateToNext);

  @override
  _TopSellingProductsWidgetState createState() => _TopSellingProductsWidgetState();
}

class _TopSellingProductsWidgetState extends State<TopSellingProductsWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        Text((
            AppLocalizations.of(context)!.translate("Top Rated")!
        ).toUpperCase(),
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.w300,
                )),
        const SizedBox(
          height: 16.0,
        ),
        BlocBuilder<TopSellingProductsBloc, TopSellingProductsState>(
          builder: (context, state) {
            switch (state.status) {
              case TopSellingProductsStatus.success:
                return SizedBox(
                  width: double.maxFinite,
                  height: 200.0,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.products!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          widget.navigateToNext(
                            BlocProvider(
                                create: (context) =>
                                    DetailScreenBloc(RealCartRepo(), RealProductsRepo()),
                                child: ProductDetailScreen(
                                    state.products![index], widget.navigateToNext)),
                          );
                        },
                        child: Container(
                          width: 170.0,
                          margin: const EdgeInsets.all(4.0),
                          child: getDefaultCard(state.products![index], index),
                        ),
                      );
                    },
                  ),
                );
              case TopSellingProductsStatus.failure:
                return Text(
                    AppLocalizations.of(context)!.translate("Error")!
                );
              default:
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                  ),
                );
            }
          },
        ),
      ],
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
        return CardStyleNew1(widget.navigateToNext, product, getCardBackground(index));
      case 2:
        return CardStyle2(widget.navigateToNext, product, getCardBackground(index));
      case 3:
        return CardStyle3(widget.navigateToNext, product, getCardBackground(index));
      case 4:
        return CardStyle4(widget.navigateToNext, product, getCardBackground(index));
      case 5:
        return CardStyle5(widget.navigateToNext, product, getCardBackground(index));
      case 6:
        return CardStyle6(widget.navigateToNext, product, getCardBackground(index));
      case 7:
        return CardStyle7(widget.navigateToNext, product, getCardBackground(index));
      case 8:
        return CardStyle8(widget.navigateToNext, product, getCardBackground(index));
      case 9:
        return CardStyle9(widget.navigateToNext, product, getCardBackground(index));
      case 10:
        return CardStyle10(widget.navigateToNext, product, getCardBackground(index));
      case 11:
        return CardStyle11(widget.navigateToNext, product, getCardBackground(index));
      case 12:
        return CardStyle12(widget.navigateToNext, product, getCardBackground(index));
      case 13:
        return CardStyle13(widget.navigateToNext, product, getCardBackground(index));
      case 14:
        return CardStyle14(widget.navigateToNext, product, getCardBackground(index));
      case 15:
        return CardStyle15(widget.navigateToNext, product, getCardBackground(index));
      case 16:
        return CardStyle16(widget.navigateToNext, product, getCardBackground(index));
      case 17:
        return CardStyle17(widget.navigateToNext, product, getCardBackground(index));
      case 18:
        return CardStyle18(widget.navigateToNext, product, getCardBackground(index));
      case 19:
        return CardStyle19(widget.navigateToNext, product, getCardBackground(index));
      case 20:
        return CardStyle20(widget.navigateToNext, product, getCardBackground(index));
      case 21:
        return CardStyle21(widget.navigateToNext, product, getCardBackground(index));
      case 22:
        return CardStyle22(widget.navigateToNext, product, getCardBackground(index));
      case 23:
        return CardStyle23(widget.navigateToNext, product, getCardBackground(index));
      case 24:
        return CardStyle24(widget.navigateToNext, product, getCardBackground(index));
      case 25:
        return CardStyle25(widget.navigateToNext, product, getCardBackground(index));
      case 26:
        return CardStyle26(widget.navigateToNext, product, getCardBackground(index));
      case 27:
        return CardStyle27(widget.navigateToNext, product, getCardBackground(index));
      default:
        return CardStyleNew1(widget.navigateToNext, product, getCardBackground(index));
    }
  }
  int cardColorindex=0;

  Color getCardBackground(int index) {
    Color tempColor = AppStyles.cardColors[cardColorindex];
    cardColorindex++;
    if (cardColorindex == 4) cardColorindex= 0;
    return tempColor;
  }
}
