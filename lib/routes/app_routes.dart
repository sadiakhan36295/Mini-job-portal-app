import 'package:flutter/material.dart';
import 'package:job_portal_app/screens/applied_job_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/job_list_screen.dart';
import '../screens/job_detail_screen.dart';
import '../screens/saved_jobs_screen.dart';
import '../screens/profile_screen.dart';
import '../models/job_model.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String jobList = '/';
  static const String jobDetail = '/job-detail';
  static const String saved = '/saved';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String applied = '/applied';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case jobList:
        return MaterialPageRoute(builder: (_) => const JobListScreen());
      case jobDetail:
        final job = routeSettings.arguments as Job;
        return MaterialPageRoute(builder: (_) => JobDetailScreen(job: job));
      case saved:
        return MaterialPageRoute(builder: (_) => const SavedJobsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
     
        case applied:
        return MaterialPageRoute(builder: (_) => const AppliedJobsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const JobListScreen());
        
    }
  }
}