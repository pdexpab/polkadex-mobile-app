import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/data/models/order_model.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';

void main() {
  late OrderModel tOrder;

  setUp(() {
    tOrder = OrderModel(
      tradeId: '0',
      amount: "1",
      price: "50.0",
      event: EnumTradeTypes.bid,
      orderSide: EnumBuySell.buy,
      orderType: EnumOrderTypes.market,
      timestamp: DateTime.now(),
      baseAsset: '0',
      quoteAsset: '1',
      status: 'PartiallyFilled',
      market: '0/1',
    );
  });

  test('OrderModel must be a OrderEntity', () {
    expect(tOrder, isA<OrderEntity>());
  });
}
