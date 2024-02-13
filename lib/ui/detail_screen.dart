import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/api/api_provider.dart';
import 'package:flutter_kundol/blocs/wishlist/wishlist_bloc.dart';
import 'package:flutter_kundol/ui/main_screen.dart';
import 'package:flutter_kundol/blocs/cart/cart_bloc.dart';
import 'package:flutter_kundol/blocs/detail_screen/detail_screen_bloc.dart';
import 'package:flutter_kundol/blocs/related_products/related_products_bloc.dart';
import 'package:flutter_kundol/constants/app_constants.dart';
import 'package:flutter_kundol/constants/app_data.dart';
import 'package:flutter_kundol/constants/app_styles.dart';
import 'package:flutter_kundol/models/products/product.dart';
import 'package:flutter_kundol/repos/cart_repo.dart';
import 'package:flutter_kundol/repos/products_repo.dart';
import 'package:flutter_kundol/repos/reviews_repo.dart';
import 'package:flutter_kundol/ui/review_screen.dart';
import 'package:flutter_kundol/blocs/reviews/reviews_bloc.dart';
import 'package:flutter_kundol/ui/widgets/app_bar.dart';
import 'package:flutter_kundol/ui/widgets/badgeCount.dart';
import 'package:flutter_kundol/ui/widgets/home_app_bar.dart';
import 'package:flutter_kundol/ui/widgets/products_widget.dart';
import 'package:flutter_kundol/ui/widgets/related_products_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';


import '../constants/app_cart.dart';

