/*import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'model/option.dart';
import 'get_options_service.dart';
import '../profile/model/user_profile.dart';
import 'model/event.dart';

class BetEventPage extends StatefulWidget {
  final Event event; // Add a final field to store the event

  // Constructor to pass the event
  BetEventPage({required this.event});

  @override
  _BetEventPageState createState() => _BetEventPageState();
}

class _BetEventPageState extends State<BetEventPage> {
  //final Event event;
  // _BetEventPageState({required this.event});

  late Future<List<Option>> _optionsFuture;

  @override
  void initState() {
    super.initState();
    print('Checkpoint 0');
    _optionsFuture = GetOptionsService.getOptions(
        (UserProfile().userId.value == -1) ? null : UserProfile().userId.value,
        widget.event.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name), // Access the event via widget.event
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
              // return Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     // Event image
              //     CachedNetworkImage(
              //       imageUrl: widget.event.topOptionImage ??
              //           "https://i.imgur.com/dRk6nBk.jpeg",
              //       width: double.infinity,
              //       height: 200,
              //       fit: BoxFit.cover,
              //     ),
              //     SizedBox(height: 16),
              //     // Event name
              //     Text(
              //       widget.event.name,
              //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              //     ),
              //     SizedBox(height: 8),
              //     // Event details
              //     Text('Shares: ${widget.event.shares}'),
              //     Text('Market Cap: ${widget.event.marketCap}'),
              //     Text('Top Option: ${widget.event.topOptionTitle}'),
              //     Text('Price: \$${widget.event.topOptionPrice}'),
              //     Text('User Bought: ${widget.event.userBought}'),
              //     // You can add more details here if needed
              //   ],
              // );
              final options = snapshot.data!;
              Expanded (
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(options[index].title),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle "Yes" button press for _items[index]
                                print('Yes for: ${options[index].positivePrice}');
                              },
                              child: const Text('Yes'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle "No" button press for _items[index]
                                print('No for: ${options[index].negativePrice}');
                              },
                              child: const Text('No'),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            }
          },
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'model/option.dart';
import 'get_options_service.dart';
import '../profile/model/user_profile.dart';
import 'model/event.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name), // Access the event via widget.event
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
                    // Event image
                    CachedNetworkImage(
                      imageUrl: widget.event.topOptionImage ??
                          "https://i.imgur.com/dRk6nBk.jpeg",
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 16),
                    // Event name and details
                    Text(
                      widget.event.name,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Shares: ${widget.event.shares}'),
                    Text('Market Cap: ${widget.event.marketCap}'),
                    Text('Top Option: ${widget.event.topOptionTitle}'),
                    Text('Price: \$${widget.event.topOptionPrice}'),
                    Text('User Bought: ${widget.event.userBought}'),
                    SizedBox(height: 16),
                    // Options table
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text('Option'),
                        ),
                        DataColumn(
                          label: Text('YES'),
                        ),
                        DataColumn(
                          label: Text('NO'),
                        ),
                      ],
                      rows: options.map((option) {
                        return DataRow(
                          cells: [
                            DataCell(Text(option.title)),
                            DataCell(
                              ElevatedButton(
                                onPressed: () {
                                  // Handle YES button press for option
                                  print('YES for: ${option.positivePrice}');
                                },
                                child: Text('${option.positivePrice}'),
                              ),
                            ),
                            DataCell(
                              ElevatedButton(
                                onPressed: () {
                                  // Handle NO button press for option
                                  print('NO for: ${option.negativePrice}');
                                },
                                child: Text('${option.negativePrice}'),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      // rows: snapshot.data!.map((option) {
                      //   return DataRow(children: [
                      //     DataCell([Text(option.title)]),
                      //     DataCell(
                      //       Row (
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //         ElevatedButton (
                      //             onPressed: () {},
                      //             child: const Text(options[index].negativePrice),
                      //         )],
                      //     )),
                      //     DataCell(
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //         ElevatedButton (
                      //             onPressed: () {},
                      //             child: const Text(options[index].negativePrice),
                      //         )],
                      //     )),
                      //   ]).toList();
                      // })
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
