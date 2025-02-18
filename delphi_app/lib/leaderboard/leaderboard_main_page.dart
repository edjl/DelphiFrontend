import 'package:flutter/material.dart';
import '../model/event.dart';
import '../model/leaderboard_profile.dart';
import 'leaderboard_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared_services/abbreviated_numberstring_format.dart';
import '../shared_views/app_bar.dart';

class LeaderboardMainPage extends StatefulWidget {
  @override
  _LeaderboardMainPage createState() => _LeaderboardMainPage();
}

class _LeaderboardMainPage extends State<LeaderboardMainPage> {
  List<LeaderboardProfile> leaderboardBalance = [];
  List<LeaderboardProfile> leaderboardWinning = [];
  bool orderByBalance = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      isLoading = true;
    });

    try {
      final balanceLeaderboard = await LeaderboardService.getLeaderboard(
        "balance",
        'desc',
      );
      final winningLeaderboard = await LeaderboardService.getLeaderboard(
        "total_credits_won",
        'desc',
      );

      if (balanceLeaderboard.isNotEmpty) {
        setState(() {
          leaderboardBalance = balanceLeaderboard;
        });
      }
      if (winningLeaderboard.isNotEmpty) {
        setState(() {
          leaderboardWinning = winningLeaderboard;
        });
      }
    } catch (e) {
      print("Error loading events: $e");
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Leaderboard',
          height: 68,
        ),
        body: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      // Balance button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              orderByBalance = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(
                              color: orderByBalance
                                  ? Colors.blue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                'Balance',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'IBM Plex Sans',
                                  fontWeight: FontWeight.w600,
                                  color: orderByBalance
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Winnings button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              orderByBalance = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(
                              color: !orderByBalance
                                  ? Colors.blue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                'Winnings',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'IBM Plex Sans',
                                  fontWeight: FontWeight.w600,
                                  color: !orderByBalance
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: orderByBalance
                        ? leaderboardBalance.length
                        : leaderboardWinning.length,
                    itemBuilder: (context, index) {
                      final user = orderByBalance
                          ? leaderboardBalance[index]
                          : leaderboardWinning[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: _getBackgroundColor(index + 1),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'IBM Plex Sans',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  user.username,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'IBM Plex Sans',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  constraints: BoxConstraints(
                                    minWidth: 120,
                                  ),
                                  child: Text(
                                    '${AbbreviatedNumberstringFormat.formatMarketCap(orderByBalance ? user.balance : user.totalCreditsWon)} credits',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'IBM Plex Sans',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            )));
  }

  Color _getBackgroundColor(int rank) {
    if (rank == 1) {
      return Color(0xFFD4AF37); // Gold (Hex for gold)
    } else if (rank == 2) {
      return Color(0xFFC0C0C0); // Silver (Hex for silver)
    } else if (rank == 3) {
      return Color.fromARGB(167, 139, 67, 5); // Bronze (Hex for bronze)
    } else {
      return Color(0xFF808080); // Gray (Hex for gray)
    }
  }
}