import '../tweaks/app_localization.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Function(Widget widget) navigateToNext;
  Product product;

  ProductDetailScreen(this.product, this.navigateToNext);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _sliderIndex = 0;
  int quantity = 1;
  BottomSheetContent? bottomSheetContent;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DetailScreenBloc>(context)
        .add(GetProductById(widget.product.productId!));
  }
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  var s1 = AppBadge();
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor :  Color(0xffF6F6F6),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0), // here the desired height
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).brightness ==
                  Brightness.dark
                  ? Colors.white
                  : Colors.black,),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0.0,
            backgroundColor: Theme.of(context).cardColor,
          )
      ),
      body: BlocConsumer<DetailScreenBloc, DetailPageState>(
        listener: (context, state) {
          if (state is GetQuantityLoaded) {
            if (state.quantityData.remainingStock == null ||
                int.tryParse(state.quantityData.remainingStock!) == 0) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate("Stock is empty")!)));
            } else if (int.tryParse(state.quantityData!.remainingStock!) !<
                quantity) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(AppLocalizations.of(context)!.translate("Max stock available is") !+
                      state.quantityData.remainingStock!)));
            } else if (int.tryParse(state.quantityData.remainingStock!) !>=
                quantity) {
              BlocProvider.of<DetailScreenBloc>(context).add(AddToCart(
                  widget.product.productId,
                  quantity,
                  int.tryParse((state.quantityData.productCombinationId??""))));
                 
            }
          } else if (state is ItemCartAdded) {
            Navigator.pop(context);
            AppData.sessionId = state.sessionId;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message!)));
          } else if (state is ProductDetailsLoaded) {
            setState(() {
              widget.product = state.product!;
            });
          } else if (state is DetailPageError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error!)));
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate("Empty")!)));
          }
        },
        builder: (context, state) {
          if (state is ProductDetailsLoaded) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    MyAppBar(
                      leadingWidget: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                            padding: EdgeInsets.all(0),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).brightness ==
                                  Brightness.dark
                                  ? Colors.white
                                  : Colors.black,),
                              onPressed: () => Navigator.of(context).pop(),
                            )
                        ),
                      ),
                      centerWidget: Center(
                          child: Text(
                            AppLocalizations.of(context)!.translate("Product Details")!,
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: "MontserratSemiBold",
                                color: Theme.of(context).brightness ==
                                  Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                                ),
                          )),
                      trailingWidget:
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: GestureDetector(
                                onTap: () => widget.navigateToNext(
                                  (AppData.user != null)?
                                  MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                      create: (context) =>
                                          CartBloc(RealCartRepo()),),
                            
                                    ],
                                    child: CartScreen(),
                                  )
                                      : SignIn(),
                                ),
                                child: Container(
                                  height: 35,
                                  width: 40,
                                  //  color: Colors.black12,
                                  child: Stack(
                                    children: [
                                      Center(child: Padding(
                                        padding: const EdgeInsets.only(right: 12,top: 5),
                                        child: Icon(Icons.shopping_cart,size: 25,
                                        color: Theme.of(context).brightness ==
                                  Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                                        ),
                                      )),
                                      Positioned(
                                          top: 0,
                                          left: 12,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Colors.red,
                                                ),
                                                height: 15,
                                                width: 15,
                                                child: Center(child: Text(BadgeItems().toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10),))),
                                          )),
                                      ValueListenableBuilder<int>(
                                        builder: (BuildContext context, int value, Widget? child) { 
                                          return
                                            Container();
                                        },
                                        valueListenable: _counter, 
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:const EdgeInsets.symmetric(
                              vertical: AppStyles.SCREEN_MARGIN_VERTICAL,
                              horizontal: AppStyles.SCREEN_MARGIN_HORIZONTAL),
                          child: ListView(
                            shrinkWrap: true,
                            physics:const NeverScrollableScrollPhysics(),
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppStyles.CARD_RADIUS),
                                child: Container(
                                    width: double.maxFinite,
                                    child: AspectRatio(
                                      aspectRatio: 1.5/1,
                                      child: Stack(
                                        // alignment: Alignment.bottomCenter,
                                        children: [
                                          CarouselSlider.builder(
                                            options: CarouselOptions(
                                              height: double.maxFinite,
                                              autoPlay: true,
                                              viewportFraction: 1.0,
                                              enableInfiniteScroll: true,
                                              initialPage: 0,
                                              autoPlayInterval:
                                              Duration(seconds: 5),
                                              enlargeCenterPage: false,
                                              autoPlayAnimationDuration:
                                              Duration(milliseconds: 500),
                                              autoPlayCurve: Curves.fastOutSlowIn,
                                              pauseAutoPlayOnTouch: false,
                                              scrollDirection: Axis.horizontal,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _sliderIndex = index;
                                                });
                                              },
                                            ),
                                            itemBuilder: (BuildContext context,
                                                int index, int realIndex) {
                                              return Container(
                                                width: double.maxFinite,
                                                height: double.maxFinite,
                                                child: CachedNetworkImage(
                                                  imageUrl: ApiProvider
                                                      .imgMediumUrlString +
                                                      widget
                                                          .product
                                                          .productGallaryDetail![
                                                      index]
                                                          .gallaryName!,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context,
                                                      url, downloadProgress) =>
                                                      Center(
                                                          child: CircularProgressIndicator(
                                                              value:
                                                              downloadProgress
                                                                  .progress)),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                     const Icon(Icons.error),
                                                ),
                                              );
                                            },
                                            itemCount: widget.product
                                                .productGallaryDetail?.length,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              margin:const EdgeInsets.only(top: 150),
                                              height: 50.0,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    width: 8.0,
                                                    height: 8.0,
                                                    margin:const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black54),
                                                      shape: BoxShape.circle,
                                                      color: _sliderIndex == index
                                                          ? Colors.white54
                                                          : Colors.transparent,
                                                    ),
                                                  );
                                                },
                                                itemCount: widget.product
                                                    .productGallaryDetail?.length,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              margin:const EdgeInsets.all(12),
                                              width: 25,
                                              height: 25,
                                             color:const Color(0x22000000),
                                              child: SvgPicture.asset(
                                                (checkForWishlist(
                                                    widget.product.productId!))
                                                    ? "assets/icons/ic_heart_filled.svg"
                                                    : "assets/icons/ic_heart.svg",
                                                fit: BoxFit.none,
                                                width: 14,
                                                height: 14,
                                                color: (false)
                                                    ? Theme.of(context)
                                                    .primaryColor
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ),
                             const SizedBox(height: 12.0),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      if (widget.product.productDiscountPrice !=
                                          0)
                                        buildLabel(
                                          AppLocalizations.of(context)!.translate("SALE")!,
                                          Theme.of(context).primaryColor,
                                        ),
                                    const SizedBox(width: 10),
                                      if (widget.product.isFeatured == 1)
                                        buildLabel(
                                          AppLocalizations.of(context)!.translate("FEATURED")!,
                                         const Color(0xFF36AFFF),
                                        ),
                                      /*SizedBox(width: 10),
                                      buildLabel(
                                        "NEW",
                                        Color(0xFF18EF35),
                                      ),*/
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (AppData.user != null) {
                                            if (checkForWishlist(
                                                widget.product.productId!)) { 
                                              for (int i = 0;
                                              i <
                                                  AppData
                                                      .wishlistData.length;
                                              i++) {
                                                if (AppData.wishlistData[i]
                                                    .productId ==
                                                    widget.product.productId) {
                                                  setState(() {
                                                    BlocProvider.of<
                                                        WishlistBloc>(
                                                        context)
                                                        .add(UnLikeProduct(
                                                        AppData
                                                            .wishlistData[i]
                                                            .wishlist!));
                                                  });
                                                  break;
                                                }
                                              }
                                            } else {
                                              BlocProvider.of<WishlistBloc>(
                                                  context)
                                                  .add(LikeProduct(widget
                                                  .product.productId!));
                                            }
                                          }
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                        ),
                                      ),
                                      SizedBox(width: 12.0),
                                      GestureDetector(
                                        onTap: () {
                                          Share.share(
                                              AppLocalizations.of(context)!.translate("Hi there, please check this app. i think you will love it. ")!);
                                        },
                                        child: Icon(
                                          Icons.share,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 12.0),
                              Text(
                                widget.product.detail!.first.title!,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: "MontserratSemiBold"),
                              ),
                              SizedBox(height: 6.0),
                              (widget.product.productDiscountPrice != 0) ?
                              Row(
                                children: [
                                  Text(
                                    AppData.currency!.code !+
                                        double.parse(widget.product.productDiscountPrice
                                            .toString())
                                            .toStringAsFixed(2),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    AppData.currency!.code !+
                                        double.parse(widget
                                            .product.productPrice
                                            .toString())
                                            .toStringAsFixed(2),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
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
                                    fontFamily: "MontserratSemiBold"),
                              ),
                              SizedBox(height: 6.0),
                              RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)!.translate("Category"),
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    TextSpan(
                                        text: widget.product.category!.first
                                            .categoryDetail!.detail!.first.name,
                                        style: TextStyle(
                                            color: Theme.of(context).brightness ==
                                                Brightness.dark
                                                ? AppStyles.COLOR_GREY_DARK
                                                : AppStyles.COLOR_GREY_LIGHT)),
                                  ])),
                              SizedBox(height: 4.0),
                              RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)!.translate('ID'),
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    TextSpan(
                                        text: widget.product.productId.toString(),
                                        style: TextStyle(
                                            color: Theme.of(context).brightness ==
                                                Brightness.dark
                                                ? AppStyles.COLOR_GREY_DARK
                                                : AppStyles.COLOR_GREY_LIGHT)),
                                  ])),
                              SizedBox(height: 4.0),
                              RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)!.translate("Tags"),
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    TextSpan(
                                        text: widget.product.productBrand == null
                                            ? ""
                                            : widget.product.productBrand!.brandName,
                                        style: TextStyle(
                                            color: Theme.of(context).brightness ==
                                                Brightness.dark
                                                ? AppStyles.COLOR_GREY_DARK
                                                : AppStyles.COLOR_GREY_LIGHT)),
                                  ])),
                              SizedBox(height: 8.0),
                              Text(
                                AppLocalizations.of(context)!.translate("Description")!,
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                    color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(height: 4.0),
                              Text(widget.product.detail!.first.desc!,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? AppStyles.COLOR_GREY_DARK
                                        : AppStyles.COLOR_GREY_LIGHT,
                                  )),
                              SizedBox(height: 4.0),
                              if (widget.product.productType ==
                                  AppConstants.PRODUCT_TYPE_VARIABLE)
                                Card(
                                  shape :RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(
                                        width: 1,
                                        color: Theme.of(context).primaryColor,
                                      )
                                  ),
                                  elevation: 5,
                                  color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor :  Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: ListTile(
                                      onTap: () {
                                        buildBottomSheet(context);
                                      },
                                      dense: true,
                                      contentPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
                                      title: Text(AppLocalizations.of(context)!.translate("Select Color, Size & Quality")!,style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white :  Colors.black),),
                                      trailing: Icon(Icons.chevron_right),
                                    ),
                                  ),
                                ),
                              if (widget.product.productType ==
                                  AppConstants.PRODUCT_TYPE_SIMPLE)
                                ListTile(
                                  dense: true,
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 0),
                                  title: Text(AppLocalizations.of(context)!.translate("Quantity")!),
                                  trailing: Container(
                                    // decoration: BoxDecoration(
                                    //   border: Border.all(
                                    //       color: Theme.of(context).brightness ==
                                    //               Brightness.dark
                                    //           ? AppStyles.COLOR_GREY_DARK
                                    //           : AppStyles.COLOR_GREY_LIGHT),
                                    //   borderRadius: BorderRadius.all(
                                    //       Radius.circular(8.0)),
                                    // ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 24,
                                          width: 24,
                                          child : MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                if (quantity > 1) quantity--;
                                              });
                                            },
                                            color: Colors.grey,
                                            textColor: Colors.white,
                                            child: Text("-",style: TextStyle(fontSize: 20),),
                                            padding: EdgeInsets.only(bottom: 3),
                                            shape: CircleBorder(),
                                          ),
                                        ),
                                        
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 22.0),
                                            child: Text(
                                              quantity.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            )),
                                        Container(
                                          height: 24,
                                          width: 24,
                                          child : MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                quantity++;
                                              });
                                            },
                                            color: Theme.of(context).primaryColor,
                                            textColor: Colors.white,
                                            child: Text("+",style: TextStyle(fontSize: 20),),
                                            padding: EdgeInsets.only(bottom: 3),
                                            shape: CircleBorder(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                          create: (BuildContext context) {
                                            return ReviewsBloc(
                                                RealReviewsRepo());
                                          },
                                          child: ReviewScreen(
                                              widget.product.productId!)),
                                    )),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded( 
                                            child: Text(AppLocalizations.of(context)!.translate("Reviews")!,style: TextStyle(color: Theme.of(context).primaryColor),),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.translate("See All")!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        AppLocalizations.of(context)!.translate("Review name")!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      SizedBox(height: 12.0),
                                      StarRating(
                                          starCount: 5,
                                          rating: widget.product
                                              .productRating !=
                                              null
                                              ? double.parse(widget
                                              .product.productRating
                                              .toString())
                                              : 0,
                                          onRatingChanged: (rating) {}),
                                      SizedBox(height: 12.0),
                                      RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:  (widget.product.productRating !=
                                                    null)
                                                    ? double.tryParse(widget
                                                    .product.productRating
                                                    .toString())
                                                    ?.toStringAsFixed(1)
                                                    : 0.0.toString(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .brightness ==
                                                        Brightness.dark
                                                        ? AppStyles
                                                        .COLOR_GREY_DARK
                                                        : AppStyles
                                                        .COLOR_GREY_LIGHT)
                                            ),
                                            TextSpan(
                                                text: " (" +
                                                    widget.product.reviews
                                                        !.length
                                                        .toString() +
                                                    AppLocalizations.of(context)!.translate("Reviews")!,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .brightness ==
                                                        Brightness.dark
                                                        ? AppStyles
                                                        .COLOR_GREY_DARK
                                                        : AppStyles
                                                        .COLOR_GREY_LIGHT)),
                                          ])),

                                      SizedBox(height: 12.0),
                                      
                                      SizedBox(height: 12.0),
                                     
                                    ],
                                  ),
                                ),
                              ),
                              //  Text("YOU MIGHT ALSO LIKE"),
                              BlocProvider(
                                create: (context) =>
                                    RelatedProductsBloc(RealProductsRepo()),
                                child: RelatedProductsWidget(
                                    widget.product.category?.first.categoryDetail
                                        ?.detail?.first.categoryId.toString(),
                                    widget.navigateToNext),
                              ),
                              //ProductsWidget(null, null),
                              SizedBox(
                                height: 75.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: AppStyles.SCREEN_MARGIN_VERTICAL,
                      horizontal: AppStyles.SCREEN_MARGIN_HORIZONTAL),
                  height: 45.0,
                  width: double.maxFinite,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    label: Text(
                        AppLocalizations.of(context)!.translate('ADD TO CART')!
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor,),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),

                            )
                        )
                    ),
                    onPressed: () {
                      print("add to cart");
                      if (widget.product.productType ==
                          AppConstants.PRODUCT_TYPE_VARIABLE)
                        buildBottomSheet(context);
                      else {
                        BlocProvider.of<DetailScreenBloc>(context).add(
                            GetQuantity(
                                widget.product.productId!, AppLocalizations.of(context)!.translate("simple")!, 1));
                      }
                    },
                    // child: Text("Add to Bag")
                  ),
                ),
              ],
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void buildBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return BottomSheetContent(widget.product, onVariationSelected);
      },
    );
  }

  void onVariationSelected(int combinationId, int quantity) {
    Navigator.pop(context);
    this.quantity = quantity;
    BlocProvider.of<DetailScreenBloc>(context)
        .add(GetQuantity(widget.product.productId!, AppLocalizations.of(context)!.translate("variable")!, combinationId));
  }

  Widget buildDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppStyles.COLOR_LITE_GREY_DARK
          : AppStyles.COLOR_LITE_GREY_LIGHT,
      thickness: 4,
    );
  }

  Widget buildSection(
      List<Widget> children, bool isDividerVisible, bool isPaddingEnabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: isPaddingEnabled
              ? EdgeInsets.symmetric(
              vertical: AppStyles.SCREEN_MARGIN_VERTICAL,
              horizontal: AppStyles.SCREEN_MARGIN_HORIZONTAL)
              : EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
        if (isDividerVisible)
          Divider(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppStyles.COLOR_LITE_GREY_DARK
                : AppStyles.COLOR_LITE_GREY_LIGHT,
            thickness: 4,
          ),
      ],
    );
  }

  Widget buildLabel(String text, Color color) {
    return Container(
      width: 70,
      height: 20,
      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 8),
        ),
      ),
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
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

