import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder.dart';

class BookingCalendarFlowScreen extends StatelessWidget {
  const BookingCalendarFlowScreen({super.key, this.initialSessionType});

  final String? initialSessionType;

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(title: 'Booking Calendar');
  }
}
