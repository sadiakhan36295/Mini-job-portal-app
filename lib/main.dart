import 'package:flutter/material.dart';
import 'package:job_portal_app/screens/job_list_screen.dart';
import 'package:job_portal_app/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes/app_routes.dart';
import 'providers/job_provider.dart';
import 'providers/saved_provider.dart';
import 'services/db_service.dart';
import 'firebase_options.dart'; // make sure this exists

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SavedJobsDatabase.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mini Job Portal',
        theme: ThemeData(primarySwatch: Colors.blue),
        // Wait for Firebase auth state
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasData) {
              return const JobListScreen();
            }
            return const LoginScreen();
          },
        ),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