int BadgeItems(){
  var s1 = AppBadge();
  print("-------------------------------------------- updated home cart    ----------------------- ${s1.getBadgeUpdate()}" );
  return s1.getBadgeUpdate();
}

/*
class RelatedProducts extends StatelessWidget {
  const RelatedProducts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: AppStyles.SCREEN_MARGIN_VERTICAL),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppStyles.GRID_SPACING,
        mainAxisSpacing: AppStyles.GRID_SPACING,
        childAspectRatio: 0.75,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppStyles.CARD_RADIUS),
            child: new Card(
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
                                BorderRadius.circular(AppStyles.CARD_RADIUS),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://i.pinimg.com/originals/66/f1/6e/66f16eee76fa106a4cc160cbf6a58611.jpg",
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "This is large text title for product. This is large text title for product. ",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "\$1200.00",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "\$1200.00",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                decoration:
                                                    TextDecoration.lineThrough),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Center(
                              child: Text("-67%",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 8)),
                            )),
                        Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Center(
                              child: IconTheme(
                                  data: IconThemeData(color: Colors.white),
                                  child: Icon(
                                    Icons.favorite_border,
                                    size: 18,
                                  )),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
*/

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;

  StarRating(
      {this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      onTap:
      onRatingChanged == null ? null : () => onRatingChanged!(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        mainAxisSize: MainAxisSize.min,
        children:
        new List.generate(starCount, (index) => buildStar(context, index)));
  }
}

