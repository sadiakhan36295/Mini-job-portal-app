import 'package:flutter/material.dart';
import 'package:job_portal_app/screens/job_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/db_service.dart';
import 'providers/job_provider.dart';
import 'providers/saved_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/job_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

        // ✅ use StreamBuilder to wait for FirebaseAuth state
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // wait until Firebase finishes connecting
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // if logged in → go to JobList
            if (snapshot.hasData) {
              return const JobListScreen();
            }

            // otherwise → show Login
            return const LoginScreen();
          },
        ),

        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          JobListScreen.routeName: (_) => const JobListScreen(),
          
        },
      ),
    );
  }
}
