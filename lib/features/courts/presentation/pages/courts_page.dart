import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/courts_provider.dart';

class CourtsPage extends ConsumerWidget {
  const CourtsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courtsAsync = ref.watch(courtsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Courts")),
      body: courtsAsync.when(
        data: (courts) => RefreshIndicator(
          onRefresh: () async => ref.refresh(courtsProvider),
          child: ListView.builder(
            itemCount: courts.length,
            itemBuilder: (_, i) {
              final c = courts[i];
              return ListTile(
                title: Text(c.name),
                subtitle: Text(
                  [
                    if (c.location != null) c.location!,
                    if (c.pricePerHour != null) "Rs ${c.pricePerHour}/hr",
                  ].join(" • "),
                ),
                onTap: () {
                  // next step: details + slots
                },
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}