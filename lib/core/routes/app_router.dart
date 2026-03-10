import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../../feature/contracts/domain/entity/contract.dart';
import '../../feature/contracts/presentation/bloc/contracts_bloc.dart';
import '../../feature/contracts/presentation/pages/contract_details_page.dart';
import '../../feature/contracts/presentation/pages/contracts_page.dart';
import '../../feature/contracts/presentation/pages/home_shell.dart';
import '../../feature/new/presentation/bloc/create_bloc.dart';
import '../../feature/new/presentation/tabs/create_contract_tab.dart';
import '../../feature/new/presentation/tabs/create_invoice_tab.dart';
import '../../feature/profile/presentation/pages/profile_page.dart';
import 'route_names.dart';
import 'route_paths.dart';

final class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static GoRouter? _cachedRouter;

  static GoRouter createRouter() {
    String initialLocation = RoutePaths.home;

    _cachedRouter = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation,
      debugLogDiagnostics: true,
      errorBuilder: (context, state) =>
          Scaffold(body: Center(child: Text('Error: ${state.error}'))),
      routes: [
        GoRoute(
          path: RoutePaths.contractDetails,
          builder: (context, state) {
            final contract = state.extra as Contract;
            return BlocProvider(
              create: (context) => GetIt.I<ContractsBloc>(),
              child: ContractDetailsPage(contract: contract),
            );
          },
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return HomeShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.home,
                  name: RouteNames.home,
                  builder: (context, state) => BlocProvider(
                    create: (context) => GetIt.I<ContractsBloc>(),
                    child: const ContractsPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.history,
                  name: RouteNames.history,
                  builder: (context, state) =>
                      const Center(child: Text("History Screen")),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.newContract,
                  name: RouteNames.newContract,
                  builder: (context, state) =>
                      const Center(child: Text("New Screen")),
                ),
                GoRoute(
                  path: RoutePaths.contractCreate,
                  name: RouteNames.contractCreate,
                  builder: (context, state) => BlocProvider(
                    create: (_) => GetIt.I<CreateBloc>(),
                    child: const CreateContractTab(),
                  ),
                ),
                GoRoute(
                  path: RoutePaths.invoiceCreate,
                  name: RouteNames.invoiceCreate,
                  builder: (context, state) => BlocProvider(
                    create: (_) => GetIt.I<CreateBloc>(),
                    child: const CreateInvoiceTab(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.saved,
                  name: RouteNames.saved,
                  builder: (context, state) =>
                      const Center(child: Text("Saved Screen")),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.profile,
                  name: RouteNames.profile,
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return _cachedRouter!;
  }

  static GoRouter get router => _cachedRouter!;
}
