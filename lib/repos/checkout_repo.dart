import 'package:flutter_kundol/api/api_provider.dart';
import 'package:flutter_kundol/api/responses/order_place_response.dart';

abstract class CheckoutRepo {
  Future<OrderPlaceResponse> placeOrder(
      String billingFirstName,
      String billingLastName,
      String billingStreetAddress,
      String billingCity,
      String billingPostCode,
      int billingCountry,
      int billingState,
      String billingPhone,
      String deliveryFirstName,
      String deliveryLastName,
      String deliveryStreetAddress,
      String deliveryCity,
      String deliveryPostCode,
      int deliveryCountry,
      int deliveryState,
      String deliveryPhone,
      int currencyId,
      int languageId,
      String paymentMethod,
      String latLng,
      String cardNumber,
      String cvc,
      String expMonth,
      String expYear);
}

class RealCheckoutRepo extends CheckoutRepo {
  final ApiProvider _apiProvider = ApiProvider();

  @override
  Future<OrderPlaceResponse> placeOrder(
      String billingFirstName,
      String billingLastName,
      String billingStreetAddress,
      String billingCity,
      String billingPostCode,
      int billingCountry,
      int billingState,
      String billingPhone,
      String deliveryFirstName,
      String deliveryLastName,
      String deliveryStreetAddress,
      String deliveryCity,
      String deliveryPostCode,
      int deliveryCountry,
      int deliveryState,
      String deliveryPhone,
      int currencyId,
      int languageId,
      String paymentMethod,
      String latLng,
      String cardNumber,
      String cvc,
      String expMonth,
      String expYear
      ) {
    return _apiProvider.placeOrder(
        billingFirstName,
        billingLastName,
        billingStreetAddress,
        billingCity,
        billingPostCode,
        billingCountry,
        billingState,
        billingPhone,
        deliveryFirstName,
        deliveryLastName,
        deliveryStreetAddress,
        deliveryCity,
        deliveryPostCode,
        deliveryCountry,
        deliveryState,
        deliveryPhone,
        currencyId,
        languageId,
        paymentMethod,
        latLng,
        cardNumber,
        cvc,
        expMonth,
        expYear);
  }
}