// ignore: must_be_immutable
class BottomSheetContent extends StatefulWidget {
  Product product;
  Function(int combinationId, int quantity) onVariationSelected;

  BottomSheetContent(this.product, this.onVariationSelected);

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
   ProductCombination? selectedCombination;
  String selectionText = "";
  List<ProductAttributeVariations> selectedVariations = [];
  int quantity = 1;

  @override
  void initState() {
    super.initState();

    //selection of first / first variation.
    selectedVariations = [];
    for (int i = 0; i < widget.product.attribute!.length; i++) {
      selectedVariations.add(widget.product.attribute![i].variations!.first);
    }
selectedCombination=widget.product.productCombination![0];
    findCombination();
  }

/*
  void findCombination() {
    //finding the combination for selected variations.
    for (int combinationIndex = 0;
        combinationIndex < widget.product.productCombination.length;
        combinationIndex++) {
      if (checkForSelectedCombination(
          widget.product.productCombination[combinationIndex].combination,
          selectedVariations)) {
        selectedCombination =
            widget.product.productCombination[combinationIndex];
      }
    }
    selectionText = "";
    for (int i = 0; i < selectedCombination.combination.length; i++) {
      selectionText = (i == 0)
          ? selectedCombination.combination[i].variation.detail.first.name
          : selectionText +
              ", " +
              selectedCombination.combination[i].variation.detail.first.name;
    }
  }
*/

