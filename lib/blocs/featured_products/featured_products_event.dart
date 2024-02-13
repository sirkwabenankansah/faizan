
part of 'featured_products_bloc.dart';

abstract class FeaturedProductsEvent extends Equatable {
  const FeaturedProductsEvent();
}

class GetFeaturedProducts extends FeaturedProductsEvent {
  const GetFeaturedProducts();

  @override
  List<Object> get props => [];
}
