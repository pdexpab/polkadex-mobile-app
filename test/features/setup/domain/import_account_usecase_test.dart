import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/entities/meta_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/imnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';

class _MnemonicRepositoryMock extends Mock implements IMnemonicRepository {}

void main() {
  late ImportAccountUseCase _usecase;
  late _MnemonicRepositoryMock _repository;
  late String tMnemonic;
  late MetaEntity tMeta;
  late EncodingEntity tEncoding;
  late ImportedAccountEntity tImportedAccount;

  setUp(() {
    _repository = _MnemonicRepositoryMock();
    _usecase = ImportAccountUseCase(mnemonicRepository: _repository);
    tMnemonic =
        "correct gather fork rent problem ocean train pretty dinosaur captain myself rent";
    tMeta = MetaModel(name: 'userName');
    tEncoding = EncodingModel(
      content: ["sr25519"],
      version: '3',
      type: ["none"],
    );
    tImportedAccount = ImportedAccountModel(
      pubKey: "0xe5639b03f86257d187b00b667ae58",
      mnemonic: tMnemonic,
      rawSeed: "",
      encoded: "WFChrxNT3nd/UbHYklZlR3GWuoj9OhIwMhAJAx+",
      encoding: tEncoding,
      address: "k9o1dxJxQE8Zwm5Fy",
      meta: tMeta,
    );
  });

  group('ImportAccountUsecase tests', () {
    test(
      'must return success on account import',
      () async {
        // arrange
        when(() => _repository.importAccount(any(), any())).thenAnswer(
          (_) async => Right(tImportedAccount),
        );
        // act
        final result = await _usecase(mnemonic: '', password: '');
        // assert

        late ImportedAccountEntity importedAccount;

        result.fold(
          (_) => null,
          (acc) => importedAccount = acc,
        );

        expect(importedAccount, tImportedAccount);
        verify(() => _repository.importAccount(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must return error on account import with incorrect mnemonic',
      () async {
        // arrange
        when(() => _repository.importAccount(any(), any())).thenAnswer(
          (_) async => Left(ApiError()),
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