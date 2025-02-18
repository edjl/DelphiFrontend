import 'package:flutter/material.dart';
import 'skeleton_page/skeleton_page.dart';
import 'profile/user_profile_service.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Normal portrait
    DeviceOrientation.portraitDown, // Upside-down portrait (optional)
  ]).then((_) {
    runApp(const DelphiApp());
  });
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Error loading profile data'),
            ),
          );
        }

        return const SkeletonPage();
      },
    );
  }
}
