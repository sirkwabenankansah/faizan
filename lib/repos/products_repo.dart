import 'package:flutter_kundol/api/api_provider.dart';
import 'package:flutter_kundol/api/responses/product_detail_response.dart';
import 'package:flutter_kundol/api/responses/products_response.dart';

abstract class ProductsRepo {
  Future<ProductsResponse> fetchProducts(int pageNo);
  Future<ProductsResponse> fetchTopSellingProducts(int pageNo);
  Future<ProductsResponse> fetchSuperDealsProducts(int pageNo);
  Future<ProductsResponse> fetchFeaturedProducts(int pageNo);
  Future<ProductsResponse> fetchProductsByCat(int pageNo, String categoryId, String sortBy, String sortType, String filters);
  Future<ProductsResponse> fetchSearchProducts(String keyword, int pageNo);
  Future<ProductDetailResponse> fetchProductById(int productId);
}

class RealProductsRepo implements ProductsRepo {
  ApiProvider _apiProvider = ApiProvider();

  @override
  Future<ProductsResponse> fetchProducts(int pageNo) {
    return _apiProvider.getProducts(pageNo);
  }

  @override
  Future<ProductsResponse> fetchProductsByCat(int pageNo, String categoryId, String sortBy, String sortType, String filters) {
    return _apiProvider.getProductsByCat(pageNo, categoryId, sortBy, sortType, filters);
  }

  @override
  Future<ProductsResponse> fetchSearchProducts(String keyword, int pageNo) {
    return _apiProvider.getSearchProducts(keyword, pageNo);
  }

  @override
  Future<ProductDetailResponse> fetchProductById(int productId) {
    return _apiProvider.getProductById(productId.toString());
  }

  @override
  Future<ProductsResponse> fetchFeaturedProducts(int pageNo) {
    return _apiProvider.getFeaturedProducts(pageNo);
  }

  @override
  Future<ProductsResponse> fetchSuperDealsProducts(int pageNo) {
    return _apiProvider.getDealsProducts(pageNo);
  }

  @override
  Future<ProductsResponse> fetchTopSellingProducts(int pageNo) {
    return _apiProvider.getTopSellingProducts(pageNo);
  }
}

class FakeProductsRepo implements ProductsRepo {
  @override
  Future<ProductsResponse> fetchProducts(int pageNo) {
    throw UnimplementedError();
  }

  @override
  Future<ProductsResponse> fetchProductsByCat(int pageNo, String categoryId, String sortBy, String sortType, String filters) {
    throw UnimplementedError();
  }

  @override
  Future<ProductsResponse> fetchSearchProducts(String keyword, int pageNo) {
    throw UnimplementedError();
  }

  @override
  Future<ProductDetailResponse> fetchProductById(int productId) {
    throw UnimplementedError();
  }

  @override
  Future<ProductsResponse> fetchFeaturedProducts(int pageNo) {
    throw UnimplementedError();
  }

  @override
  Future<ProductsResponse> fetchSuperDealsProducts(int pageNo) {
    throw UnimplementedError();
  }

  @override
  Future<ProductsResponse> fetchTopSellingProducts(int pageNo) {
    throw UnimplementedError();
  }
}
