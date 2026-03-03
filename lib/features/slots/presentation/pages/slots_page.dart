import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/features/bookings/presentation/pages/booking_screen.dart';
import 'package:futal_booking_system/features/slots/presentation/providers/slots_provider.dart';

class SlotsPage extends ConsumerWidget {
  final String courtId;
  const SlotsPage({super.key, required this.courtId});

  static const green = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(selectedDateProvider);
    final asyncSlots = ref.watch(slotsProvider(courtId));

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Available Slots",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          // ✅ Date Card (Green theme)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 18,
                    offset: Offset(0, 10),
                    color: Color(0x22000000),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.calendar_month, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Selected Date",
                          style: TextStyle(
                            color: Color(0xDFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          date,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.18),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
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

                        ref.read(selectedDateProvider.notifier).state = "$yyyy-$mm-$dd";
                        ref.refresh(slotsProvider(courtId));
                      }
                    },
                    child: const Text(
                      "Change",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: asyncSlots.when(
              data: (slots) {
                if (slots.isEmpty) {
                  return const Center(child: Text("No slots found"));
                }

                return RefreshIndicator(
                  color: green,
                  onRefresh: () async => ref.refresh(slotsProvider(courtId)),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: slots.length,
                    itemBuilder: (_, i) {
                      final s = slots[i];
                      final available = s.available == true;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 18,
                              offset: Offset(0, 10),
                              color: Color(0x14000000),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: !available
                              ? null
                              : () async {
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

                                  if (result == true) {
                                    ref.refresh(slotsProvider(courtId));
                                  }
                                },
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  height: 46,
                                  width: 46,
                                  decoration: BoxDecoration(
                                    color: available
                                        ? green.withOpacity(0.12)
                                        : Colors.red.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    available ? Icons.check_circle : Icons.block,
                                    color: available ? green : Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s.time,
                                        style: const TextStyle(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        available ? "Available" : "Booked",
                                        style: TextStyle(
                                          color: available ? green : Colors.red,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                if (available)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: green,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Text(
                                      "Book",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  )
                                else
                                  const Icon(Icons.lock, color: Colors.black38),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Error: $e",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}