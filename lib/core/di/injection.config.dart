// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:myrefectly/core/di/app_module.dart' as _i451;
import 'package:myrefectly/core/network/connectivity/network_info.dart'
    as _i455;
import 'package:myrefectly/core/network/dio_client.dart' as _i971;
import 'package:myrefectly/core/network/token/token_manager.dart' as _i95;
import 'package:myrefectly/features/auth/data/datasource/auth_remote_datasource.dart'
    as _i162;
import 'package:myrefectly/features/auth/data/repository/auth_repository_impl.dart'
    as _i167;
import 'package:myrefectly/features/auth/di/auth_di.dart' as _i524;
import 'package:myrefectly/features/auth/domain/repository/auth_repository.dart'
    as _i863;
import 'package:myrefectly/features/auth/domain/usecase/forgot_password_usecase.dart'
    as _i354;
import 'package:myrefectly/features/auth/domain/usecase/login_usecase.dart'
    as _i214;
import 'package:myrefectly/features/auth/domain/usecase/register_usecase.dart'
    as _i79;
import 'package:myrefectly/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart'
    as _i714;
import 'package:myrefectly/features/auth/presentation/bloc/login/login_bloc.dart'
    as _i476;
import 'package:myrefectly/features/auth/presentation/bloc/register/register_bloc.dart'
    as _i367;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    final authModule = _$AuthModule();
    gh.lazySingleton<_i895.Connectivity>(() => appModule.connectivity);
    gh.lazySingleton<_i95.TokenManager>(() => appModule.tokenManager);
    gh.lazySingleton<_i455.NetworkInfo>(() => appModule.networkInfo);
    gh.lazySingleton<_i971.DioClient>(() => appModule.dioClient);
    gh.lazySingleton<_i162.AuthRemoteDataSource>(
        () => authModule.authDataSource(gh<_i971.DioClient>()));
    gh.lazySingleton<_i863.AuthRepository>(() => _i167.AuthRepositoryImpl(
          dataSource: gh<_i162.AuthRemoteDataSource>(),
          networkInfo: gh<_i455.NetworkInfo>(),
          tokenManager: gh<_i95.TokenManager>(),
        ));
    gh.lazySingleton<_i354.ForgotPasswordUseCase>(
        () => _i354.ForgotPasswordUseCase(gh<_i863.AuthRepository>()));
    gh.lazySingleton<_i79.RegisterUseCase>(
        () => _i79.RegisterUseCase(gh<_i863.AuthRepository>()));
    gh.lazySingleton<_i214.LoginUseCase>(
        () => _i214.LoginUseCase(gh<_i863.AuthRepository>()));
    gh.factory<_i476.LoginBloc>(
        () => _i476.LoginBloc(loginUseCase: gh<_i214.LoginUseCase>()));
    gh.factory<_i714.ForgotPasswordBloc>(() => _i714.ForgotPasswordBloc(
        forgotPasswordUseCase: gh<_i354.ForgotPasswordUseCase>()));
    gh.factory<_i367.RegisterBloc>(
        () => _i367.RegisterBloc(registerUseCase: gh<_i79.RegisterUseCase>()));
    return this;
  }
}

class _$AppModule extends _i451.AppModule {}

class _$AuthModule extends _i524.AuthModule {}
