import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/api/responses/order_place_response.dart';
import 'package:flutter_kundol/constants/app_constants.dart';
import 'package:flutter_kundol/repos/checkout_repo.dart';

part 'checkout_event.dart';

part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepo checkoutRepo;

  CheckoutBloc(this.checkoutRepo) : super(const CheckoutInitial());

  @override
  Stream<CheckoutState> mapEventToState(CheckoutEvent event) async* {
    if (event is PlaceOrder) {
      try {
        final placeOrderResponse = await checkoutRepo.placeOrder(
            event.billingFirstName,
            event.billingLastName,
            event.billingStreetAddress,
            event.billingCity,
            event.billingPostCode,
            event.billingCountry,
            event.billingState,
            event.billingPhone,
            event.deliveryFirstName,
            event.deliveryLastName,
            event.deliveryStreetAddress,
            event.deliveryCity,
            event.deliveryPostCode,
            event.deliveryCountry,
            event.deliveryState,
            event.deliveryPhone,
            event.currencyId,
            event.languageId,
            event.paymentMethod,
            event.latLng,
            event.cardNumber,
            event.cvc,
            event.expMonth,
            event.expYear);
        if (placeOrderResponse.status == AppConstants.STATUS_SUCCESS) {
          yield CheckoutLoaded(placeOrderResponse);
        } else {
          yield CheckoutError(placeOrderResponse.message!);
        }
      } on Error {
        yield const CheckoutError("Couldn't fetch weather. Is the device online?");
      }
    }
  }
}
