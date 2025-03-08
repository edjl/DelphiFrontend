import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'skeleton_page/skeleton_page.dart';
import 'profile/user_profile_service.dart';
import 'shared_services/sound_effects.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SoundEffects
      .playBackgroundMusic(); // Start playing background music when the app starts

  // Lock orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Normal portrait
    DeviceOrientation.portraitDown, // Upside-down portrait (optional)
  ]).then((_) {
    runApp(const DelphiApp());
  });
}

class DelphiApp extends StatefulWidget {
  const DelphiApp({super.key});

  @override
  _DelphiAppState createState() => _DelphiAppState();
}

class _DelphiAppState extends State<DelphiApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Register the observer to listen to app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Unregister the observer when disposing the app
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // Stop the background music when the app goes to the background
      SoundEffects.pauseBackgroundMusic();
    } else if (state == AppLifecycleState.resumed) {
      // Resume background music when the app comes back to the foreground
      SoundEffects.resumeBackgroundMusic();
    }
  }

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
