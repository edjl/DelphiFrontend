import 'package:flutter/material.dart';
import 'model/user_profile.dart';
import '../authentication/login_page.dart';
import 'user_profile_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: UserProfile().userId, // Listen for changes in userId
      builder: (context, userId, child) {
        // If userId is -1, the user is not logged in, show login page
        if (userId == -1) {
          return LoginPage(); // Show login page if not logged in
        } else {
          final userProfile = UserProfile(); // Access the singleton instance
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: ${userProfile.username}',
                      style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 16),
                  Text('Balance: \$${userProfile.balance.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 16),
                  Text('Total Bets: ${userProfile.totalBets}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 16),
                  Text('Bankruptcy Count: ${userProfile.bankruptcyCount}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 16),
                  Text('Credits Played: ${userProfile.totalCreditsPlaying}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 16),
                  Text('Credits Bet: ${userProfile.totalCreditsBet}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 16),
                  Text('Credits Won: ${userProfile.totalCreditsWon}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 16),
                  Text(
                      'Premium Account: ${userProfile.premiumAccount ? 'Yes' : 'No'}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 16),
                  Text('Profit Multiplier: ${userProfile.profitMultiplier}x',
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Log the user out
                      userProfile.logOut();
                      UserProfileService().saveUserProfile();
                    },
                    child: const Text('Log Out'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
