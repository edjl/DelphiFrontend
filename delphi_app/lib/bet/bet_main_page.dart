import 'package:flutter/material.dart';
import 'model/event.dart';
import 'get_events_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../profile/model/user_profile.dart';
import 'bet_event_page.dart';

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
