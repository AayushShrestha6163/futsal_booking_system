import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/courts_provider.dart';
import '../pages/court_details_page.dart'; // ✅ if you have it

class CourtsPage extends ConsumerWidget {
  const CourtsPage({super.key});

  static const green = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courtsAsync = ref.watch(courtsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Courts",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: courtsAsync.when(
        data: (courts) {
          if (courts.isEmpty) {
            return const Center(child: Text("No courts available"));
          }

          return RefreshIndicator(
            color: green,
            onRefresh: () async => ref.refresh(courtsProvider),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: courts.length + 1,
              itemBuilder: (_, i) {
                // ✅ Header card (green theme)
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
                          child: Icon(Icons.sports_soccer, color: Colors.white, size: 26),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Available Courts",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Tap a court to view details & slots",
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

                final c = courts[i - 1];

                final location = (c.location ?? "Unknown location").toString();
                final price = c.pricePerHour != null ? "Rs ${c.pricePerHour}/hr" : "Price not set";

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
                    onTap: () {
                      // ✅ If you already have CourtDetailsPage:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourtDetailsPage(courtId: c.id),
                        ),
                      );

                      // If you don't have details page yet, just comment this.
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          // ✅ Left icon badge
                          Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              color: green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.stadium_outlined, color: green),
                          ),

                          const SizedBox(width: 12),

                          // ✅ Name + location
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.black54),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        location,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          // ✅ Price chip + arrow
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: green.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  price,
                                  style: const TextStyle(
                                    color: green,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
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