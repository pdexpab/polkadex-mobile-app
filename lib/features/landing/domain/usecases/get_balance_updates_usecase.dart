import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/ibalance_repository.dart';

class GetBalanceUpdatesUseCase {
  GetBalanceUpdatesUseCase({
    required IBalanceRepository balanceRepository,
  }) : _balanceRepository = balanceRepository;

  final IBalanceRepository _balanceRepository;

  Future<void> call({
    required String address,
    required Function(BalanceEntity) onMsgReceived,
    required Function(Object) onMsgError,
  }) async {
    return await _balanceRepository.fetchBalanceUpdates(
      address,
      onMsgReceived,
      onMsgError,
    );
  }
}
