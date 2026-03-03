import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/api/api_endpoints.dart';
import 'package:futal_booking_system/features/courts/presentation/providers/courts_details_provider.dart';
import 'package:futal_booking_system/features/slots/presentation/pages/slots_page.dart';

class CourtDetailsPage extends ConsumerWidget {
  final String courtId;
  const CourtDetailsPage({super.key, required this.courtId});

  static const green = Color(0xFF16A34A);

  String? _imageUrl(dynamic c) {
    final img = c.image;
    if (img == null || (img is String && img.isEmpty)) return null;

    final s = img.toString();
    if (s.startsWith("/uploads")) return "${ApiEndpoints.baseUrl}$s";
    if (s.startsWith("uploads/")) return "${ApiEndpoints.baseUrl}/$s";
    return "${ApiEndpoints.baseUrl}/uploads/$s";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCourt = ref.watch(courtDetailsProvider(courtId));

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Court Details",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: asyncCourt.when(
        data: (c) {
          final imageUrl = _imageUrl(c);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              // ✅ Image Card with overlay
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 18,
                      offset: Offset(0, 10),
                      color: Color(0x14000000),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 220,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (imageUrl != null)
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(child: Icon(Icons.image_not_supported)),
                            ),
                          )
                        else
                          Container(
                            color: Colors.grey.shade200,
                            child: const Center(child: Icon(Icons.image, size: 44)),
                          ),
                        // overlay
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.45),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 14,
                          right: 14,
                          bottom: 14,
                          child: Text(
                            c.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ✅ Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 18,
                      offset: Offset(0, 10),
                      color: Color(0x14000000),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: green.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.stadium_outlined, color: green),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            c.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 18, color: Colors.black54),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            (c.location ?? "Unknown location").toString(),
                            style: const TextStyle(color: Colors.black54, fontSize: 13.5),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.payments_outlined, size: 18, color: Colors.black54),
                        const SizedBox(width: 6),
                        Text(
                          c.pricePerHour != null ? "Rs ${c.pricePerHour}/hr" : "Price not set",
                          style: const TextStyle(
                            color: green,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ✅ Button Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 18,
                      offset: Offset(0, 10),
                      color: Color(0x14000000),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SlotsPage(courtId: courtId),
                        ),
                      );
                    },
                    icon: const Icon(Icons.schedule, color: Colors.white),
                    label: const Text(
                      "Check Available Slots",
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
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