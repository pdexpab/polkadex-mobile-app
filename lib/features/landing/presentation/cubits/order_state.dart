part of 'order_cubit.dart';

abstract class PlaceOrderState extends Equatable {
  const PlaceOrderState({
    this.balance = 0.0,
    this.amount = 0.0,
    this.price = 0.0,
    this.orderSide = EnumBuySell.buy,
  });

  final double balance;
  final double amount;
  final double price;
  final EnumBuySell orderSide;

  @override
  List<Object> get props => [
        balance,
        amount,
        price,
        orderSide,
      ];
}

class PlaceOrderInitial extends PlaceOrderState {}

class PlaceOrderValid extends PlaceOrderState {
  const PlaceOrderValid({
    required double balance,
    required double amount,
    required double price,
    required EnumBuySell orderSide,
  }) : super(
          balance: balance,
          amount: amount,
          price: price,
          orderSide: orderSide,
        );
}

class PlaceOrderNotValid extends PlaceOrderState {
  const PlaceOrderNotValid({
    required double balance,
    required double amount,
    required double price,
    required EnumBuySell orderSide,
  }) : super(
          balance: balance,
          amount: amount,
          price: price,
          orderSide: orderSide,
        );
}

class PlaceOrderLoading extends PlaceOrderState {}

class PlaceOrderAccepted extends PlaceOrderNotValid {
  const PlaceOrderAccepted({
    required double balance,
    required double amount,
    required double price,
    required EnumBuySell orderSide,
  }) : super(
          balance: balance,
          amount: amount,
          price: price,
          orderSide: orderSide,
        );
}

class PlaceOrderNotAccepted extends PlaceOrderNotValid {
  const PlaceOrderNotAccepted({
    required double balance,
    required double amount,
    required double price,
    required EnumBuySell orderSide,
  }) : super(
          balance: balance,
          amount: amount,
          price: price,
          orderSide: orderSide,
        );
}
