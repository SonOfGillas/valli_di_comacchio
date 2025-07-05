import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/event.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/cloud_firestore/cloud_firestore.dart';

class EventDataSource {
  final CloudFirestoreDataSource _cloudFirestoreDataSource;

  EventDataSource(this._cloudFirestoreDataSource);

  Future<List<Event>> fetchEvents() async {
    final data =
        await _cloudFirestoreDataSource.fetchData(DatabaseCollection.events);
    return data.map((eventData) => Event.fromMap(eventData)).toList();
  }
}
