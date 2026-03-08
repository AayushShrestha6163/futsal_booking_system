import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:futal_booking_system/core/api/api_client.dart';
import 'package:futal_booking_system/features/slots/data/datasources/remote/slot_remote_datasources.dart';

import 'package:futal_booking_system/features/slots/data/repositories/slot_repository_impl.dart';
import 'package:futal_booking_system/features/slots/domain/entities/slot_entity.dart';
import 'package:futal_booking_system/features/slots/domain/repositories/slot_repository.dart';
import 'package:futal_booking_system/features/slots/domain/usecases/get_slots_usecase.dart';

final slotRemoteDataSourceProvider = Provider<SlotRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  return SlotRemoteDataSource(api);
});

final slotRepositoryProvider = Provider<SlotRepository>((ref) {
  final remote = ref.read(slotRemoteDataSourceProvider);
  return SlotRepositoryImpl(remote);
});

final getSlotsUsecaseProvider = Provider<GetSlotsUsecase>((ref) {
  final repo = ref.read(slotRepositoryProvider);
  return GetSlotsUsecase(repo);
});

final selectedDateProvider = StateProvider<String>((ref) {
  // default: today (simple). You can change UI to choose date.
  final now = DateTime.now();
  final yyyy = now.year.toString().padLeft(4, '0');
  final mm = now.month.toString().padLeft(2, '0');
  final dd = now.day.toString().padLeft(2, '0');
  return "$yyyy-$mm-$dd";
});

final slotsProvider =
    FutureProvider.family<List<SlotEntity>, String>((ref, courtId) async {
  final date = ref.watch(selectedDateProvider);
  final usecase = ref.read(getSlotsUsecaseProvider);
  return usecase(courtId, date);
});