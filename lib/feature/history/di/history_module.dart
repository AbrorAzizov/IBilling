import 'package:get_it/get_it.dart';
import '../data/datasources/history_remote_datasource.dart';
import '../data/repository/history_repository_impl.dart';
import '../domain/repo/history_repository.dart';
import '../domain/usecases/get_history_usecase.dart';
import '../presentation/bloc/history_bloc.dart';

class HistoryModule {
  Future<void> register(GetIt sl) async {
    // Data sources
    sl.registerLazySingleton<HistoryRemoteDataSource>(
      () => HistoryRemoteDataSourceImpl(sl()),
    );

    // Repositories
    sl.registerLazySingleton<HistoryRepository>(
      () => HistoryRepositoryImpl(sl()),
    );

    // Use cases
    sl.registerLazySingleton(() => GetHistoryUseCase(sl()));

    // BLoCs
    sl.registerFactory(() => HistoryBloc(getHistoryUseCase: sl()));
  }
}
