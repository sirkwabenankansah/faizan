import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/constants/app_constants.dart';
import 'package:flutter_kundol/models/products/product.dart';
import 'package:flutter_kundol/repos/products_repo.dart';

part 'products_search_event.dart';

part 'products_search_state.dart';

class ProductsSearchBloc extends Bloc<ProductsSearchEvent, ProductsSearchState> {
  final ProductsRepo productsRepo;

  ProductsSearchBloc(this.productsRepo)
      : super(const ProductsSearchState(
      status: ProductsSearchStatus.initial,
      hasReachedMax: false,
      products: [],
      pageNo: 1));

  @override
  Stream<ProductsSearchState> mapEventToState(ProductsSearchEvent event) async* {
    if (event is GetSearchProducts) {
      yield const ProductsSearchState(
          status: ProductsSearchStatus.loading,
          hasReachedMax: false,
          products: [],
          pageNo: 1);
      yield await _mapProductsFetchedToState(event, state);
    }
  }

  Future<ProductsSearchState> _mapProductsFetchedToState(GetSearchProducts event, ProductsSearchState state) async {
    if (state.hasReachedMax!) return state;
    try {
      if (state.status == ProductsSearchStatus.initial) {
        final products = await _fetchProducts(event.keyword, state.pageNo);
        return state.copyWith(
          status: ProductsSearchStatus.success,
          products: products,
          hasReachedMax: false,
        );
      }
      final products = await _fetchProducts(event.keyword, state.pageNo);
      return state.copyWith(
        status: ProductsSearchStatus.success,
        products: products,
        hasReachedMax: false,
        pageNo: state.pageNo,
      );
    } on Exception {
      return state.copyWith(status: ProductsSearchStatus.failure);
    }
  }

  Future<List<Product>> _fetchProducts([String? keyword, int pageNumber = 1]) async {
    final response = await productsRepo.fetchSearchProducts(keyword!, pageNumber);
    if (response.status == AppConstants.STATUS_SUCCESS &&
        response.data != null) {
      return response.data!;
    } else {
      return [];
    }
  }
}
