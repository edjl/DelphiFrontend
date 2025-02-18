import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../shared_services/abbreviated_numberstring_format.dart';
import '../shared_services/date_string_format.dart';

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

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
              event.name,
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
                  imageUrl: event.topOptionImage ??
                      "https://i.imgur.com/dRk6nBk.jpeg",
                  width: 29,
                  height: 29,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Text(
                  event.topOptionTitle,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${event.topOptionPrice} credits',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Third Row: Market Cap, Shares, End Date, and You Bought
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
                      '${AbbreviatedNumberstringFormat.formatMarketCap(event.marketCap)} credits',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${AbbreviatedNumberstringFormat.formatShares(event.shares)} shares',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ends ${DateStringFormat.formatEndDate(event.endDate)}',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Second Column: "You Bought" Indicator
                if (event.userBought)
                  Text(
                    'You Bought',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
