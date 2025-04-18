import 'package:flutter/material.dart';
import '../model/user_profile.dart';
import '../authentication/login_page.dart';
import '../authentication/authentication_service.dart';
import 'user_profile_service.dart';
import '../shared_views/app_bar.dart';
import '../shared_services/abbreviated_numberstring_format.dart';

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
            appBar: CustomAppBar(
              title: 'Profile',
              height: 68,
            ),
            body: Container(
              width: double
                  .infinity, // Ensure the container fills the horizontal space
              color: Colors.white, // Set background color to white
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align all children to the left
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userProfile.username,
                              style: const TextStyle(
                                fontFamily: 'IBM Plex Sans',
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Balance: ${AbbreviatedNumberstringFormat.formatWithCommas(userProfile.balance.value)} credits',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Total Bets: ${userProfile.totalBets}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Current Bets (max 30): ${userProfile.currentBets}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Bankruptcy Count: ${userProfile.bankruptcyCount}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Credits Playing: ${AbbreviatedNumberstringFormat.formatWithCommas(userProfile.totalCreditsPlaying)} credits',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Credits Bet: ${AbbreviatedNumberstringFormat.formatWithCommas(userProfile.totalCreditsBet)} credits',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Credits Won: ${AbbreviatedNumberstringFormat.formatWithCommas(userProfile.totalCreditsWon)} credits',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Premium Account: ${userProfile.premiumAccount ? 'Yes' : 'No'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Profit Multiplier: ${(userProfile.profitMultiplier / 100.0).toStringAsFixed(2)}x',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 50.0,
                        left: 20.0,
                        right: 20.0), // Adjust the bottom padding
                    child: Center(
                      child: Row(children: [
                        ElevatedButton(
                          onPressed: () {
                            // Log the user out
                            userProfile.logOut();
                            UserProfileService().saveUserProfile();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36, vertical: 13),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'IBM Plex Sans',
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.black, width: 1.5),
                            ),
                          ),
                          child: const Text('Log Out'),
                        ),
                        /*const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final result =
                                await AuthenticationService.deleteAccount(
                                    userProfile.userId.value);
                            if (result) {
                              userProfile.logOut();
                              UserProfileService().saveUserProfile();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36, vertical: 13),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'IBM Plex Sans',
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.black, width: 1.5),
                            ),
                          ),
                          child: const Text('Delete Account'),
                        ),*/
                      ]),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
