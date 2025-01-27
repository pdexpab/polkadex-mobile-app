import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/coin/data/datasources/coin_remote_datasource.dart';
import 'package:polkadex/features/coin/domain/repositories/icoin_repository.dart';

class CoinRepository implements ICoinRepository {
  CoinRepository({required CoinRemoteDatasource coinRemoteDatasource})
      : _coinRemoteDatasource = coinRemoteDatasource;

  final CoinRemoteDatasource _coinRemoteDatasource;

  @override
  Future<Either<ApiError, void>> withdraw(
    String mainAddress,
    String proxyAddress,
    String asset,
    double amount,
  ) async {
    try {
      await _coinRemoteDatasource.withdraw(
        mainAddress,
        proxyAddress,
        asset == 'PDEX' ? '' : asset,
        amount,
      );

      return Right(null);
    } catch (e) {
      return Left(ApiError(message: e.toString()));
    }
  }
}
