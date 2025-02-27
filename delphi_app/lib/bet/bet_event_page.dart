import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/option.dart';
import 'get_options_service.dart';
import '../model/user_profile.dart';
import '../model/event.dart';
import '../shared_services/abbreviated_numberstring_format.dart';
import '../shared_services/date_string_format.dart';
import 'bet_confirmation.dart';
import 'my_shares.dart';
import '../model/user_profile.dart';

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

  @override
  Widget build(BuildContext context) {
    final String titleText = widget.event.name;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor:
                Colors.white, // Set the background color for the app bar
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: null,
              background: Container(
                color: Colors
                    .white, // Set the background color to white for consistency
                padding:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 25.0),
                child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          titleText,
                          style: const TextStyle(
                            fontFamily: 'IBM Plex Sans',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<Option>>(
                future: _optionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No options available.'));
                  } else {
                    final options = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left column with event details
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AbbreviatedNumberstringFormat.formatMarketCap(widget.event.marketCap)} credits',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'IBM Plex Sans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${AbbreviatedNumberstringFormat.formatShares(widget.event.shares)} shares',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'IBM Plex Sans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Ends ${DateStringFormat.formatEndDate(widget.event.endDate)}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'IBM Plex Sans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              // Right column with My Shares button
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 6.0, right: 12.0),
                                child: ElevatedButton(
                                  onPressed: UserProfile().userId.value >= 0
                                      ? () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return MyShares(
                                                  eventName: widget.event.name);
                                            },
                                          );
                                        }
                                      : null,
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
                                      side: BorderSide(
                                          color: Colors.black, width: 1.5),
                                    ),
                                  ),
                                  child: const Text('My Shares'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Options list
                          Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Row
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 64,
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        SizedBox(
                                          width: 64,
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Options List
                                  Column(
                                    children: options.map((option) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Option image
                                            CachedNetworkImage(
                                              imageUrl: option.imageLink ??
                                                  "https://i.imgur.com/dRk6nBk.jpeg",
                                              width: 29,
                                              height: 29,
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(width: 16),
                                            // Option title
                                            Expanded(
                                              child: Text(
                                                option.title,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            // Positive price button
                                            ValueListenableBuilder<int>(
                                              valueListenable:
                                                  UserProfile().balance,
                                              builder: (context, balance, _) {
                                                print("Balance: ${balance}");
                                                return ElevatedButton(
                                                  onPressed: (UserProfile()
                                                                  .userId
                                                                  .value >=
                                                              0 &&
                                                          option.positivePrice <=
                                                              balance)
                                                      ? () async {
                                                          await showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                true,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return BetConfirmation(
                                                                option: option,
                                                                eventName:
                                                                    widget.event
                                                                        .name,
                                                                isBuyYes: true,
                                                              );
                                                            },
                                                          );
                                                        }
                                                      : null,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        (option.positivePrice >
                                                                balance)
                                                            ? Colors.grey
                                                            : Colors.green,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      side: const BorderSide(
                                                          color: Colors.black,
                                                          width: 1),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: SizedBox(
                                                    width: 35,
                                                    child: Center(
                                                      child: Text(
                                                        '${option.positivePrice} c',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(width: 8),
                                            // Negative price button
                                            ValueListenableBuilder<int>(
                                              valueListenable:
                                                  UserProfile().balance,
                                              builder: (context, balance, _) {
                                                return ElevatedButton(
                                                  onPressed: (UserProfile()
                                                                  .userId
                                                                  .value >=
                                                              0 &&
                                                          option.negativePrice <=
                                                              balance)
                                                      ? () async {
                                                          await showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                true,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return BetConfirmation(
                                                                option: option,
                                                                eventName:
                                                                    widget.event
                                                                        .name,
                                                                isBuyYes: false,
                                                              );
                                                            },
                                                          );
                                                        }
                                                      : null,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        (option.negativePrice >
                                                                balance)
                                                            ? Colors.grey
                                                            : Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      side: BorderSide(
                                                          color: Colors.black,
                                                          width: 1),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: SizedBox(
                                                    width: 35,
                                                    child: Center(
                                                      child: Text(
                                                        '${option.negativePrice} c',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
