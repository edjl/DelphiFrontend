import 'package:delphi_app/shared_services/percentage_change_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/share.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../shared_services/abbreviated_numberstring_format.dart';
import '../shared_services/date_string_format.dart';

class ShareCard extends StatelessWidget {
  final Share share;

  ShareCard({required this.share});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: const Border(
        bottom: BorderSide(
          color: Colors.black,
          width: 1, // Set the border width for the bottom only
        ),
      ),
      margin: EdgeInsets.zero, // Ensure no margin around the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Row: Event Name
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              share.eventName,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      share.imageLink ?? "https://i.imgur.com/dRk6nBk.jpeg",
                  width: 29,
                  height: 29,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Text(
                  share.optionName,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${AbbreviatedNumberstringFormat.formatWithCommas(share.shares.abs())} ${(share.shares > 0 ? "YES" : "NO")} @ ${share.price} c',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Third Row: Market Cap, Shares, End Date, and current change
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0 + 29.0 + 15, right: 16.0, top: 8.0, bottom: 8.0),
            //const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Column: Market Cap, Shares, End Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Currently ${share.currentPrice} c',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bought on ${DateStringFormat.formatEndDate(share.purchaseDateTime)}',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ends ${DateStringFormat.formatEndDate(share.eventEndDateTime)}',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Second Column: Current change
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${share.currentPrice > share.price ? "+" : ""}${PercentageChangeFormat.formatPercentChange(share.price, share.currentPrice)}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: share.currentPrice == share.price
                            ? Colors.black
                            : share.currentPrice > share.price
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${share.currentPrice == share.price ? "" : share.currentPrice > share.price ? "+" : "-"}${AbbreviatedNumberstringFormat.formatShares(share.shares.abs() * (share.currentPrice - share.price).abs())} c',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: share.currentPrice == share.price
                            ? Colors.black
                            : share.currentPrice > share.price
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
