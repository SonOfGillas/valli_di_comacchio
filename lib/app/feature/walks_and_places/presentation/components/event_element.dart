import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/event.dart';

class EventElement extends StatelessWidget {
  final Event event;

  const EventElement({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event.title),
      subtitle: Text(event.description),
      leading: Icon(Icons.event),
      onTap: () {
        // Handle tap event, e.g., navigate to event details
      },
    );
  }
}
