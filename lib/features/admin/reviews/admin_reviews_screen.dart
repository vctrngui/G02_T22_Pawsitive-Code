import 'package:flutter/material.dart';

import '../../../core/theme/studio_tokens.dart';

class AdminReviewsScreen extends StatefulWidget {
  const AdminReviewsScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<AdminReviewsScreen> createState() => _AdminReviewsScreenState();
}

class _AdminReviewsScreenState extends State<AdminReviewsScreen> {
  static const _categories = [
    'All',
    'Wedding',
    'Maternity',
    'Pre-Wed',
    'Convocation',
  ];

  final _reviews = <_ReviewData>[
    _ReviewData(
      name: 'Fong',
      category: 'Maternity',
      date: '28 August 2026',
      rating: 5,
      comment: '"I felt comfortable the whole time."',
      isPublic: true,
    ),
    _ReviewData(
      name: 'Siti',
      category: 'Wedding',
      date: '30 August 2026',
      rating: 3,
      comment: '"I felt uncomfortable the whole time and the price is too expensive."',
      reply: 'Thank you, Siti for your review.',
      isPublic: false,
    ),
    _ReviewData(
      name: 'Nadia',
      category: 'Pre-Wed',
      date: '2 September 2026',
      rating: 4,
      comment: '"Beautiful photos and a lovely experience."',
      isPublic: true,
    ),
    _ReviewData(
      name: 'Daniel',
      category: 'Convocation',
      date: '5 September 2026',
      rating: 5,
      comment: '"The portraits turned out better than I imagined."',
      isPublic: true,
    ),
  ];

  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final visibleReviews = _selectedCategory == 'All'
        ? _reviews
        : _reviews
              .where((review) => review.category == _selectedCategory)
              .toList();

