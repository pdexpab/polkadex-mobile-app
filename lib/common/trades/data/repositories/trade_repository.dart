import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/data/models/trade_model.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/data/datasources/trade_remote_datasource.dart';
import 'package:polkadex/common/trades/data/models/order_model.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';
import 'package:polkadex/common/utils/extensions.dart';

class TradeRepository implements ITradeRepository {
  TradeRepository({required TradeRemoteDatasource tradeRemoteDatasource})
      : _tradeRemoteDatasource = tradeRemoteDatasource;

  final TradeRemoteDatasource _tradeRemoteDatasource;

  @override
  Future<Either<ApiError, OrderEntity>> placeOrder(
    String mainAddress,
    String proxyAddress,
    String baseAsset,
    String quoteAsset,
    EnumOrderTypes orderType,
    EnumBuySell orderSide,
    String price,
    String amount,
  ) async {
    try {
      final result = await _tradeRemoteDatasource.placeOrder(
        mainAddress,
        proxyAddress,
        baseAsset == 'PDEX' ? '' : baseAsset,
        quoteAsset == 'PDEX' ? '' : quoteAsset,
        orderType.toString().split('.')[1].capitalize(),
        orderSide == EnumBuySell.buy ? 'Bid' : 'Ask',
        price,
        amount,
      );

      if (result != null) {
        final newOrder = OrderModel(
          tradeId: result,
          amount: amount,
          price: price,
          orderSide: orderSide,
          orderType: orderType,
          timestamp: DateTime.now(),
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          status:
              orderType == EnumOrderTypes.market ? 'Filled' : 'PartiallyFilled',
          market: '$baseAsset/$quoteAsset',
        );

        return Right(newOrder);
      } else {
        return Left(
            ApiError(message: 'Error on JSON RPC request. Please try again.'));
      }
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<Either<ApiError, String>> cancelOrder(
    int nonce,
    String address,
    String orderId,
  ) async {
    try {
      final result = await _tradeRemoteDatasource.cancelOrder(
        nonce,
        address,
        int.parse(orderId),
      );
      final Map<String, dynamic> body = jsonDecode(result.body);

      if (result.statusCode == 200 && body.containsKey('Fine')) {
        return Right(body['Fine']);
      } else {
        return Left(ApiError(message: body['Bad'] ?? result.reasonPhrase));
      }
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<Either<ApiError, List<OrderEntity>>> fetchOrders(
      String address) async {
    try {
      final result = await _tradeRemoteDatasource.fetchOrders(address);
      final listTransaction = result.rows.map((row) => row.assoc()).toList();
      List<OrderEntity> listOrder = [];

      for (var transaction in listTransaction) {
        listOrder.add(OrderModel.fromJson(transaction));
      }

      return Right(listOrder);
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<Either<ApiError, List<TradeEntity>>> fetchTrades(
      String address) async {
    try {
      final result = await _tradeRemoteDatasource.fetchTrades(address);

      final List<TradeEntity> listTransactions = [];

      for (var transaction in result.data?['listTransactionsByMainAccount']
          ['items']) {
        listTransactions.add(TradeModel.fromJson(transaction));
      }

      return Right(listTransactions);
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }
}
