import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/api/api_client.dart';
import 'package:futal_booking_system/features/courts/data/datasource/remote/court_remote_datasource.dart';
import 'package:futal_booking_system/features/courts/domain/repositories/court_repositorty.dart';
import 'package:futal_booking_system/features/courts/domain/usecases/get_all_courts_usecases.dart';
import '../../data/repositories/court_repository_impl.dart';
import '../../domain/entities/court_entity.dart';

final courtRemoteDataSourceProvider = Provider<CourtRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  return CourtRemoteDataSource(api);
});

final courtRepositoryProvider = Provider<CourtRepository>((ref) {
  final remote = ref.read(courtRemoteDataSourceProvider);
  return CourtRepositoryImpl(remote);
});

final getAllCourtsUsecaseProvider = Provider<GetAllCourtsUsecase>((ref) {
  final repo = ref.read(courtRepositoryProvider);
  return GetAllCourtsUsecase(repo);
});

final courtsProvider = FutureProvider<List<CourtEntity>>((ref) async {
  final usecase = ref.read(getAllCourtsUsecaseProvider);
  return usecase();
});
