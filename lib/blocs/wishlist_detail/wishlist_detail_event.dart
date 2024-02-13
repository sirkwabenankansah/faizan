
part of 'wishlist_detail_bloc.dart';

abstract class WishlistDetailEvent extends Equatable {
  const WishlistDetailEvent();
}

class GetWishlistProducts extends WishlistDetailEvent {

  const GetWishlistProducts();

  @override
  List<Object> get props => [];
}

class RefreshWishlistProducts extends WishlistDetailEvent {

  const RefreshWishlistProducts();

  @override
  List<Object> get props => [];
}
