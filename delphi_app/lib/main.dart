import 'package:flutter/material.dart';
import 'skeleton_page/skeleton_page.dart';
import 'profile/user_profile_service.dart';

void main() {
  runApp(const DelphiApp());
}

class DelphiApp extends StatelessWidget {
  const DelphiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delphi App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const UserProfileLoader(),
    );
  }
}

class UserProfileLoader extends StatelessWidget {
  const UserProfileLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserProfileService().loadUserProfile(),
      builder: (context, snapshot) {
        // Show a loading spinner while waiting for the data to load
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // After the data is loaded, navigate to the SkeletonPage (or any other page)
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Error loading profile data'),
            ),
          );
        }

        return const SkeletonPage(); // Home screen of your app after data is loaded
      },
    );
  }
}
