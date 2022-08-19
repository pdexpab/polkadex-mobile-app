import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/features/setup/data/datasources/account_local_datasource.dart';
import 'package:polkadex/features/setup/data/datasources/account_remote_datasource.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class AccountRepository implements IAccountRepository {
  AccountRepository({
    required AccountRemoteDatasource accountRemoteDatasource,
    required AccountLocalDatasource accountLocalDatasource,
  })  : _accountRemoteDatasource = accountRemoteDatasource,
        _accountLocalDatasource = accountLocalDatasource;

  final AccountRemoteDatasource _accountRemoteDatasource;
  final AccountLocalDatasource _accountLocalDatasource;

  @override
  Future<Either<ApiError, Unit>> signUp(
    String email,
    String password,
  ) async {
    try {
      await _accountRemoteDatasource.signUp(email, password);

      return Right(unit);
    } on AmplifyException catch (amplifyError) {
      return Left(
        ApiError(
          message: amplifyError.message,
        ),
      );
    } catch (error) {
      return Left(
        ApiError(
          message: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<ApiError, ImportedAccountEntity>> confirmSignUp(
    String email,
    String code,
    bool useBiometric,
  ) async {
    try {
      await _accountRemoteDatasource.confirmSignUp(email, code);

      return Right(
        ImportedAccountModel(
          email: email,
          mainAddress: '',
          proxyAddress: '',
          biometricAccess: useBiometric,
          timerInterval: EnumTimerIntervalTypes.oneMinute,
        ),
      );
    } on AmplifyException catch (amplifyError) {
      return Left(
        ApiError(
          message: amplifyError.message,
        ),
      );
    } catch (error) {
      return Left(
        ApiError(
          message: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<ApiError, ImportedAccountEntity>> signIn(
    String email,
    String password,
    bool useBiometric,
  ) async {
    try {
      await _accountRemoteDatasource.signIn(email, password);

      return Right(
        ImportedAccountModel(
          email: email,
          mainAddress: '',
          proxyAddress: '',
          biometricAccess: useBiometric,
          timerInterval: EnumTimerIntervalTypes.oneMinute,
        ),
      );
    } on AmplifyException catch (amplifyError) {
      return Left(
        ApiError(
          message: amplifyError.message,
        ),
      );
    } catch (error) {
      return Left(
        ApiError(
          message: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<ApiError, Unit>> signOut() async {
    try {
      await _accountRemoteDatasource.signOut();

      return Right(unit);
    } on AmplifyException catch (amplifyError) {
      return Left(
        ApiError(
          message: amplifyError.message,
        ),
      );
    } catch (error) {
      return Left(
        ApiError(
          message: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<ApiError, AuthUser>> getCurrentUser() async {
    try {
      final result = await _accountRemoteDatasource.getCurrentUser();

      return Right(result);
    } on AmplifyException catch (amplifyError) {
      return Left(
        ApiError(
          message: amplifyError.message,
        ),
      );
    } catch (error) {
      return Left(
        ApiError(
          message: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<ApiError, ResendSignUpCodeResult>> resendCode(
      String email) async {
    try {
      final result = await _accountRemoteDatasource.resendCode(email);

      return Right(result);
    } on AmplifyException catch (amplifyError) {
      return Left(
        ApiError(
          message: amplifyError.message,
        ),
      );
    } catch (error) {
      return Left(
        ApiError(
          message: error.toString(),
        ),
      );
    }
  }

  @override
  Future<void> saveAccountStorage(String keypairJson,
      {String? password}) async {
    return await _accountLocalDatasource.saveAccountStorage(keypairJson,
        password: password);
  }

  @override
  Future<ImportedAccountEntity?> getAccountStorage() async {
    final result = await _accountLocalDatasource.getAccountStorage();

    return result != null
        ? ImportedAccountModel.fromJson(jsonDecode(result))
        : null;
  }

  @override
  Future<void> deleteAccountStorage() async {
    return await _accountLocalDatasource.deleteAccountStorage();
  }

  @override
  Future<void> deletePasswordStorage() async {
    return await _accountLocalDatasource.deletePasswordStorage();
  }

  @override
  Future<bool> savePasswordStorage(String password) async {
    return await _accountLocalDatasource.savePasswordStorage(password);
  }

  @override
  Future<String?> getPasswordStorage() async {
    return await _accountLocalDatasource.getPasswordStorage();
  }

  @override
  Future<bool> confirmPassword(
      Map<String, dynamic> account, String password) async {
    return await _accountLocalDatasource.confirmPassword(
        account, password.toBase64());
  }
}
