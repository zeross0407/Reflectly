import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:myrefectly/core/di/network_module.dart';
import 'package:myrefectly/core/network/api_endpoints.dart';
import 'package:myrefectly/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:myrefectly/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:myrefectly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:myrefectly/features/auth/domain/repositories/auth_repository.dart';
import 'package:myrefectly/features/auth/domain/usecases/login_usecase.dart';
import 'package:myrefectly/features/auth/stores/login_store.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/data.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Network Module
  NetworkModule(serviceLocator, baseUrl: server_root_url).init();
  
  // Repositories
  final userRepository = Repository<String, User>(name: 'user_box');

  // Auth Feature
  // Stores
  serviceLocator
      .registerFactory(() => LoginStore(loginUseCase: serviceLocator()));

  // Use cases
  serviceLocator.registerLazySingleton(() => LoginUseCase(serviceLocator()));

  // Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
    ),
  );

  // Data sources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(userRepository: userRepository),
  );

  // External
  serviceLocator.registerLazySingleton(() => http.Client());
  
  // Register initial empty tokens
  if (!serviceLocator.isRegistered<String>(instanceName: 'access_token')) {
    serviceLocator.registerSingleton<String>('', instanceName: 'access_token');
  }
  if (!serviceLocator.isRegistered<String>(instanceName: 'refresh_token')) {
    serviceLocator.registerSingleton<String>('', instanceName: 'refresh_token');
  }
}
