import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/features/courts/presentation/providers/courts_details_provider.dart';
import 'package:futal_booking_system/features/slots/presentation/pages/slots_page.dart';

class CourtDetailsPage extends ConsumerWidget {
  final String courtId;
  const CourtDetailsPage({super.key, required this.courtId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCourt = ref.watch(courtDetailsProvider(courtId));

    return Scaffold(
      appBar: AppBar(title: const Text("Court Details")),
      body: asyncCourt.when(
        data: (c) {
          // ✅ Same image url logic as your bookings page
          final imageUrl = (c.image != null && c.image!.isNotEmpty)
              ? (c.image!.startsWith("/uploads")
                  ? "http://10.0.2.2:8000${c.image}"
                  : "http://10.0.2.2:8000/uploads/${c.image}")
              : null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ✅ Image on top
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                )
              else
                Container(
                  height: 200,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.image, size: 40),
                ),

              const SizedBox(height: 16),

              // ✅ Title + info
              Text(
                c.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),

              if (c.location != null) Text("📍 ${c.location}"),
              const SizedBox(height: 8),

              if (c.pricePerHour != null)
                Text(
                  "💰 Rs ${c.pricePerHour}/hr",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

              const SizedBox(height: 30),

              // ✅ Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SlotsPage(courtId: courtId),
                    ),
                  );
                },
                child: const Text("Check Available Slots"),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}