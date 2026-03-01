import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/features/bookings/presentation/pages/booking_screen.dart';

import 'package:futal_booking_system/features/slots/presentation/providers/slots_provider.dart';

class SlotsPage extends ConsumerWidget {
  final String courtId;
  const SlotsPage({super.key, required this.courtId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(selectedDateProvider);
    final asyncSlots = ref.watch(slotsProvider(courtId));

    return Scaffold(
      appBar: AppBar(title: const Text("Available Slots")),
      body: Column(
        children: [
          // ✅ Date selector (simple)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text("Date: $date",
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                TextButton(
                  onPressed: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: now,
                      lastDate: now.add(const Duration(days: 30)),
                      initialDate: now,
                    );
                    if (picked != null) {
                      final yyyy = picked.year.toString().padLeft(4, '0');
                      final mm = picked.month.toString().padLeft(2, '0');
                      final dd = picked.day.toString().padLeft(2, '0');
                      ref.read(selectedDateProvider.notifier).state =
                          "$yyyy-$mm-$dd";
                      // refetch
                      ref.refresh(slotsProvider(courtId));
                    }
                  },
                  child: const Text("Change"),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: asyncSlots.when(
              data: (slots) {
                if (slots.isEmpty) {
                  return const Center(child: Text("No slots found"));
                }

                return RefreshIndicator(
                  onRefresh: () async => ref.refresh(slotsProvider(courtId)),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: slots.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final s = slots[i];
                      return ListTile(
                        title: Text(s.time),
                        subtitle: Text(s.available ? "Available" : "Booked"),
                        trailing: s.available
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.block, color: Colors.red),
                        onTap: s.available
    ? () async {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => BookingScreen(
              courtId: courtId,
              date: date,
              startTime: s.startTime,
              endTime: s.endTime,
            ),
          ),
        );

        // refresh slots after return
        if (result == true) {
          ref.refresh(slotsProvider(courtId));
        }
      }
    : null,
                      );
                    },
                  ),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          ),
        ],
      ),
    );
  }
}