import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/event.dart';
import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/event_data_source/event_data_source.dart';

class EventRepository {
  final EventDataSource _eventDataSource;

  EventRepository(this._eventDataSource);

  AsyncResult<List<Event>> getAllEvents() async {
    try {
      final events = await _eventDataSource.fetchEvents();
      return Success(events);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }
}
