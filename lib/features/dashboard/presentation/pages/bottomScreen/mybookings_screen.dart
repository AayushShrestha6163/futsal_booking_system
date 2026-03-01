import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/features/payment/presentation/providers/my_booking_providers.dart';


class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(myBookingsProvider);
    final cancelState = ref.watch(cancelBookingProvider);

    ref.listen(cancelBookingProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Booking cancelled ✅")),
          );
        },
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Cancel failed: $e")),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: bookingsAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text("No bookings yet"));
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(myBookingsProvider),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final b = list[i];

                final canCancel =
                    b.paymentStatus != "PAID" && b.status != "cancelled";

                return ListTile(
                  title: Text("${b.date}  ${b.startTime}-${b.endTime}"),
                  subtitle: Text(
                    "Rs ${b.price} • ${b.status} • ${b.paymentStatus}",
                  ),
                  trailing: canCancel
                      ? IconButton(
                          icon: cancelState.isLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.cancel),
                          onPressed: cancelState.isLoading
                              ? null
                              : () async {
                                  await ref
                                      .read(cancelBookingProvider.notifier)
                                      .cancel(b.id);
                                },
                        )
                      : null,
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}