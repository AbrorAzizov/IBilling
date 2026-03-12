import 'package:get_it/get_it.dart';
import '../domain/usecases/get_saved_contracts_usecase.dart';
import '../presentation/bloc/saved_bloc.dart';

class SavedModule {
  Future<void> register(GetIt sl) async {
    // Use cases
    sl.registerLazySingleton(() => GetSavedContractsUseCase());

    // BLoCs
    sl.registerFactory(() => SavedBloc(
      getSavedContractsUseCase: sl(),
      contractsBloc: sl(),
    ));
  }
}


