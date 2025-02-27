import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/share.dart';
import '../model/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import "option_service.dart";

class MyShares extends StatefulWidget {
  final String eventName;
  const MyShares({
    required this.eventName,
    Key? key,
  }) : super(key: key);

  @override
  _MySharesState createState() => _MySharesState();
}

class _MySharesState extends State<MyShares> {
  List<Share> shares = [];
  late ScrollController _scrollController;
  bool isLoading = false;
  int? selectedShareIndex;
  TextEditingController quantityController = TextEditingController();
  bool isValidInput = true;

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
      final returnedShares = await OptionService.getUserShares(
        (UserProfile().userId.value == -1) ? null : UserProfile().userId.value,
        widget.eventName,
      );

      setState(() {
        shares = returnedShares;
      });
    } catch (e) {
      print("Error loading my shares: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Future<bool> _sellShares(int optionAmount, Share share) async {
    try {
      final success = await OptionService.sellShares(
        UserProfile().userId.value,
        widget.eventName,
        share.optionName,
        share.purchaseDateTime,
        optionAmount,
      );
      return success;
    } catch (e) {
      print("Error selling shares: $e");
      return false;
    }
  }

  void _showFailureMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sell failed. Please try again later.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _confirmSell(int index) async {
    final share = shares[index];
    final shareCount = int.tryParse(quantityController.text) ?? 0;

    if (shareCount < 1 || shareCount > share.shares.abs()) {
      _showFailureMessage(context);
      return;
    }

    UserProfile().sellShare(shareCount * share.price,
        shareCount * share.currentPrice, shareCount == share.shares.abs());

    final success = await _sellShares(shareCount, share);

    if (success) {
      setState(() {
        if (shareCount == share.shares.abs()) {
          shares.removeAt(index);
        } else if (share.shares > 0) {
          share.shares -= shareCount;
        } else {
          share.shares += shareCount;
        }
      });
    } else {
      UserProfile().refundSale(shareCount * share.price,
          shareCount * share.currentPrice, shareCount == share.shares.abs());
      _showFailureMessage(context);
    }
    setState(() {
      selectedShareIndex = null; // Reset after confirmation
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Align(
        alignment: Alignment.center,
        child: Text(
          'My Shares',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans',
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      content: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              width: 450, // Optional width for the ListView
              height: 450, // Optional height for the ListView
              child: Scrollbar(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: shares.length,
                    itemBuilder: (context, index) {
                      Share curShare = shares[index];
                      bool isYes = true;
                      int sharesActual = curShare.shares;
                      if (sharesActual < 0) {
                        isYes = false;
                        sharesActual = -1 *
                            sharesActual; // Flip to positive for "NO" shares
                      }
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: curShare.imageLink ??
                                          "https://i.imgur.com/dRk6nBk.jpeg",
                                      width: 29,
                                      height: 29,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      curShare.optionName,
                                      style: const TextStyle(
                                        fontFamily: 'IBM Plex Sans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${sharesActual} @ ${curShare.price}c',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isYes ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (selectedShareIndex == index) {
                                      selectedShareIndex = null;
                                    } else {
                                      selectedShareIndex = index;
                                      quantityController.text =
                                          sharesActual.toString();
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isYes ? Colors.red : Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    side: const BorderSide(
                                        color: Colors.black, width: 0.5),
                                  ),
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(100, 30),
                                ),
                                child: SizedBox(
                                  width: 100,
                                  child: Center(
                                    child: Text(
                                      'Sell @${curShare.currentPrice}c',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (selectedShareIndex == index)
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: quantityController,
                                      decoration: const InputDecoration(
                                        labelText: 'Quantity',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          int enteredValue =
                                              int.tryParse(value) ?? 0;
                                          if (enteredValue < 1) {
                                            quantityController.text = '1';
                                          } else if (enteredValue >
                                              sharesActual) {
                                            quantityController.text =
                                                sharesActual.toString();
                                          }

                                          // Validate input and enable/disable the button
                                          setState(() {
                                            if (int.tryParse(
                                                    quantityController.text) !=
                                                null) {
                                              isValidInput = int.tryParse(
                                                          quantityController
                                                              .text)! >=
                                                      1 &&
                                                  int.tryParse(
                                                          quantityController
                                                              .text)! <=
                                                      sharesActual;
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            isValidInput = false;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: isValidInput
                                        ? () {
                                            _confirmSell(index);
                                            setState(() {
                                              selectedShareIndex = null;
                                            });
                                          }
                                        : null, // Disable button if input is invalid
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                        side: const BorderSide(
                                            color: Colors.black, width: 0.5),
                                      ),
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(100, 50),
                                    ),
                                    child: const Text(
                                      'SELL',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith(
              (states) => Colors.white,
            ),
            backgroundColor: WidgetStateProperty.all(Colors.blue),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
                side: const BorderSide(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
            ),
          ),
          child: const Text(
            'Close',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
