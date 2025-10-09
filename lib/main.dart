import 'package:flutter/material.dart';
import 'package:job_portal_app/providers/applied_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'services/db_service.dart';
import 'providers/job_provider.dart';
import 'providers/saved_provider.dart';
import 'routes/app_routes.dart'; // your AppRoutes.generateRoute

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Firebase if you use it; if not, remove these lines
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // IMPORTANT: init local DB before runApp so providers can read safely
  await SavedJobsDatabase.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => SavedProvider()),
        ChangeNotifierProvider(create: (_) => AppliedProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mini Job Portal',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: AppRoutes.login, // or whichever route you want first
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}