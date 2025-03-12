import 'package:flutter/material.dart';
import '../model/user_profile.dart';
import '../authentication/login_page.dart';
import '../authentication/authentication_service.dart';
import '../shared_views/app_bar.dart';
import '../shared_services/abbreviated_numberstring_format.dart';

class GamblingInfoMainPage extends StatelessWidget {
  const GamblingInfoMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gambling Info',
        height: 68,
      ),
      body: Container(
        width:
            double.infinity, // Ensure the container fills the horizontal space
        color: Colors.white, // Set background color to white
        child: const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align all children to the left
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Important Notice:',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Delphi is designed to simulate gambling in a safe environment with no real money involved. It is important to understand that while this app provides a simulated gambling experience, gambling can have real-life consequences.',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Gambling can be addictive, and it can have serious effects on a person's mental health, relationships, and financial wellbeing. The purpose of this app is to raise awareness about the risks of gambling and to educate users about healthy behaviors and responsible decision-making.",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Due to this, Delphi does not take money from users, AND NEVER WILL!',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'How Gambling Can Affect You:',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Emotional Stress: Gambling can create feelings of stress, anxiety, and guilt, especially when it becomes excessive.',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Financial Consequences: Even though this app does not involve real money, gambling can lead to significant financial losses in real-life situations.",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Relationships: Gambling can negatively impact relationships with family, friends, and loved ones due to its addictive nature.",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Stay in Control:',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Know Your Limits: Set personal limits on how much time you spend on gambling activities, whether simulated or real.',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Take Breaks: If you find that gambling is affecting your mood or causing distress, take a break and engage in other activities.",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Don't Chase Losses: If you lose money or experience a setback in gambling, avoid the urge to 'chase' your losses. Gambling should never be used as a way to solve problems or as a source of income.",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Remember, this app is intended to help you better understand gambling and its risks. If you ever feel that your behavior is becoming problematic or that you need assistance, please don't hesitate to reach out to a professional or support group.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Stay safe, stay responsible, and take control of your gaming experience.',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
