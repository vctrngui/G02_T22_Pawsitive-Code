import 'package:flutter/material.dart';

import '../../core/widgets/back_navigation.dart';
import '../../theme/design_tokens.dart';

enum BookingStatus { pending, confirmed }

@immutable
class AdminBooking {
  const AdminBooking({
    required this.customerName,
    required this.sessionType,
    required this.status,
    required this.dateTime,
    required this.paymentStatus,
  });

  final String customerName;
  final String sessionType;
  final BookingStatus status;
  final String dateTime;
  final String paymentStatus;
}

const sampleAdminBookings = [
  AdminBooking(
    customerName: 'Fong',
    sessionType: 'Wedding Photo',
    status: BookingStatus.pending,
    dateTime: '30 August 2026 · 10:00 AM',
    paymentStatus: 'Payment pending',
  ),
  AdminBooking(
    customerName: 'Dayang',
    sessionType: 'Wedding Photo',
    status: BookingStatus.confirmed,
    dateTime: '26 August 2026 · 10:00 AM',
    paymentStatus: 'Payment completed',
  ),
];

class AdminBookingsScreen extends StatelessWidget {
  const AdminBookingsScreen({
    super.key,
    this.bookings = sampleAdminBookings,
    this.onBookingSelected,
  });

  final List<AdminBooking> bookings;
  final ValueChanged<AdminBooking>? onBookingSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const ScreenHeader(
                  title: 'Booking',
                  fallbackLocation: '/admin/dashboard',
                ),
                const SizedBox(height: 28),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        for (var index = 0; index < bookings.length; index++)
                          _BookingListItem(
                            booking: bookings[index],
                            onSelected: onBookingSelected,
                            showDivider: index < bookings.length - 1,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingListItem extends StatelessWidget {
  const _BookingListItem({
    required this.booking,
    required this.onSelected,
    required this.showDivider,
  });

  final AdminBooking booking;
  final ValueChanged<AdminBooking>? onSelected;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final isConfirmed = booking.status == BookingStatus.confirmed;
    final badgeColor = isConfirmed
        ? DesignTokens.confirmedGreen
        : DesignTokens.studioYellow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.customerName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: DesignTokens.cardText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.sessionType,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: Color(0xFF858585), fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _StatusChip(
                label: isConfirmed ? 'Confirmed' : 'Pending',
                color: badgeColor,
                foregroundColor: isConfirmed
                    ? Colors.white
                    : DesignTokens.cardText,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _BookingInfoRow(
          icon: Icons.calendar_month_outlined,
          text: booking.dateTime,
        ),
        const SizedBox(height: 8),
        _BookingInfoRow(
          icon: Icons.credit_card_outlined,
          text: booking.paymentStatus,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => onSelected?.call(booking),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF858585),
              padding: const EdgeInsets.symmetric(vertical: 8),
              visualDensity: VisualDensity.compact,
            ),
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.chevron_right, size: 22),
            label: const Text('See details'),
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Color(0xFFE0E0E0)),
        if (!showDivider) const SizedBox(height: 4),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.color,
    required this.foregroundColor,
  });

  final String label;
  final Color color;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: foregroundColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _BookingInfoRow extends StatelessWidget {
  const _BookingInfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: const Color(0xFFB0B0B0)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: const Color(0xFFB0B0B0), fontSize: 14),
          ),
        ),
      ],
    );
  }
}
