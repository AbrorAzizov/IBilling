/// Provides declarative routing with:
/// - Named routes.dart
/// - Deep linking support
/// - Route guards/redirects
/// - Shell routes.dart for nested navigation
/// - BLoC provider integration

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Your existing feature imports
import '../../feature/contracts/presentation/pages/home_shell.dart';
import '../../feature/contracts/presentation/pages/tabs/create_contract_tab.dart';
import '../../feature/contracts/presentation/pages/tabs/create_invoice_tab.dart';
import 'route_names.dart';
import 'route_paths.dart';

final class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static GoRouter? _cachedRouter;

  static GoRouter createRouter() {
    // Determine initial location logic
    String initialLocation = RoutePaths.home;

    _cachedRouter = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation,
      debugLogDiagnostics: true,
      errorBuilder: (context, state) =>
          Scaffold(body: Center(child: Text('Error: ${state.error}'))),
      routes: [
        // 2. THE MAIN NAV BAR LOGIC (Stateful Navigation)
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return HomeShell(navigationShell: navigationShell);
          },
          branches: [
            // BRANCH: Contracts
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.home,
                  name: RouteNames.home,
                  builder: (context, state) =>
                      const Center(child: Text("Contracts Screen")),
                ),
              ],
            ),
            // BRANCH: History
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
            // BRANCH: New
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.newContract,
                  name: RouteNames.newContract,
                  builder: (context, state) =>
                      const Center(child: Text("New Screen")),
                ),
                GoRoute(
                  path: RoutePaths.contractCreate,   // <-- use RoutePaths
                  name: RouteNames.contractCreate,
                  builder: (context, state) => const CreateContractTab(),
                ),
                GoRoute(
                  path: RoutePaths.invoiceCreate,    // <-- use RoutePaths
                  name: RouteNames.invoiceCreate,
                  builder: (context, state) => const CreateInvoiceTab(),
                ),

              ],
            ),
            // BRANCH: Saved
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
            // BRANCH: Profile
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.profile,
                  name: RouteNames.profile,
                  builder: (context, state) =>
                      const Center(child: Text("Profile Screen")),
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
