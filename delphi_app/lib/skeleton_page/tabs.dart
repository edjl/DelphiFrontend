import 'package:flutter/material.dart';
import '../profile/profile_page.dart';
import '../bet/bet_main_page.dart';
import '../leaderboard/leaderboard_main_page.dart';

class StoreTab extends StatelessWidget {
  const StoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Store Tab, coming soon!');
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfilePage();
  }
}

class BetTab extends StatelessWidget {
  const BetTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BetMainPage();
  }
}

class SharesTab extends StatelessWidget {
  const SharesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Shares Tab, coming soon!');
  }
}

class LeaderboardTab extends StatelessWidget {
  const LeaderboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return LeaderboardMainPage();
  }
}