  void findCombination() {
    //finding the combination for selected variations.

    int found = 0;
    for (int i = 0; i < widget.product.productCombination!.length; i++) {
      ProductCombination combinations = widget.product.productCombination![i];
      found = 0;
      for (int j = 0; j < selectedVariations.length; j++) {
        ProductAttributeVariations inner = selectedVariations[j];
        for (int k = 0; k < combinations.combination!.length; k++) {
          Combination element = combinations.combination![k];
          if (element.variationId == inner.productVariation!.id) {
            found++;
          }
        }
        if (found == this.selectedVariations.length)
          this.selectedCombination = combinations;

      }
    }

   
     selectionText = "";
    for (int i = 0; i < selectedCombination!.combination!.length; i++) {
      selectionText = ((i == 0)
          ? selectedCombination?.combination![i].variation!.detail!.first.name
          : selectionText +
          ", " +
          selectedCombination!.combination![i].variation!.detail!.first.name!)!;
    }
   
  }

  bool checkForSelectedCombination(List<Combination> combination,
      List<ProductAttributeVariations> selectedVariations) {
    for (int i = 0; i < selectedVariations.length; i++) {
      if (combination[i].variationId !=
          selectedVariations[i].productVariation?.id) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),

        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor :  Color(0xffF6F6F6),
      ),
      // color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor :  Color(0xffF6F6F6),
      padding: EdgeInsets.symmetric(
          horizontal: AppStyles.SCREEN_MARGIN_HORIZONTAL,
          vertical: AppStyles.SCREEN_MARGIN_VERTICAL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Center(child: Container(
            width: 70,
            height: 4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)
                ),

                color: Color(0xffCCCCCC)
            ),
          )),
          SizedBox(height: 20,),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    AppStyles.CARD_RADIUS),
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  child: CachedNetworkImage(
                    imageUrl: ApiProvider.imgMediumUrlString +
                        selectedCombination!.gallary!.gallaryName!,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppData.currency!.code !+
                        double.tryParse((selectedCombination!.price !* quantity)
                            .toString())
                            !.toStringAsFixed(2),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.translate("Selection"),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        TextSpan(
                            text: selectionText,
                            style: TextStyle(
                                color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppStyles.COLOR_GREY_DARK
                                    : AppStyles.COLOR_GREY_LIGHT)),
                      ])),
                ],
              )
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.product.attribute?.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16.0,
                ),
                Text(widget
                    .product.attribute![index].attributes!.detail!.first.name!),
                SizedBox(
                  height: 12.0,
                ),
                ChoiceChips(
                  chipName: widget.product.attribute![index].variations!,
                  choiceChipsCallback: (variation) {
                    setState(() {
                      selectedVariations[index] = variation;
                      findCombination();
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(AppLocalizations.of(context)!.translate("Quantity")!),
          SizedBox(
            height: 12.0,
          ),
          Container(

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 24,
                  width: 24,
                  child : MaterialButton(
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) quantity--;
                      });
                    },
                    color: Colors.grey,
                    textColor: Colors.white,
                    child: Text("-",style: TextStyle(fontSize: 20),),
                    padding: EdgeInsets.only(bottom: 3),
                    shape: CircleBorder(),
                  ),
                ),
                // IconButton(
                //     icon: Icon(Icons.chevron_left),
                //     onPressed: () {
                //       setState(() {
                //         if (quantity > 1) quantity--;
                //       });
                //     }),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.0),
                    child: Text(
                      quantity.toString(),
                      style: Theme.of(context).textTheme.subtitle1,
                    )),
                // IconButton(
                //     icon: Icon(Icons.chevron_right),
                //     onPressed: () {
                //       setState(() {
                //         quantity++;
                //       });
                //     }),
                Container(
                  height: 24,
                  width: 24,
                  child : MaterialButton(
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text("+",style: TextStyle(fontSize: 20),),
                    padding: EdgeInsets.only(bottom: 3),
                    shape: CircleBorder(),
                  ),
                ),

              ],
            ),
          ),
          SizedBox(
            height: 80.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: AppStyles.SCREEN_MARGIN_VERTICAL),
            height: 45.0,
            width: double.maxFinite,
            child: ElevatedButton(
                style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor,),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),

                        )
                    )
                ),
                onPressed: () {
                  widget.onVariationSelected(
                      selectedCombination!.productCombinationId!, quantity);
                },
                child: Text(AppLocalizations.of(context)!.translate("Continue")!)),
          ),
        ],
      ),
    );
  }
}

