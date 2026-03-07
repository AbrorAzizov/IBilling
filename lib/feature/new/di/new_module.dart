
import 'package:get_it/get_it.dart';

import '../data/datasources/create_remote_datasource.dart';
import '../data/repository/create_repository_impl.dart';
import '../domain/repo/create_repository.dart';
import '../domain/usecases/create_contract_usecase.dart';
import '../domain/usecases/create_invoice_usecase.dart';
import '../presentation/bloc/create_bloc.dart';

class CreateModule {
  Future<void> register(GetIt sl) async {
    // Data sources
    sl.registerLazySingleton<CreateRemoteDataSource>(
      () => CreateRemoteDataSourceImpl(sl()),
    );

    // Repositories
    sl.registerLazySingleton<CreateRepository>(
      () => CreateRepositoryImpl(sl()),
    );

    // Use cases
    sl.registerLazySingleton(
      () => CreateContractUseCase(sl()),
    );

    sl.registerLazySingleton(
      () => CreateInvoiceUseCase(sl()),
    );

    // BLoCs
    sl.registerFactory(
      () => CreateBloc(
        createContractUseCase: sl(),
        createInvoiceUseCase: sl(),
      ),
    );
  }
}
