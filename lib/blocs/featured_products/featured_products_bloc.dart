import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/constants/app_constants.dart';
import 'package:flutter_kundol/models/products/product.dart';
import 'package:flutter_kundol/repos/products_repo.dart';

part 'featured_products_event.dart';

part 'featured_products_state.dart';

class FeaturedProductsBloc
    extends Bloc<FeaturedProductsEvent, FeaturedProductsState> {
  final ProductsRepo productsRepo;

  FeaturedProductsBloc(this.productsRepo)
      : super(const FeaturedProductsState(
      status: FeaturedProductsStatus.initial,
      hasReachedMax: false,
      products: [],
      pageNo: 1));

  @override
  Stream<FeaturedProductsState> mapEventToState(FeaturedProductsEvent event) async* {
    if (event is GetFeaturedProducts) yield await _mapProductsFetchedToState(state);
  }

  Future<FeaturedProductsState> _mapProductsFetchedToState(FeaturedProductsState state) async {
    if (state.hasReachedMax!) return state;
    try {
      if (state.status == FeaturedProductsStatus.initial) {
        final products = await _fetchProducts(state.pageNo);
        return state.copyWith(
          status: FeaturedProductsStatus.success,
          products: products,
          hasReachedMax: false,
        );
      }
      final products = await _fetchProducts(state.pageNo + 1);
      return products.isEmpty
          ? state.copyWith(hasReachedMax: true, pageNo: state.pageNo + 1)
          : state.copyWith(
        status: FeaturedProductsStatus.success,
        products: List.of(state.products!)..addAll(products),
        hasReachedMax: false,
        pageNo: state.pageNo + 1,
      );
    } on Exception {
      return state.copyWith(status: FeaturedProductsStatus.failure);
    }
  }

  Future<List<Product>> _fetchProducts([int pageNumber = 1]) async {
    final response = await productsRepo.fetchFeaturedProducts(pageNumber);
    if (response.status == AppConstants.STATUS_SUCCESS &&
        response.data != null) {
      return response.data!;
    } else {
      return [];
    }
  }

}
