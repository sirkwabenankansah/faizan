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

class CardStyle7 extends StatefulWidget {
  final Function(Widget widget) navigateToNext;
  final Product product;
  final Color cardColor;

  const CardStyle7(this.navigateToNext, this.product, this.cardColor);

  @override
  _CardStyle7State createState() => _CardStyle7State();
}

class _CardStyle7State extends State<CardStyle7> {
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
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
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
                                    StarRating(
                                        starCount: 5,
                                        rating: widget.product.productRating!= null ? double.parse(widget.product.productRating.toString()) : 0,
                                        onRatingChanged: (rating) {}, color: Colors.black12,),
                                    Text(
                                      widget.product.detail!.first.title!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
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
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
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
