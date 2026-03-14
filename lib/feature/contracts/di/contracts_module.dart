import 'package:get_it/get_it.dart';
import '../data/datasources/contract_remote_datasource.dart';
import '../data/repository/contract_repository_impl.dart';
import '../domain/repo/contract_repository.dart';
import '../domain/usecases/get_contracts_usecase.dart';
import '../domain/usecases/filter_contracts_usecase.dart';
import '../presentation/bloc/contracts_bloc.dart';

class ContractsModule {
  Future<void> register(GetIt sl) async {
    // Data sources
    sl.registerLazySingleton<ContractRemoteDataSource>(
      () => ContractRemoteDataSourceImpl(sl()),
    );

    // Repositories
    sl.registerLazySingleton<ContractRepository>(
      () => ContractRepositoryImpl(sl()),
    );

    // Use cases
    sl.registerLazySingleton(() => GetContractsUseCase(sl()));
    sl.registerLazySingleton(() => FilterContractsUseCase(sl()));

    // BLoCs
    sl.registerFactory(() => ContractsBloc(
          getContractsUseCase: sl(),
          filterContractsUseCase: sl(),
        ));
  }
}
