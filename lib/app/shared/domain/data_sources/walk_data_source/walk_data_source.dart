import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/walk.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/cloud_firestore/cloud_firestore.dart';
import 'package:valli_di_comacchio/app/shared/utils/get_walk_from_file.dart';

class WalkInfoLocation {
  final double price;
  final String imageFileName;
  final String gpxFileName;

  WalkInfoLocation({
    required this.price,
    required this.imageFileName,
    required this.gpxFileName,
  });

  WalkInfoLocation.fromMap(Map<String, dynamic> map)
      : price = double.parse(map['price'].toString()),
        imageFileName = map['imageFileName'] as String,
        gpxFileName = map['gpxFileName'] as String;
}

class WalkDataSource {
  final CloudFirestoreDataSource _cloudFirestoreDataSource;

  WalkDataSource(this._cloudFirestoreDataSource);

  Future<List<Walk>> fetchWalks() async {
    final data =
        await _cloudFirestoreDataSource.fetchData(DatabaseCollection.walks);
    final walkInfoLocations =
        data.map((walkData) => WalkInfoLocation.fromMap(walkData)).toList();

    final walks = await Future.wait(
        walkInfoLocations.map((walkInfo) => getWalkFromWalkInfo(walkInfo)));

    return walks;
  }
}
