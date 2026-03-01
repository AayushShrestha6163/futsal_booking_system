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
        data: (c) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
            )
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}