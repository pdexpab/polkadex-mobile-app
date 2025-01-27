import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/orderbook/data/datasources/orderbook_remote_datasource.dart';
import 'package:polkadex/common/orderbook/data/models/orderbook_model.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_entity.dart';
import 'package:polkadex/common/orderbook/domain/repositories/iorderbook_repository.dart';

class OrderbookRepository implements IOrderbookRepository {
  OrderbookRepository(
      {required OrderbookRemoteDatasource orderbookRemoteDatasource})
      : _orderbookRemoteDatasource = orderbookRemoteDatasource;

  final OrderbookRemoteDatasource _orderbookRemoteDatasource;
  StreamSubscription? orderbookSubscription;

  @override
  Future<Either<ApiError, OrderbookEntity>> getOrderbookData(
    String leftTokenId,
    String rightTokenId,
  ) async {
    try {
      final result = await _orderbookRemoteDatasource.getOrderbookData(
        leftTokenId,
        rightTokenId,
      );

      return Right(
        OrderbookModel.fromJson(
          jsonDecode(result.data)['getOrderbook']['items'],
        ),
      );
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<void> getOrderbookUpdates(
    String leftTokenId,
    String rightTokenId,
    Function(List<dynamic>, List<dynamic>) onMsgReceived,
    Function(Object) onMsgError,
  ) async {
    final Stream orderbookStream =
        await _orderbookRemoteDatasource.getOrderbookStream(
      leftTokenId,
      rightTokenId,
    );

    await orderbookSubscription?.cancel();

    try {
      orderbookSubscription = orderbookStream.listen((message) {
        final data = message.data;

        if (message.data != null) {
          final liveData =
              jsonDecode(jsonDecode(data)['websocket_streams']['data']);

          final listPuts = liveData['puts'].toList();
          final listDels = liveData['dels'].toList();

          onMsgReceived(listPuts, listDels);
        }
      });
    } catch (error) {
      onMsgError(error);
    }
  }
}
