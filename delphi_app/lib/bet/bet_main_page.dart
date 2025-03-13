import 'package:delphi_app/shared_services/sound_effects.dart';
import 'package:flutter/material.dart';
import '../model/event.dart';
import 'get_events_service.dart';
import '../model/user_profile.dart';
import 'bet_event_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared_views/app_bar.dart';
import 'event_card.dart';

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
    //_scrollController.addListener(_scrollListener);
    _loadEvents();
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
          currentPage++;
        });
      }
    } catch (e) {
      // Handle errors
      print("Error loading events: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
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
          title: 'Delphi',
          height: 68,
        ),
        body: ListView.builder(
          controller: _scrollController,
          itemCount: events.length + 1, // Include the button as the last item
          shrinkWrap:
              true, // This ensures the ListView is tightly wrapped around the items
          padding: EdgeInsets.zero, // Remove any default padding from ListView
          itemBuilder: (context, index) {
            if (index < events.length) {
              // Build event cards
              return GestureDetector(
                onTap: () {
                  _handleItemClick(events[index]);
                },
                child: EventCard(event: events[index]),
              );
            } else {
              return Visibility(
                  visible: !isLoading, // Make button invisible when loading
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          _loadEvents();
                        },
                        child: Text(
                          "Load More Events",
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ));
            }
          },
        ));
  }

  void _handleItemClick(Event item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BetEventPage(event: item)),
    );
  }
}
