import 'package:flutter/material.dart';
import 'get_shares_service.dart';
import '../model/user_profile.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared_views/app_bar.dart';
import 'share_card.dart';
import '../model/share.dart';
import 'sell_confirmation.dart';

class SharesMainPage extends StatefulWidget {
  @override
  _SharesMainPage createState() => _SharesMainPage();
}

class _SharesMainPage extends State<SharesMainPage> {
  late ScrollController _scrollController;
  List<Share> shares = [];
  bool isLoading = false;
  int currentPage = 1;
  String orderBy = 'purchase_date_time';
  String orderDirection = 'desc';
  List<String>? categories = [];
  String successMessage = "";
  bool _showSuccessMessage = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadShares();
  }

  Future<void> _loadShares() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newShares = await GetSharesService.getUserShares(
        (UserProfile().userId.value == -1) ? null : UserProfile().userId.value,
        categories,
        orderBy,
        orderDirection,
        currentPage,
      );

      if (newShares.isNotEmpty) {
        setState(() {
          shares.addAll(newShares);
          currentPage++;
        });
      }
    } catch (e) {
      print("Error loading shares: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _triggerSuccessMessage(String successMsg) {
    successMessage = successMsg;
    setState(() {
      _showSuccessMessage = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showSuccessMessage = false;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Shares',
        height: 68,
      ),
      body: Stack(
        children: [
          /// Main content (Shares list)
          ListView.builder(
            controller: _scrollController,
            itemCount: shares.length + 1,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (index < shares.length) {
                return GestureDetector(
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return SellConfirmation(share: shares[index]);
                      },
                    );

                    if ((result is! Null) &&
                        (result is String) &&
                        result != "") {
                      _triggerSuccessMessage(result);
                      setState(() {
                        shares.clear();
                        currentPage = 1;
                      });
                      _loadShares();
                    }
                  },
                  child: ShareCard(share: shares[index]),
                );
              } else {
                return Visibility(
                  visible: !isLoading, // Make button invisible when loading
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: (shares.isEmpty) ? 48 : 8),
                      child: ElevatedButton(
                        onPressed: _loadShares,
                        child: Text(
                          "Load More Shares",
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),

          /// Fading success message overlay (Non-interactive)
          IgnorePointer(
            ignoring: true, // Ensures this does NOT block any user interactions
            child: AnimatedOpacity(
              opacity: _showSuccessMessage ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Align(
                alignment:
                    Alignment.topRight, // Position it in the top right corner
                child: Container(
                  padding: const EdgeInsets.all(
                      8.0), // Optional padding for better spacing
                  child: Text(
                    successMessage + " c",
                    style: TextStyle(
                      color: successMessage.startsWith('-')
                          ? Colors.red
                          : Colors.green, // Green if +, Red if -
                      fontSize: 25, // Small font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
