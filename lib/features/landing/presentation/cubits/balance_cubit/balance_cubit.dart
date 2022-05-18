import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/test_deposit_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/register_user_usecase.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit({
    required GetBalanceUseCase getBalanceUseCase,
    required TestDepositUseCase testDepositUseCase,
    required RegisterUserUseCase registerUserUseCase,
  })  : _getBalanceUseCase = getBalanceUseCase,
        _testDepositUseCase = testDepositUseCase,
        _registerUserUseCase = registerUserUseCase,
        super(BalanceInitial());

  final GetBalanceUseCase _getBalanceUseCase;
  final TestDepositUseCase _testDepositUseCase;
  final RegisterUserUseCase _registerUserUseCase;
  Timer? _balanceTimer;

  Timer? get balanceTimer => _balanceTimer;

  Future<void> getBalance(String address) async {
    emit(BalanceLoading());

    final result = await _getBalanceUseCase(address: address);

    result.fold(
      (error) => emit(
        BalanceError(message: error.message),
      ),
      (balance) {
        emit(
          BalanceLoaded(
            free: balance.free,
            used: balance.used,
            total: balance.total,
          ),
        );

        _balanceTimer = Timer.periodic(
          Duration(seconds: 5),
          (timer) async {
            final resultPeriodic = await _getBalanceUseCase(address: address);

            resultPeriodic.fold(
              (_) => timer.cancel(),
              (balancePeriodic) => emit(
                BalanceLoaded(
                  free: balancePeriodic.free,
                  used: balancePeriodic.used,
                  total: balancePeriodic.total,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> testDeposit(String address, String signature) async {
    final previousState = state;

    emit(BalanceLoading());

    await _registerUserUseCase(address: address);

    final result0 = await _testDepositUseCase(
      asset: 0,
      address: address,
      signature: signature,
    );

    final result1 = await _testDepositUseCase(
      asset: 1,
      address: address,
      signature: signature,
    );

    result0.isRight() || result1.isRight()
        ? getBalance(address)
        : emit(previousState);
  }
}
