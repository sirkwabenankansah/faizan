import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/api/api_provider.dart';
import 'package:flutter_kundol/blocs/categories/categories_bloc.dart';
import 'package:flutter_kundol/blocs/products_by_category/products_by_cat_bloc.dart';
import 'package:flutter_kundol/constants/app_styles.dart';
import 'package:flutter_kundol/repos/products_repo.dart';
import 'package:flutter_kundol/ui/shop_screen.dart';

import '../../tweaks/app_localization.dart';

class CategoryWidget extends StatefulWidget {
  final Function(Widget widget) navigateToNext;

  const CategoryWidget(this.navigateToNext, {Key? key}) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoriesBloc>(context).add(const GetCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
              child: Text((AppLocalizations.of(context)!.translate('shop by category'))!.toUpperCase(),
                style: Theme.of(context).textTheme.subtitle1)),
          BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoaded) {
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.categoriesResponse.data!.length > 10 ? 10 : state.categoriesResponse.data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: AppStyles.GRID_SPACING,
                      childAspectRatio: 0.9,
                      mainAxisSpacing: AppStyles.GRID_SPACING),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        widget.navigateToNext(BlocProvider(
                            create: (BuildContext context) {
                              return ProductsByCatBloc(
                                  RealProductsRepo(),
                                  BlocProvider.of<CategoriesBloc>(context),
                                  state.categoriesResponse.data![index].id,
                                  "id",
                                  "ASC",
                                  "");
                            },
                            child: ShopScreen(state.categoriesResponse.data![index], widget.navigateToNext)));
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(AppStyles.CARD_RADIUS),
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: ApiProvider.imgMediumUrlString +
                                        state.categoriesResponse.data![index].gallary!,
                                    fit: BoxFit.cover,
                                    height: double.maxFinite,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) => Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress,color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,)),
                                    errorWidget: (context, url, error) =>
                                         Icon(Icons.error,color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor,),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: double.infinity,
                                      height: 16,
                                      color: const Color(0xffF1435A),
                                      child: Text(
                                        state.categoriesResponse.data![index].name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 11.0, fontWeight: FontWeight.w300,color: Colors.white),
                                        textAlign: TextAlign.center,

                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              } else if (state is CategoriesError) {
                return Text(state.error);
              } else {
                return Center(
                  child: CircularProgressIndicator(
                  color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
