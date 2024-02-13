import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/api/api_provider.dart';
import 'package:flutter_kundol/blocs/detail_screen/detail_screen_bloc.dart';
import 'package:flutter_kundol/constants/app_data.dart';
import 'package:flutter_kundol/models/products/product.dart';
import 'package:flutter_kundol/repos/cart_repo.dart';
import 'package:flutter_kundol/repos/products_repo.dart';

import '../detail_screen.dart';

class CardStyle11 extends StatefulWidget {
  final Function(Widget widget) navigateToNext;
  final Product product;
  final Color cardColor;

  const CardStyle11(this.navigateToNext, this.product, this.cardColor);

  @override
  _CardStyle11State createState() => _CardStyle11State();
}

class _CardStyle11State extends State<CardStyle11> {
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
        borderRadius: BorderRadius.circular(0),
        child: Card(
          color: widget.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          margin: EdgeInsets.zero,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(0),
                        child: (widget.product.productGallary == null)
                            ? Container()
                            : SizedBox(
                          width: double.maxFinite,
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
                  Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.product.category!.first.categoryDetail!.detail!.first.name!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                    Text(
                                      widget.product.detail!.first.title!,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                    (widget.product.productDiscountPrice != 0) ?
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
/*
                                    (widget.product.productType ==
                                        AppConstants.PRODUCT_TYPE_SIMPLE)
                                        ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child:
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            widget.navigateToNext(
                              BlocProvider(
                                  create: (context) => DetailScreenBloc(
                                      RealCartRepo(),
                                      RealProductsRepo()),
                                  child: ProductDetailScreen(
                                      widget.product,
                                      widget.navigateToNext)),
                            );
                          },
                          child: const IconTheme(
                              data: IconThemeData(color: Colors.white),
                              child: Icon(
                                Icons.shopping_basket_outlined,
                                size: 24,
                              )),
                        ),
                      )),
                ),
              )
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
