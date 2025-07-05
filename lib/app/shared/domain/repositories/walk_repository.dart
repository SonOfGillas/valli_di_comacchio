import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/walk.dart';
import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/walk_data_source/walk_data_source.dart';

class WalkRepository {
  final WalkDataSource _walkDataSource;

  WalkRepository(this._walkDataSource);

  AsyncResult<List<Walk>> getAllWalks() async {
    try {
      final walks = await _walkDataSource.fetchWalks();
      return Success(walks);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (e) {
      return Error(UnknownFailure());
    }
  }
}
