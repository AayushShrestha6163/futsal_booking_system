import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/features/courts/presentation/providers/courts_provider.dart';
import 'package:futal_booking_system/features/courts/presentation/pages/court_details_page.dart';

class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courtsAsync = ref.watch(courtsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Bookings")),
      body: courtsAsync.when(
        data: (courts) {
          if (courts.isEmpty) {
            return const Center(child: Text("No courts available"));
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(courtsProvider),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: courts.length,
              itemBuilder: (_, i) {
                final c = courts[i];

                final imageUrl = (c.image != null && c.image!.isNotEmpty)
                    ? (c.image!.startsWith("/uploads")
                        ? "http://10.0.2.2:8000${c.image}"
                        : "http://10.0.2.2:8000/uploads/${c.image}")
                    : null;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourtDetailsPage(courtId: c.id),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (imageUrl != null)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              imageUrl,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox(
                                height: 160,
                                child: Center(
                                  child: Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (c.location != null) Text("📍 ${c.location}"),
                              const SizedBox(height: 4),
                              if (c.pricePerHour != null)
                                Text(
                                  "💰 Rs ${c.pricePerHour}/hr",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
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
              "Failed to load courts.\n$e",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}