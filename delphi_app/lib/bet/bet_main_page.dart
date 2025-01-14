import 'package:flutter/material.dart';
import '../model/event.dart';
import 'get_events_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/user_profile.dart';
import 'bet_event_page.dart';
/*
class BetMainPage extends StatefulWidget {
  @override
  _BetMainPageState createState() => _BetMainPageState();
}

class _BetMainPageState extends State<BetMainPage> {
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch events using the GetEventsService
    _eventsFuture = GetEventsService.getEvents(
      (UserProfile().userId.value == -1) ? null : UserProfile().userId.value,
      null, // categories can be null or specify categories if needed
      'market_cap', // orderBy parameter
      'desc', // orderDirection parameter
      1, // page number
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events available.'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                String imageUrl =
                    event.topOptionImage ?? "https://i.imgur.com/dRk6nBk.jpeg";
                return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(imageUrl),
                    ),
                    // TODO: Add end date
                    title: Text(event.name),
                    subtitle: Text(
                        'Shares: ${event.shares}, Market Cap: ${event.marketCap}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Option: ${event.topOptionTitle}'),
                        Text('Price: \$${event.topOptionPrice}'),
                        Text('UserBought: ${event.userBought}'),
                      ],
                    ),
                    onTap: () {
                      _handleItemClick(events[index]);
                    });
              },
            );
          }
        },
      ),
    );
  }

  void _handleItemClick(Event item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BetEventPage(event: item)),
    );
  }
}
*/

import 'package:flutter/material.dart';
import '../model/event.dart';
import 'get_events_service.dart';

class BetMainPage extends StatefulWidget {
  @override
  _BetMainPage createState() => _BetMainPage();
}

class _BetMainPage extends State<BetMainPage> {
  late ScrollController _scrollController;
  List<Event> events = [];
  bool isLoading = false;
  int currentPage = 1;
  String orderBy = 'market_cap'; // Change according to your preference
  String orderDirection = 'desc'; // Change according to your preference
  List<String>? categories = []; // Update categories as needed

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadEvents();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      // Load more events when the bottom is reached
      _loadEvents();
    }
  }

  Future<void> _loadEvents() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newEvents = await GetEventsService.getEvents(
        (UserProfile().userId.value == -1) ? null : UserProfile().userId.value,
        categories,
        orderBy,
        orderDirection,
        currentPage,
      );

      if (newEvents.isNotEmpty) {
        setState(() {
          events.addAll(newEvents);
          currentPage++; // Increment the page for next fetch
        });
      }
    } catch (e) {
      // Handle errors
      print("Error loading events: $e");
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
      appBar: AppBar(title: Text('Events')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: events.length + 1, // Add 1 for the loading indicator
        itemBuilder: (context, index) {
          if (index == events.length) {
            return _buildLoadingIndicator();
          }

          return GestureDetector(
            onTap: () {
              _handleItemClick(events[index]);
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with larger font
                    Text(
                      events[index].name,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    // Subtitle (End date)
                    Text(
                      events[index].endDate.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 12),
                    // Row for the top option and event details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side: Top Option Image + Title + Details
                        Row(
                          children: [
                            // Event image
                            CachedNetworkImage(
                              imageUrl: events[index].topOptionImage ??
                                  "https://i.imgur.com/dRk6nBk.jpeg",
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top option title (Medium text)
                                Text(
                                  events[index].topOptionTitle,
                                  style: TextStyle(fontSize: 16),
                                ),
                                // Market cap, Shares, and End Date (Small text)
                                Text(
                                  'Market Cap: ${events[index].marketCap}',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  'Shares: ${events[index].shares}',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  'End Date: ${events[index].endDate}',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Right side: Top option price and user bought status
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Top option price (Medium text)
                            Text(
                              '\$${events[index].topOptionPrice}',
                              style: TextStyle(fontSize: 16),
                            ),
                            // Show "You Bought" if userBought is true
                            if (events[index].userBought)
                              Text(
                                'You Bought',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.green),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SizedBox.shrink(); // If not loading, return nothing
    }
  }

  void _handleItemClick(Event item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BetEventPage(event: item)),
    );
  }
}
