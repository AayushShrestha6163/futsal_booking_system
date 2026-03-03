import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/features/payment/presentation/providers/my_booking_providers.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  static const green = Color(0xFF16A34A);

  Color _statusColor(String? status) {
    final s = (status ?? "").toLowerCase();
    if (s.contains("cancel")) return Colors.red;
    if (s.contains("confirm")) return green;
    if (s.contains("pending")) return Colors.orange;
    return Colors.blueGrey;
  }

  Color _payColor(String? status) {
    final s = (status ?? "").toUpperCase();
    if (s == "PAID") return green;
    if (s == "PENDING") return Colors.orange;
    return Colors.red;
  }

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
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "My Bookings",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: bookingsAsync.when(
        data: (list) {
          return RefreshIndicator(
            color: green,
            onRefresh: () async => ref.invalidate(myBookingsProvider),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: (list.isEmpty) ? 1 : list.length + 1,
              itemBuilder: (_, i) {
                // ✅ Header card
                if (i == 0) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),
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
                      children: const [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Color(0x33FFFFFF),
                          child: Icon(Icons.receipt_long, color: Colors.white, size: 26),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Bookings",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Pull to refresh • Manage bookings",
                                style: TextStyle(
                                  color: Color(0xDFFFFFFF),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (list.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
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
                    child: const Column(
                      children: [
                        Icon(Icons.event_busy, size: 46, color: Colors.black45),
                        SizedBox(height: 10),
                        Text(
                          "No bookings yet",
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Book a court and your bookings will show here.",
                          style: TextStyle(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final b = list[i - 1];

                final canCancel = b.paymentStatus != "PAID" && b.status != "cancelled";

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
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Date + time
                          Row(
                            children: [
                              Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  color: green.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.calendar_month, color: green),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "${b.date}  ${b.startTime}-${b.endTime}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Text(
                                "Rs ${b.price}",
                                style: const TextStyle(
                                  color: green,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // ✅ Status chips
                          Row(
                            children: [
                              _Chip(
                                text: (b.status ?? "unknown").toString(),
                                color: _statusColor(b.status),
                              ),
                              const SizedBox(width: 8),
                              _Chip(
                                text: (b.paymentStatus ?? "unknown").toString(),
                                color: _payColor(b.paymentStatus),
                              ),
                              const Spacer(),

                              // ✅ Cancel button
                              if (canCancel)
                                InkWell(
                                  onTap: cancelState.isLoading
                                      ? null
                                      : () async {
                                          await ref
                                              .read(cancelBookingProvider.notifier)
                                              .cancel(b.id);
                                        },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.red.withOpacity(0.22)),
                                    ),
                                    child: cancelState.isLoading
                                        ? const SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Row(
                                            children: [
                                              Icon(Icons.cancel, size: 16, color: Colors.red),
                                              SizedBox(width: 6),
                                              Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                            ],
                          ),
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
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color color;
  const _Chip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}