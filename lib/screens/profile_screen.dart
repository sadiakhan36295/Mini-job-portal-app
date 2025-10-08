import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/saved_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => email = prefs.getString('email') ?? 'user@example.com');
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    // For simplicity: restart app flow by popping to sign in
    Navigator.of(context).pushReplacementNamed('/signin');
  }

  @override
  Widget build(BuildContext context) {
    final savedCount = context.watch<SavedProvider>().saved.length;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
        SizedBox(height: 12),
        Text('Demo User', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Text(email),
        SizedBox(height: 12),
        Text('Saved Jobs: $savedCount'),
        SizedBox(height: 20),
        ElevatedButton(onPressed: _logout, child: Text('Sign out')),
      ]),
    );
  }
}
