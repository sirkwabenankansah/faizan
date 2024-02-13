import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/api/api_provider.dart';
import 'package:flutter_kundol/api/responses/settings_response.dart';
import 'package:flutter_kundol/blocs/banners/banners_bloc.dart';
import 'package:flutter_kundol/blocs/categories/categories_bloc.dart';
import 'package:flutter_kundol/blocs/detail_screen/detail_screen_bloc.dart';
import 'package:flutter_kundol/blocs/products_by_category/products_by_cat_bloc.dart';
import 'package:flutter_kundol/constants/app_constants.dart';
import 'package:flutter_kundol/constants/app_data.dart';
import 'package:flutter_kundol/constants/app_styles.dart';
import 'package:flutter_kundol/models/banners/banner.dart';
import 'package:flutter_kundol/models/category.dart';
import 'package:flutter_kundol/models/products/product.dart';
import 'package:flutter_kundol/repos/cart_repo.dart';
import 'package:flutter_kundol/repos/products_repo.dart';

import '../../tweaks/app_localization.dart';
import '../detail_screen.dart';
import '../shop_screen.dart';

class BannerSlider extends StatefulWidget {
  final Function(Widget widget) navigateToNext;

  const BannerSlider(this.navigateToNext);

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _currentIndex = 0;

  late BannersBloc bannersBloc;

  @override
  void initState() {
    super.initState();

    bannersBloc = BlocProvider.of<BannersBloc>(context);
    bannersBloc.add(const GetBanners());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoaded){
          List<Category> categories = state.categoriesResponse.data!;
          return BlocBuilder<BannersBloc, BannersState>(
            bloc: bannersBloc,
            builder: (context, state) {
              if (state is BannersLoaded) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppStyles.CARD_RADIUS),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.4/1,
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            autoPlay: true,
                            viewportFraction: 1.0,
                            enableInfiniteScroll: true,
                            initialPage: 0,
                            height: 260,
                            autoPlayInterval: const Duration(seconds: 5),
                            enlargeCenterPage: false,
                            autoPlayAnimationDuration: const Duration(milliseconds: 500),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            pauseAutoPlayOnTouch: false,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            return GestureDetector(
                                onTap: () {
                                  if(state.bannersResponse.data![index].bannerNavigation?.name == AppConstants.BANNER_NAVIGATION_TYPE_CATEGORY) {

                                    Category category = getCategoryObject(categories,int.parse(state.bannersResponse.data![index].bannerRefId!));

                                    if(category != null) {
                                      widget.navigateToNext(BlocProvider(
                                          create: (BuildContext context) {
                                            return ProductsByCatBloc(
                                                RealProductsRepo(),
                                                BlocProvider.of<CategoriesBloc>(
                                                    context),
                                               int.parse( state.bannersResponse.data![index]
                                                   .bannerRefId.toString()),
                                                "id",
                                                "ASC",
                                                "");
                                          },
                                          child: ShopScreen(category, widget.navigateToNext)));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                                          AppLocalizations.of(context)!.translate("Can't find Category")!
                                      )));
                                    }
                                  } else if(state.bannersResponse.data![index].bannerNavigation?.name == AppConstants.BANNER_NAVIGATION_TYPE_PRODUCT) {
                                    Product product = Product();
                                    product.productId = int.parse(state.bannersResponse.data![index].bannerRefId.toString());
                                    widget.navigateToNext(
                                      BlocProvider(
                                          create: (context) => DetailScreenBloc(RealCartRepo(), RealProductsRepo()),
                                          child: ProductDetailScreen(product, widget.navigateToNext)),
                                    );
                                  } else {
                                    Category category = categories[0];

                                    if(category != null) {
                                      widget.navigateToNext(BlocProvider(
                                          create: (BuildContext context) {
                                            return ProductsByCatBloc(
                                                RealProductsRepo(),
                                                BlocProvider.of<CategoriesBloc>(
                                                    context),
                                                category.id,
                                                "id",
                                                "ASC",
                                                "");
                                          },
                                          child: ShopScreen(category, widget.navigateToNext)));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                                          AppLocalizations.of(context)!.translate("Can't find Category")!
                                      )
                                      ));
                                    }
                                  }
                                },
                                child: SizedBox(
                                    width: double.maxFinite,
                                    child: getDefaultBanner(state.bannersResponse.data![index])));
                          },
                          itemCount: state.bannersResponse.data?.length,
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin:
                              const EdgeInsets.symmetric(vertical: 12, horizontal: 2.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? Colors.white54
                                    : Colors.transparent,
                              ),
                            );
                          },
                          itemCount: state.bannersResponse.data?.length,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is BannersError) {
                return Text(state.error);
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                  ),
                );
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget getDefaultBanner(BannerData data) {
    switch (int.parse(
        AppData.settingsResponse!.getKeyValue(SettingsResponse.BANNER_STYLE))) {
      case 1:
        return CachedNetworkImage(
          imageUrl: ApiProvider.imgMediumUrlString + data.gallary!,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress,color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,)),
          errorWidget: (context, url, error) => SizedBox(
              width: double.maxFinite,
              child: Image.asset("assets/images/placeholder.png",
                  fit: BoxFit.cover)),
        );
      case 2:
        return Center(
          child: Text( AppLocalizations.of(context)!.translate("Banner Style 2")!),
        );
      case 3:
        return Center(
          child: Text( AppLocalizations.of(context)!.translate("Banner Style 3")!),
        );
      case 4:
        return Center(
          child: Text( AppLocalizations.of(context)!.translate("Banner Style 4")!),
        );
      case 5:
        return Center(
          child: Text( AppLocalizations.of(context)!.translate("Banner Style 5")!),
        );
      case 6:
        return Center(
          child: Text( AppLocalizations.of(context)!.translate("Banner Style 6")!),
        );
      default:
        return CachedNetworkImage(
          imageUrl: ApiProvider.imgMediumUrlString + data.gallary!,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress,color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,)),
          errorWidget: (context, url, error) => SizedBox(
              width: double.maxFinite,
              child: Image.asset("assets/images/placeholder.png",
                  fit: BoxFit.cover)),
        );
    }
  }

  Category getCategoryObject(List<Category> categories, int id) {
    for (int i=0; i<categories.length; i++) {
      if (categories[i].id == id) {
        return categories[i];
      }
    }
    return null!;
  }
}
