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
  String orderBy = 'purchase_date_time'; // Change according to your preference
  String orderDirection = 'desc'; // Change according to your preference
  List<String>? categories = []; // Update categories as needed

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
      // Handle errors
      print("Error loading shares: $e");
    } finally {
      isLoading = false;
    }
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
        body: ListView.builder(
          controller: _scrollController,
          itemCount: shares.length + 1, // Include the button as the last item
          shrinkWrap:
              true, // This ensures the ListView is tightly wrapped around the items
          padding: EdgeInsets.zero, // Remove any default padding from ListView
          itemBuilder: (context, index) {
            if (index < shares.length) {
              // Build event cards
              return GestureDetector(
                onTap: () async {
                  final result = await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return SellConfirmation(share: shares[index]);
                    },
                  );

                  if (result == true) {
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
              // Build the "Load More Shares" button
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      _loadShares();
                    },
                    child: Text(
                      "Load More Shares",
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }
}
