import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/imnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';

class _MnemonicRepositoryMock extends Mock implements IMnemonicRepository {}

void main() {
  late ImportAccountUseCase _usecase;
  late _MnemonicRepositoryMock _repository;
  late AccountEntity tAccount;

  setUp(() {
    _repository = _MnemonicRepositoryMock();
    _usecase = ImportAccountUseCase(mnemonicRepository: _repository);
    tAccount = AccountModel(
      name: "",
      email: "",
      mainAddress: "k9o1dxJxQE8Zwm5Fy",
      proxyAddress: "k9o1dxJxQE8Zwm5Fy",
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );
  });

  group('ImportAccountUsecase tests', () {
    test(
      'must return success on account import',
      () async {
        // arrange
        when(() => _repository.importAccount(any(), any())).thenAnswer(
          (_) async => Right(tAccount),
        );
        // act
        final result = await _usecase(mnemonic: '', password: '');
        // assert

        late AccountEntity account;

        result.fold(
          (_) => null,
          (acc) => account = acc,
        );

        expect(account, tAccount);
        verify(() => _repository.importAccount(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must return error on account import with incorrect mnemonic',
      () async {
        // arrange
        when(() => _repository.importAccount(any(), any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(mnemonic: '', password: '');
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.importAccount(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
