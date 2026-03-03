import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/features/payment/presentation/providers/my_booking_providers.dart';


final totalBookingsProvider = Provider<int>((ref) {
  final bookingsAsync = ref.watch(myBookingsProvider);

  return bookingsAsync.when(
    data: (list) => list.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});


final hoursPlayedProvider = Provider<String>((ref) {
  final bookingsAsync = ref.watch(myBookingsProvider);

  return bookingsAsync.when(
    data: (list) {
      double totalHours = 0;

      for (final b in list) {
        final start = (b.startTime ?? "").toString();
        final end = (b.endTime ?? "").toString();

        if (!start.contains(":") || !end.contains(":")) continue;

        final s = start.split(":");
        final e = end.split(":");

        final sh = int.tryParse(s[0]) ?? 0;
        final sm = int.tryParse(s[1]) ?? 0;
        final eh = int.tryParse(e[0]) ?? 0;
        final em = int.tryParse(e[1]) ?? 0;

        final startMin = sh * 60 + sm;
        final endMin = eh * 60 + em;

        final diff = endMin - startMin;
        if (diff > 0) totalHours += diff / 60.0;
      }

      return totalHours == 0 ? "-" : totalHours.toStringAsFixed(1);
    },
    loading: () => "-",
    error: (_, __) => "-",
  );
});