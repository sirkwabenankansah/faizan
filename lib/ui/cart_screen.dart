import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/api/api_provider.dart';
import 'package:flutter_kundol/blocs/address/address_bloc.dart';
import 'package:flutter_kundol/blocs/cart/cart_bloc.dart';
import 'package:flutter_kundol/constants/app_constants.dart';
import 'package:flutter_kundol/constants/app_data.dart';
import 'package:flutter_kundol/constants/app_styles.dart';
import 'package:flutter_kundol/models/coupon_data.dart';
import 'package:flutter_kundol/repos/address_repo.dart';
import 'package:flutter_kundol/repos/shipmentcity_repo.dart';
import 'package:flutter_kundol/ui/shipping_screen.dart';
import 'package:flutter_svg/svg.dart';
import '../api/responses/shipment_city.dart';
import '../tweaks/app_localization.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  TextEditingController _couponTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartBloc>(context).add(GetCart());
  }

  @override
  Widget build(BuildContext context) {
    CouponData? couponData;
    List<ShipmentCitysResponse> cityItems;
    double subtotal = 0;
    double shipping = 0;
    double discount = 0;
    double tax = 0;
    double orderTotal = 0;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).scaffoldBackgroundColor
          : Color(0xffF6F6F6),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
        title: Text(AppLocalizations.of(context)!.translate("Cart")!,
            style: Theme.of(context).textTheme.headline6),
        elevation: 0,
      ),
      body: BlocConsumer(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is CartCouponError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
            BlocProvider.of<CartBloc>(context).add(GetCart());
          } else if (state is CartDeleted) {
            BlocProvider.of<CartBloc>(context).add(GetCart());
          } else if (state is CouponApplied) {
            couponData = state.couponData;
            BlocProvider.of<CartBloc>(context).add(GetCart());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!
                    .translate("Coupon Added Successfully")!)));
          }
        },
        bloc: BlocProvider.of<CartBloc>(context),
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.cartData.isNotEmpty) {
              subtotal = 0;
              shipping = 0;
              tax = 0;
              orderTotal = 0;
              for (int i = 0; i < state.cartData.length; i++) {
                subtotal += (double.parse(state.cartData[i].price.toString()) *
                    (double.parse(state.cartData[i].qty.toString())));
                //shipping = 0;
                //tax = 0;
                orderTotal = subtotal;
              }
              if (couponData != null) if (couponData?.type ==
                  AppConstants.COUPON_TYPE_FIXED) {
                discount = double.parse(couponData!.amount.toString());
              } else if (couponData?.type ==
                  AppConstants.COUPON_TYPE_PERCENTAGE) {
                discount = (double.parse(couponData!.amount.toString()) / 100) *
                    subtotal;
              }
              orderTotal = orderTotal - discount;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: AppStyles.SCREEN_MARGIN_VERTICAL,
                            horizontal: AppStyles.SCREEN_MARGIN_HORIZONTAL),
                        child: Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              itemCount: state.cartData.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) =>
                                  Container(
                                child: Row(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            AppStyles.CARD_RADIUS),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              ApiProvider.imgMediumUrlString +
                                                  state
                                                      .cartData[index]
                                                      .productGallary!
                                                      .gallaryName!,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress)),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        width: double.maxFinite,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.cartData[index]
                                                  .productDetail![0].title!
                                                  .trim(),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              softWrap: false,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily:
                                                      "MontserratSemiBold"),
                                            ),
                                            Text(
                                              AppData.currency!.code! +
                                                  double.tryParse(state
                                                          .cartData[index].price
                                                          .toString())!
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            SizedBox(height: 8.0),
                                            RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .translate("Category"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    ?.copyWith(fontSize: 11),
                                              ),
                                              TextSpan(
                                                  text: state
                                                      .cartData[index]
                                                      .categoryDetail
                                                      ?.first
                                                      .categoryDetail
                                                      ?.detail
                                                      ?.first
                                                      .name,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? AppStyles
                                                              .COLOR_GREY_DARK
                                                          : AppStyles
                                                              .COLOR_GREY_LIGHT,
                                                      fontSize: 11)),
                                            ])),
                                            RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .translate("Quantity"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    ?.copyWith(fontSize: 11),
                                              ),
                                              TextSpan(
                                                  text: state
                                                      .cartData[index].qty
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? AppStyles
                                                              .COLOR_GREY_DARK
                                                          : AppStyles
                                                              .COLOR_GREY_LIGHT,
                                                      fontSize: 11)),
                                            ])),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: IconButton(
                                        icon: SvgPicture.asset(
                                            "assets/icons/ic_delete.svg",
                                            fit: BoxFit.none),
                                        onPressed: () {
                                          BlocProvider.of<CartBloc>(context)
                                              .add(DeleteCartItem(
                                                  int.parse(state
                                                      .cartData[index].productId
                                                      .toString()),
                                                  state.cartData[index]
                                                      .productCombinationId));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(height: 15);
                              },
                            ),
                            SizedBox(height: 10),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppStyles.CARD_RADIUS),
                              child: Container(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Theme.of(context).cardColor
                                    : Colors.white,
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .translate(
                                                        "Promo Code / Vouchers")!,
                                              ),
                                            ),
                                            Icon(Icons.arrow_drop_down_sharp),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Container(
                                          // padding: EdgeInsets.symmetric(
                                          //     horizontal: 12.0),
                                          padding: EdgeInsets.only(
                                              bottom: 4, left: 12),
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xffCDD2D3),
                                                width: 1.0), // set border width
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    10.0)), // set rounded corner radius
                                          ),
                                          child: TextField(
                                            controller: _couponTextController,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: AppLocalizations.of(
                                                      context)!
                                                  .translate("Enter Code Here"),
                                              hintStyle: TextStyle(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppStyles
                                                          .COLOR_GREY_DARK
                                                      : AppStyles
                                                          .COLOR_GREY_LIGHT,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: double.maxFinite,
                                          child: Row(
                                            children: [
                                              if (discount != 0)
                                                Expanded(
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _couponTextController
                                                              .clear();
                                                          discount = 0.0;
                                                        });
                                                      },
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  "Remove")!)),
                                                ),
                                              Expanded(
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                              Color>(Theme.of(
                                                                          context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Theme.of(
                                                                      context)
                                                                  .scaffoldBackgroundColor
                                                              : Color(
                                                                  0xffCDD2D3)),
                                                    ),
                                                    onPressed: () {
                                                      if (_couponTextController
                                                          .text
                                                          .toString()
                                                          .trim()
                                                          .isNotEmpty) {
                                                        BlocProvider.of<
                                                                    CartBloc>(
                                                                context)
                                                            .add(ApplyCoupon(
                                                                _couponTextController
                                                                    .text
                                                                    .toString()
                                                                    .trim()));
                                                      }
                                                    },
                                                    child: Text(AppLocalizations
                                                            .of(context)!
                                                        .translate("Apply")!)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppStyles.CARD_RADIUS),
                              child: Container(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Theme.of(context).cardColor
                                    : Colors.white,
                                padding: EdgeInsets.fromLTRB(12, 15, 12, 15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(AppLocalizations.of(context)!
                                            .translate("Subtotal")!),
                                        Text(AppData.currency!.code! +
                                            subtotal.toStringAsFixed(2)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(AppLocalizations.of(context)!
                                            .translate("Estimated Shipping")!),
                                        Text(AppData.currency!.code! + "0.00"),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(AppLocalizations.of(context)!
                                            .translate("Tax")!),
                                        Text(AppData.currency!.code! + "0.00"),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(AppLocalizations.of(context)!
                                            .translate("Discount")!),
                                        Text(AppData.currency!.code! +
                                            discount.toStringAsFixed(2)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(AppLocalizations.of(context)!
                                            .translate("Order Total")!),
                                        Text(
                                          AppData.currency!.code! +
                                              orderTotal.toStringAsFixed(2),
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: AppStyles.SCREEN_MARGIN_VERTICAL,
                        horizontal: AppStyles.SCREEN_MARGIN_HORIZONTAL),
                    width: double.maxFinite,
                    height: 40.0,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                      create: (BuildContext context) {
                                        return AddressBloc(RealAddressRepo())
                                          ..add(GetAddress());
                                      },
                                      // ignore: null_check_always_fails
                                      child: ShippingScreen(state.cartData,
                                          couponData, ))));
                        },
                        child: Text(AppLocalizations.of(context)!
                            .translate("Proceed to Checkout")!)),
                  ),
                ],
              );
            } else {
              return Center(
                  child:
                      Text(AppLocalizations.of(context)!.translate("Empty")!));
            }
          } else if (state is CartLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}
