import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/data/datasources/ticker_remote_datasource.dart';
import 'package:polkadex/features/landing/data/models/ticker_model.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/iticker_repository.dart';

class TickerRepository implements ITickerRepository {
  TickerRepository({required TickerRemoteDatasource tickerRemoteDatasource})
      : _tickerRemoteDatasource = tickerRemoteDatasource;

  final TickerRemoteDatasource _tickerRemoteDatasource;

  @override
  Future<Either<ApiError, Map<String, TickerEntity>>> getAllTickers() async {
    try {
      final result = await _tickerRemoteDatasource.getAllTickers();
      final Map<String, TickerEntity> listTickers = {};

      for (var tickerData in jsonDecode(result.data)['getAllMarketTickers']
          ['items']) {
        final ticker = TickerModel.fromJson(tickerData);
        listTickers[ticker.m] = ticker;
      }

      return (Right(listTickers));
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<void> getTickerUpdates(
    String leftTokenId,
    String rightTokenId,
    Function(TickerEntity) onMsgReceived,
    Function(Object) onMsgError,
  ) async {
    final tickerStream = await _tickerRemoteDatasource.getTickerStream(
      leftTokenId,
      rightTokenId,
    );

    try {
      tickerStream.listen((message) {
        final data = message.data;

        if (data != null) {
          final newTickerData =
              jsonDecode(jsonDecode(data)['websocket_streams']['data']);

          if (newTickerData != null) {
            onMsgReceived(
              TickerModel.fromJson(newTickerData),
            );
          }
        }
      });
    } catch (error) {
      onMsgError(error);
    }
  }
}
