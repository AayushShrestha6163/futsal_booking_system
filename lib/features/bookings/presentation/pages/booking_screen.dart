import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/api/api_endpoints.dart';
import 'package:futal_booking_system/features/bookings/presentation/providers/booking_payment_providers.dart';
import 'package:futal_booking_system/features/payment/presentation/pages/esewa_webview_page.dart';


class BookingScreen extends ConsumerWidget {
  final String courtId;
  final String date;
  final String startTime;
  final String endTime;

  const BookingScreen({
    super.key,
    required this.courtId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  String _baseUrl() => ApiEndpoints.baseUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(bookingPaymentProvider);

    ref.listen(bookingPaymentProvider, (prev, next) {
      if (next.error != null && next.error!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
        ref.read(bookingPaymentProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Booking")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoTile("Court ID", courtId),
            _infoTile("Date", date),
            _infoTile("Start Time", startTime),
            _infoTile("End Time", endTime),
            const SizedBox(height: 18),
            const Text("Payment Method",
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text("eSewa"),
              subtitle: Text("Pay to confirm booking"),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: action.loading
                    ? null
                    : () async {
                        // 1) create booking
                        final bookingId = await ref
                            .read(bookingPaymentProvider.notifier)
                            .createBooking(
                              courtId: courtId,
                              date: date,
                              startTime: startTime,
                              endTime: endTime,
                            );
                        if (bookingId == null) return;

                        // 2) initiate esewa
                        final pay = await ref
                            .read(bookingPaymentProvider.notifier)
                            .initiateEsewa(bookingId);
                        if (pay == null) return;

                        final formUrl = pay["formUrl"] as String;
                        final fields = pay["fields"] as Map<String, dynamic>;

                        // 3) open webview
                        final successPrefix =
                            "${_baseUrl()}/api/payments/esewa/success";
                        final failurePrefix =
                            "${_baseUrl()}/api/payments/esewa/failure";

                        final ok = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EsewaWebviewPage(
                              formUrl: formUrl,
                              fields: fields,
                              successUrlPrefix: successPrefix,
                              failureUrlPrefix: failurePrefix,
                            ),
                          ),
                        );

                        // 4) return to SlotsPage
                        if (ok == true) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Payment successful")),
                            );
                            Navigator.pop(context, true);
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Payment failed/cancelled")),
                            );
                            Navigator.pop(context, false);
                          }
                        }
                      },
                child: action.loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Confirm & Pay (eSewa)"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text("$label:",
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}