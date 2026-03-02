import 'package:flutter/material.dart';

import '../../../core/routes/app_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'StudyNinja',
      debugShowCheckedModeBanner: false,
     routerConfig: AppRouter.createRouter(),
    );
  }
}
