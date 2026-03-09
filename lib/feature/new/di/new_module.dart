
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../data/datasources/create_remote_datasource.dart';
import '../data/repository/create_repository_impl.dart';
import '../domain/repo/create_repository.dart';
import '../domain/usecases/create_contract_usecase.dart';
import '../domain/usecases/create_invoice_usecase.dart';
import '../presentation/bloc/create_bloc.dart';

class CreateModule {
  Future<void> register(GetIt sl) async {
    // Core dependencies needed by data sources
    sl.registerLazySingleton(() => FirebaseFirestore.instance);

    // Data sources
    sl.registerLazySingleton<CreateRemoteDataSource>(
          () => CreateRemoteDataSourceImpl(sl()), // sl() resolves FirebaseFirestore
    );

    // Repositories
    sl.registerLazySingleton<CreateRepository>(
          () => CreateRepositoryImpl(sl()), // sl() resolves CreateRemoteDataSource
    );

    // Use cases
    sl.registerLazySingleton(
          () => CreateContractUseCase(sl()), // sl() resolves CreateRepository
    );

    sl.registerLazySingleton(
          () => CreateInvoiceUseCase(sl()), // sl() resolves CreateRepository
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