    return Scaffold(
      backgroundColor: StudioTokens.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: widget.onBack,
                        tooltip: 'Back to dashboard',
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: StudioTokens.textOnDark,
                        ),
                      ),
                      Text(
                        'Reviews',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontSize: 38,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const _RatingSummaryCard(),
                  const SizedBox(height: 30),
                  _buildCategoryFilters(),
                  const SizedBox(height: 20),
                  if (visibleReviews.isEmpty)
                    const _EmptyReviewsCard()
                  else
                    for (final review in visibleReviews) ...[
                      _ReviewCard(
                        review: review,
                        onPublicChanged: (value) {
                          setState(() => review.isPublic = value);
                        },
                        onReplyPressed: () => _editReply(review),
                      ),
                      if (review != visibleReviews.last)
                        const SizedBox(height: 18),
                    ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in _categories) ...[
            ChoiceChip(
              label: Text(category),
              selected: _selectedCategory == category,
              onSelected: (_) => setState(() => _selectedCategory = category),
              selectedColor: StudioTokens.accent,
              backgroundColor: const Color(0xFF49463F),
              labelStyle: TextStyle(
                color: _selectedCategory == category
                    ? StudioTokens.cardText
                    : StudioTokens.textOnDark,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
              ),
              shape: const StadiumBorder(),
              side: BorderSide.none,
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            ),
            if (category != _categories.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Future<void> _editReply(_ReviewData review) async {
    final controller = TextEditingController(text: review.reply ?? '');
    final reply = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: StudioTokens.card,
        title: Text(
          review.reply == null ? 'Reply to ${review.name}' : 'Edit your reply',
          style: const TextStyle(color: StudioTokens.cardText),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          style: const TextStyle(color: StudioTokens.cardText),
          decoration: const InputDecoration(
            hintText: 'Write a thoughtful response',
            hintStyle: TextStyle(color: StudioTokens.cardMuted),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: StudioTokens.cardMuted),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: StudioTokens.accent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            style: FilledButton.styleFrom(
              backgroundColor: StudioTokens.accent,
              foregroundColor: StudioTokens.cardText,
            ),
            child: const Text('Save reply'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (reply != null && reply.isNotEmpty) {
      setState(() => review.reply = reply);
    }
  }
}

class _RatingSummaryCard extends StatelessWidget {
  const _RatingSummaryCard();

  static const _scores = <(String, double)>[
    ('Wedding', 4.9),
    ('Maternity', 3.8),
    ('Pre-Wed', 4.8),
    ('Convocation', 5.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: StudioTokens.card,
        borderRadius: BorderRadius.circular(StudioTokens.cardRadius + 10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final score = _buildAverageScore();
          final breakdown = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (category, rating) in _scores)
                _ScoreBreakdownRow(category: category, rating: rating),
            ],
          );
          if (constraints.maxWidth < 280) {
            return Column(
              children: [score, const SizedBox(height: 18), breakdown],
            );
          }

          return Row(
            children: [
              score,
              const SizedBox(width: 14),
              Expanded(child: breakdown),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAverageScore() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '4.5',
              style: TextStyle(
                color: Colors.black,
                fontSize: 54,
                height: 0.95,
                fontWeight: FontWeight.w800,
                letterSpacing: -2,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.star, color: StudioTokens.accent, size: 26),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(99)),
          ),
          child: const Text(
            '653 reviews',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreBreakdownRow extends StatelessWidget {
  const _ScoreBreakdownRow({required this.category, required this.rating});

  final String category;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              category,
              style: const TextStyle(
                color: StudioTokens.cardMuted,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: rating / 5,
                minHeight: 6,
                backgroundColor: const Color(0xFFE9E9E9),
                valueColor: const AlwaysStoppedAnimation(StudioTokens.accent),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(
              rating.toStringAsFixed(1),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: StudioTokens.cardMuted,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewData {
  _ReviewData({
    required this.name,
    required this.category,
    required this.date,
    required this.rating,
    required this.comment,
    required this.isPublic,
    this.reply,
  });

  final String name;
  final String category;
  final String date;
  final int rating;
  final String comment;
  String? reply;
  bool isPublic;
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.review,
    required this.onPublicChanged,
    required this.onReplyPressed,
  });

  final _ReviewData review;
  final ValueChanged<bool> onPublicChanged;
  final VoidCallback onReplyPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 10),
      decoration: BoxDecoration(
        color: StudioTokens.card,
        borderRadius: BorderRadius.circular(StudioTokens.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(
                        color: StudioTokens.cardText,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${review.category} Photo - ${review.date}',
                      style: const TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _ReviewRating(rating: review.rating),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            review.comment,
            style: const TextStyle(color: Colors.black, fontSize: 15),
          ),
          if (review.reply != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2BF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                'Your reply: ${review.reply}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFFFD978)),
          const SizedBox(height: 3),
          Row(
            children: [
              TextButton.icon(
                onPressed: onReplyPressed,
                icon: Icon(
                  review.reply == null ? Icons.reply : Icons.edit_outlined,
                  size: 18,
                  color: StudioTokens.cardText,
                ),
                label: Text(
                  review.reply == null ? 'Reply' : 'Edit Reply',
                  style: const TextStyle(
                    color: StudioTokens.cardText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Flexible(
                      child: Text(
                        'Show on public profile',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Switch(
                      value: review.isPublic,
                      onChanged: onPublicChanged,
                      activeTrackColor: StudioTokens.accent,
                      inactiveTrackColor: const Color(0xFFBDBDBD),
                      thumbColor: const WidgetStatePropertyAll(
                        Color(0xFF555555),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewRating extends StatelessWidget {
  const _ReviewRating({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 1; index <= 5; index++)
              Icon(
                index <= rating ? Icons.star : Icons.star_border,
                size: 21,
                color: index <= rating
                    ? StudioTokens.accent
                    : const Color(0xFFBDBDBD),
              ),
          ],
        ),
        Text(
          'Rated $rating.0/5.0 by users',
          style: const TextStyle(
            color: StudioTokens.cardMuted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EmptyReviewsCard extends StatelessWidget {
  const _EmptyReviewsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: StudioTokens.card,
        borderRadius: BorderRadius.circular(StudioTokens.cardRadius),
      ),
      child: const Text(
        'No reviews in this category yet.',
        style: TextStyle(color: StudioTokens.cardText),
        textAlign: TextAlign.center,
      ),
    );
  }
}
