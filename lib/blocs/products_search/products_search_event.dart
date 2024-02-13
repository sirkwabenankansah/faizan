part of 'products_search_bloc.dart';

abstract class ProductsSearchEvent extends Equatable {
  const ProductsSearchEvent();
}

class GetSearchProducts extends ProductsSearchEvent {
  final String keyword;
  const GetSearchProducts(this.keyword);

  @override
  List<Object> get props => [keyword];
}
