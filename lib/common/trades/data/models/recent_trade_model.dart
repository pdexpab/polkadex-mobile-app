import 'package:polkadex/common/trades/domain/entities/recent_trade_entity.dart';

class RecentTradeModel extends RecentTradeEntity {
  const RecentTradeModel({
    required String m,
    required DateTime time,
    required double price,
    required double qty,
  }) : super(
          m: m,
          time: time,
          price: price,
          qty: qty,
        );

  factory RecentTradeModel.fromJson(Map<String, dynamic> map) {
    return RecentTradeModel(
      m: map['m'],
      time: DateTime.parse(map['t']),
      price: double.parse(map['p']),
      qty: double.parse(map['q']),
    );
  }
}
