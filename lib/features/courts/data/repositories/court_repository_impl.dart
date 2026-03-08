import 'package:futal_booking_system/features/courts/data/datasource/remote/court_remote_datasource.dart';
import 'package:futal_booking_system/features/courts/domain/repositories/court_repositorty.dart';
import '../../domain/entities/court_entity.dart';
import '../models/court_model.dart';

class CourtRepositoryImpl implements CourtRepository {
  final CourtRemoteDataSource remote;
  CourtRepositoryImpl(this.remote);

  @override
  Future<List<CourtEntity>> getAllCourts() async {
    final data = await remote.getAllCourts();

    final list = (data is Map && data["courts"] is List)
        ? List.from(data["courts"])
        : <dynamic>[];

    return list
        .map((e) => CourtModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<CourtEntity> getCourtById(String id) async {
    final data = await remote.getCourtById(id);

    if (data is Map && data["court"] is Map) {
      final obj = Map<String, dynamic>.from(data["court"]);
      return CourtModel.fromJson(obj);
    }

    throw Exception("Court not found");
  }
}