typedef void ChoiceChipsCallback(ProductAttributeVariations variation);

class ChoiceChips extends StatefulWidget {
  final List<ProductAttributeVariations>? chipName;
  final ChoiceChipsCallback? choiceChipsCallback;

  ChoiceChips({Key? key, this.chipName, this.choiceChipsCallback})
      : super(key: key);

  @override
  _ChoiceChipsState createState() => _ChoiceChipsState();
}

class _ChoiceChipsState extends State<ChoiceChips> {
  String _selected = "";

  @override
  void initState() {
    super.initState();
    _selected = widget.chipName!.first.productVariation!.detail!.first.name!;
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.chipName?.forEach((item) {
      choices.add(Container(
        child: FilterChip(
          checkmarkColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.transparent,
          label: Text(item.productVariation!.detail!.first.name!),
          labelStyle: TextStyle(
              color: _selected == item.productVariation!.detail!.first.name
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).brightness == Brightness.dark
                  ? AppStyles.COLOR_GREY_DARK
                  : AppStyles.COLOR_GREY_LIGHT),
          // shape: RoundedRectangleBorder(
          //   side: BorderSide(
          //       color: _selected == item.productVariation.detail.first.name
          //           ? Colors.transparent
          //           : Theme.of(context).brightness == Brightness.dark
          //               ? AppStyles.COLOR_GREY_DARK
          //               : AppStyles.COLOR_GREY_LIGHT,
          //       width: 1),
          //   borderRadius: BorderRadius.circular(5),
          // ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: _selected == item.productVariation!.detail!.first.name ? Theme.of(context).primaryColor : Colors.grey,
                width: 1
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          selectedColor: Colors.transparent,
          selected: _selected == item.productVariation!.detail!.first.name,
          onSelected: (selected) {
            setState(() {
              _selected = item.productVariation!.detail!.first.name!;
              widget.choiceChipsCallback!(item);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      runSpacing: 3.0,
      children: _buildChoiceList(),
    );
  }
}
