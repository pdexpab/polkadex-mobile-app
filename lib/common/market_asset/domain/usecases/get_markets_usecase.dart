import 'package:dartz/dartz.dart';
import 'package:polkadex/common/market_asset/domain/repositories/imarket_repository.dart';
import 'package:polkadex/common/market_asset/domain/entities/market_entity.dart';
import 'package:polkadex/common/network/error.dart';

class GetMarketsUseCase {
  GetMarketsUseCase({
    required IMarketRepository marketRepository,
  }) : _marketRepository = marketRepository;

  final IMarketRepository _marketRepository;

  Future<Either<ApiError, List<MarketEntity>>> call() async {
    return await _marketRepository.getMarkets();
  }
}
