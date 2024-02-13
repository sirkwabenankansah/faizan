import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/api/api_provider.dart';
import 'package:flutter_kundol/blocs/detail_screen/detail_screen_bloc.dart';
import 'package:flutter_kundol/constants/app_data.dart';
import 'package:flutter_kundol/constants/app_styles.dart';
import 'package:flutter_kundol/models/products/product.dart';
import 'package:flutter_kundol/repos/cart_repo.dart';
import 'package:flutter_kundol/repos/products_repo.dart';

import '../../tweaks/app_localization.dart';
import '../detail_screen.dart';

class CardStyle3 extends StatefulWidget {
  final Function(Widget widget) navigateToNext;
  final Product product;
  final Color cardColor;

  const CardStyle3(this.navigateToNext, this.product, this.cardColor);

  @override
  _CardStyle3State createState() => _CardStyle3State();
}

class _CardStyle3State extends State<CardStyle3> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.navigateToNext(
          BlocProvider(
              create: (context) => DetailScreenBloc(RealCartRepo(), RealProductsRepo()),
              child: ProductDetailScreen(widget.product, widget.navigateToNext)),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppStyles.CARD_RADIUS),
        child: Card(

          color: widget.cardColor,
          margin: EdgeInsets.zero,
          child: Stack(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(AppStyles.CARD_RADIUS),
                  child: (widget.product.productGallary == null)
                      ? Container()
                      : SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: CachedNetworkImage(
                        imageUrl: ApiProvider.imgMediumUrlString +
                            widget.product.productGallary!.gallaryName!,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor,
                                value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.product.isFeatured == 1)
                      Container(
                          alignment: Alignment.center,
                          height: 20,
                          width: 65,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            color: Color(0xff444444),
                          ),
                          child: Text(
                              AppLocalizations.of(context)!.translate("Featured")!,
                              style:
                              const TextStyle(color: Colors.white, fontSize: 12))),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(AppStyles.CARD_RADIUS),
                  child: Container(
                    height: 60,
                    color: Theme.of(context).cardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.product.detail!.first.title!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: (widget.product.productDiscountPrice != 0) ?
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                            AppData.currency!.code !+
                                                double.parse(widget.product.productDiscountPrice
                                                    .toString())
                                                    .toStringAsFixed(2),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2?.copyWith(
                                                fontFamily: "MontserratSemiBold",color: Theme.of(context).primaryColor),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            AppData.currency!.code !+
                                                double.parse(widget
                                                    .product.productPrice
                                                    .toString())
                                                    .toStringAsFixed(2),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                ?.copyWith(
                                                fontSize: 12.0,
                                                decoration:
                                                TextDecoration.lineThrough),
                                          ),
                                        ],
                                      ) : Text(
                                        AppData.currency!.code !+
                                            double.parse(widget.product.productPrice
                                                .toString())
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontFamily: "MontserratSemiBold",color: Theme.of(context).primaryColor),
                                      ),
                                    ),
/*
                                        (widget.product.productType ==
                                                AppConstants.PRODUCT_TYPE_SIMPLE)
                                            ? Padding(
                                                padding: EdgeInsets.only(top: 8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "\$" +
                                                          double.parse(widget
                                                                  .product.productPrice
                                                                  .toString())
                                                              .toStringAsFixed(2),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2,
                                                    ),
                                                    SizedBox(width: 8),
                                                    if (widget
                                                            .product.productDiscountPrice !=
                                                        0)
                                                      Text(
                                                        "\$" +
                                                            double.parse(widget.product
                                                                    .productDiscountPrice
                                                                    .toString())
                                                                .toStringAsFixed(2),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2
                                                            .copyWith(
                                                                decoration: TextDecoration
                                                                    .lineThrough),
                                                      ),
                                                  ],
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.only(top: 8.0),
                                                child: RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                    text: "\$" +
                                                        double.tryParse(widget
                                                                .product
                                                                .productCombination
                                                                .first
                                                                .price
                                                                .toString())
                                                            .toStringAsFixed(2),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2,
                                                  ),
                                                  TextSpan(text: " - "),
                                                  TextSpan(
                                                    text: "\$" +
                                                        double.tryParse(widget
                                                                .product
                                                                .productCombination
                                                                .last
                                                                .price
                                                                .toString())
                                                            .toStringAsFixed(2),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2,
                                                  ),
                                                ])),
                                              ),
*/
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
}
