
part of 'payment_methods_bloc.dart';

abstract class PaymentMethodsEvent extends Equatable {
  const PaymentMethodsEvent();
}

class GetPaymentMethods extends PaymentMethodsEvent {
  const GetPaymentMethods();

  @override
  List<Object> get props => [];
}
