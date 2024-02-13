import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/api/api_provider.dart';
import 'package:flutter_kundol/blocs/wishlist/wishlist_bloc.dart';
import 'package:flutter_kundol/blocs/wishlist_detail/wishlist_detail_bloc.dart';
import 'package:flutter_kundol/constants/app_constants.dart';
import 'package:flutter_kundol/constants/app_data.dart';
import 'package:flutter_kundol/constants/app_styles.dart';
import 'package:flutter_kundol/ui/widgets/app_bar.dart';
import 'package:flutter_kundol/ui/widgets/card_style_fav.dart';
import 'package:flutter_kundol/ui/widgets/card_style_new_1.dart';
import 'package:flutter_kundol/ui/widgets/home_app_bar.dart';

class FavFragment extends StatefulWidget {
  final Function(Widget widget) navigateToNext;
  final Function() openDrawer;

  const FavFragment(this.navigateToNext, this.openDrawer);

  @override
  _FavFragmentState createState() => _FavFragmentState();
}

class _FavFragmentState extends State<FavFragment> {
  final _scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    getProduct(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor :  Colors.white,

      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0), // here the desired height
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(context).cardColor,
          )
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HomeAppBar(widget.navigateToNext, widget.openDrawer),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppStyles.SCREEN_MARGIN_HORIZONTAL,
                    vertical: AppStyles.SCREEN_MARGIN_VERTICAL),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocBuilder<WishlistProductsBloc, WishlistProductsState>(
                      builder: (context, state) {
                        switch (state.status) {
                          case WishlistProductsStatus.success:
                            isLoadingMore = false;
                            if (state.wishlistData!.isEmpty)
                              return Center(child: Text("Empty"));
                            else
                              return Column(
                                children: [
                                  GridView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: AppStyles.GRID_SPACING,
                                      mainAxisSpacing: AppStyles.GRID_SPACING,
                                      childAspectRatio: 0.75,
                                    ),
                                    itemCount: state.wishlistData?.length,
                                    itemBuilder: (context, index) {
                                      return CardStyleFav(widget.navigateToNext,
                                          state.wishlistData![index].products!);
                                    },
                                  ),
                                  if (!state.hasReachedMax! &&
                                      state.wishlistData!.isNotEmpty &&
                                      state.wishlistData!.length % 10 == 0)
                                    Center(
                                      child: Container(
                                          margin: EdgeInsets.all(16.0),
                                          width: 24.0,
                                          height: 24.0,
                                          child: CircularProgressIndicator()),
                                    ),
                                ],
                              );
                            break;
                          case WishlistProductsStatus.failure:
                            return Text("Error");
                          default:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom && !isLoadingMore) {
      isLoadingMore = true;
      getProduct(context);
    }
  }
 
  void getProduct(context) {
    BlocProvider.of<WishlistProductsBloc>(context).add(GetWishlistProducts());
  }

  bool checkForWishlist(int productId) {
    for (int i = 0; i < AppData.wishlistData.length; i++) {
      if (productId == AppData.wishlistData[i].productId) {
        return true;
      }
    }
    return false;
  }
}
