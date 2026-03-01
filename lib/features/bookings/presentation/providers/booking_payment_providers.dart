import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:futal_booking_system/core/api/api_client.dart';
import 'package:futal_booking_system/features/bookings/data/datsources/remote/booking_remote_datsource.dart';
import 'package:futal_booking_system/features/payment/data/datasources/remote/payment_remote_datasouces.dart';


// --- datasources (use same ApiClient pattern like courts/slots) ---
final bookingRemoteDataSourceProvider = Provider<BookingRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  return BookingRemoteDataSource(api);
});

final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  return PaymentRemoteDataSource(api);
});

// --- state ---
class BookingPaymentState {
  final bool loading;
  final String? error;

  const BookingPaymentState({this.loading = false, this.error});

  BookingPaymentState copyWith({bool? loading, String? error}) {
    return BookingPaymentState(
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

// --- notifier ---
class BookingPaymentNotifier extends StateNotifier<BookingPaymentState> {
  BookingPaymentNotifier(this.ref) : super(const BookingPaymentState());
  final Ref ref;

  Future<String?> createBooking({
    required String courtId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    try {
      state = state.copyWith(loading: true, error: null);

      final ds = ref.read(bookingRemoteDataSourceProvider);
      final res = await ds.createBooking(
        courtId: courtId,
        date: date,
        startTime: startTime,
        endTime: endTime,
      );

      if (res["success"] == true) {
        final bookingId = res["bookingId"]?.toString();
        if (bookingId == null || bookingId.isEmpty) {
          throw Exception("bookingId missing from response");
        }
        state = state.copyWith(loading: false);
        return bookingId;
      }

      throw Exception(res["message"]?.toString() ?? "Booking failed");
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> initiateEsewa(String bookingId) async {
    try {
      state = state.copyWith(loading: true, error: null);

      final ds = ref.read(paymentRemoteDataSourceProvider);
      final res = await ds.initiateEsewa(bookingId);

      if (res["success"] == true) {
        final formUrl = res["formUrl"]?.toString();
        final fields = res["fields"];

        if (formUrl == null || formUrl.isEmpty || fields is! Map) {
          throw Exception("Invalid payment response");
        }

        state = state.copyWith(loading: false);
        return {
          "formUrl": formUrl,
          "fields": Map<String, dynamic>.from(fields),
        };
      }

      throw Exception(res["message"]?.toString() ?? "Payment initiate failed");
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final bookingPaymentProvider =
    StateNotifierProvider<BookingPaymentNotifier, BookingPaymentState>((ref) {
  return BookingPaymentNotifier(ref);
});