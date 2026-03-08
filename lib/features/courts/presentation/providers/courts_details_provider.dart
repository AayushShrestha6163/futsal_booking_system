import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/api/api_client.dart';
import 'package:futal_booking_system/features/courts/data/datasource/remote/court_remote_datasource.dart';
import 'package:futal_booking_system/features/courts/data/repositories/court_repository_impl.dart';
import 'package:futal_booking_system/features/courts/domain/entities/court_entity.dart';
import 'package:futal_booking_system/features/courts/domain/repositories/court_repositorty.dart';
import 'package:futal_booking_system/features/courts/domain/usecases/get_court_by_id_usecase.dart';


// datasource provider
final courtRemoteDataSourceProvider = Provider<CourtRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  return CourtRemoteDataSource(api);
});

// repo provider
final courtRepositoryProvider = Provider<CourtRepository>((ref) {
  final remote = ref.read(courtRemoteDataSourceProvider);
  return CourtRepositoryImpl(remote);
});

// usecase provider
final getCourtByIdUsecaseProvider = Provider<GetCourtByIdUsecase>((ref) {
  final repo = ref.read(courtRepositoryProvider);
  return GetCourtByIdUsecase(repo);
});

// ✅ THIS is the important one (family)
final courtDetailsProvider =
    FutureProvider.family<CourtEntity, String>((ref, id) async {
  final usecase = ref.read(getCourtByIdUsecaseProvider);
  return usecase(id);
});