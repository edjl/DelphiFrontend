import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/option.dart';
import 'get_options_service.dart';
import '../model/user_profile.dart';
import '../model/event.dart';
import '../shared_services/abbreviated_numberstring_format.dart';
import '../shared_services/date_string_format.dart';

class BetEventPage extends StatefulWidget {
  final Event event; // Add a final field to store the event

  // Constructor to pass the event
  BetEventPage({required this.event});

  @override
  _BetEventPageState createState() => _BetEventPageState();
}

class _BetEventPageState extends State<BetEventPage> {
  late Future<List<Option>> _optionsFuture;

  @override
  void initState() {
    super.initState();
    _optionsFuture = GetOptionsService.getOptions(
        (UserProfile().userId.value == -1) ? null : UserProfile().userId.value,
        widget.event.name);
  }

  // Method to show the pop-up dialog
  void _showPriceDialog(String priceType, int price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selected Price'),
          content: Text('$priceType: \$${price.toStringAsFixed(2)}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Flexible(
          child: Text(
            "Who will win the 2025 Stanley Cup?", // widget.event.name,
            style: TextStyle(
              fontFamily: 'IBM Plex Sans', // Set font to IBM Plex Sans
              fontSize: 32, // Set font size to 32
              fontWeight: FontWeight.w600, // Set font weight to semibold
            ),
            textAlign: TextAlign.center, // Center align the text
            maxLines: 3, // Allow up to 2 lines
            overflow: TextOverflow.ellipsis, // Gracefully handle overflow
          ),
        ),
        centerTitle: true, // Ensures that the title is centered in the AppBar
        toolbarHeight: 100, // Adjust the height of the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Option>>(
          future: _optionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No options available.'));
            } else {
              final options = snapshot.data!;
              // Data available, display event details and options table
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    // Event name and details in two columns
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left column with event details
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AbbreviatedNumberstringFormat.formatMarketCap(widget.event.marketCap)} credits',
                              style: TextStyle(
                                fontSize: 15, // Set font size to 15
                                fontFamily:
                                    'IBM Plex Sans', // Set font to IBM Plex Sans
                                fontWeight:
                                    FontWeight.w500, // Set medium boldness
                              ),
                            ),
                            Text(
                              '${AbbreviatedNumberstringFormat.formatShares(widget.event.shares)} shares',
                              style: TextStyle(
                                fontSize: 15, // Set font size to 15
                                fontFamily:
                                    'IBM Plex Sans', // Set font to IBM Plex Sans
                                fontWeight:
                                    FontWeight.w500, // Set medium boldness
                              ),
                            ),
                            Text(
                              'Ends ${DateStringFormat.formatEndDate(widget.event.endDate)}',
                              style: TextStyle(
                                fontSize: 15, // Set font size to 15
                                fontFamily:
                                    'IBM Plex Sans', // Set font to IBM Plex Sans
                                fontWeight:
                                    FontWeight.w500, // Set medium boldness
                              ),
                            ),
                          ],
                        ),
                        // Right column with My Shares button
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle "My Shares" button press
                                print('My Shares pressed');
                              },
                              child: Text('My Shares'),
                            ),
                            SizedBox(height: 8),
                            Text('YES', style: TextStyle(fontSize: 16)),
                            Text('NO', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Options list
                    Column(
                      children: options.map((option) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Option image
                              CachedNetworkImage(
                                imageUrl: option.imageLink ??
                                    "https://i.imgur.com/dRk6nBk.jpeg",
                                width: 29,
                                height: 29,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 16),
                              // Option title
                              Text(
                                option.title,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 16),
                              // Positive price button
                              ElevatedButton(
                                onPressed: () {
                                  _showPriceDialog('YES', option.positivePrice);
                                },
                                child: Text('\$${option.positivePrice}'),
                              ),
                              SizedBox(width: 8),
                              // Negative price button
                              ElevatedButton(
                                onPressed: () {
                                  _showPriceDialog('NO', option.negativePrice);
                                },
                                child: Text('\$${option.negativePrice}'),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
