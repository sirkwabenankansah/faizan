part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
}

class PlaceOrder extends CheckoutEvent {
  final String billingFirstName;
  final String billingLastName;
  final String billingStreetAddress;
  final String billingCity;
  final String billingPostCode;
  final int billingCountry;
  final int billingState;
  final String billingPhone;
  final String deliveryFirstName;
  final String deliveryLastName;
  final String deliveryStreetAddress;
  final String deliveryCity;
  final String deliveryPostCode;
  final int deliveryCountry;
  final int deliveryState;
  final String deliveryPhone;
  final int currencyId;
  final int languageId;
  final String paymentMethod;
  final String latLng;
  final String cardNumber;
  final String cvc;
  final String expMonth;
  final String expYear;

  const PlaceOrder(
      this.billingFirstName,
      this.billingLastName,
      this.billingStreetAddress,
      this.billingCity,
      this.billingPostCode,
      this.billingCountry,
      this.billingState,
      this.billingPhone,
      this.deliveryFirstName,
      this.deliveryLastName,
      this.deliveryStreetAddress,
      this.deliveryCity,
      this.deliveryPostCode,
      this.deliveryCountry,
      this.deliveryState,
      this.deliveryPhone,
      this.currencyId,
      this.languageId,
      this.paymentMethod,
      this.latLng,
      this.cardNumber,
      this.cvc,
      this.expMonth,
      this.expYear);

  @override
  List<Object> get props => [
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
        expYear
      ];
}
