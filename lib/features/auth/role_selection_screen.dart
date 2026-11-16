import 'package:flutter/material.dart';

import '../../core/theme/studio_tokens.dart';

enum UserRole { customer, admin }

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key, this.onRoleSelected});

  final ValueChanged<UserRole>? onRoleSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudioTokens.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewportConstraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight - 64,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: LayoutBuilder(
                      builder: (context, contentConstraints) {
                        final isWide = contentConstraints.maxWidth >= 800;
                        final customerCard = _RoleCard(
                          role: UserRole.customer,
                          title: 'Customer',
                          description: 'Browse styles, check dates and book your photoshoot',
                          icon: Icons.account_circle_outlined,
                          onTap: () => onRoleSelected?.call(UserRole.customer),
                        );
                        final adminCard = _RoleCard(
                          role: UserRole.admin,
                          title: 'Admin',
                          description: 'Manage orders, calendar and customers',
                          icon: Icons.manage_accounts_outlined,
                          requiresPassword: true,
                          onTap: () => onRoleSelected?.call(UserRole.admin),
                        );

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 36),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Welcome!',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontSize: 44),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'How would you like to continue?',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                    ),
                              ),
                              const SizedBox(height: 48),
                              if (isWide)
                                Row(
                                  children: [
                                    Expanded(child: customerCard),
                                    const SizedBox(width: 24),
                                    Expanded(child: adminCard),
                                  ],
                                )
                              else ...[
                                customerCard,
                                const SizedBox(height: 24),
                                adminCard,
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  const _RoleCard({
    required this.role,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    this.requiresPassword = false,
  });

  final UserRole role;
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final bool requiresPassword;

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _isHovered = false;

  bool get _isAdmin => widget.role == UserRole.admin;

  @override
  Widget build(BuildContext context) {
    final cardColor = _isAdmin
        ? (_isHovered ? const Color(0xFFFBC02D) : StudioTokens.accent)
        : (_isHovered ? const Color(0xFFF0F0F0) : Colors.white);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(28),
            splashColor: StudioTokens.accent.withValues(alpha: 0.2),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 320;
                return Padding(
                  padding: EdgeInsets.all(isCompact ? 16 : 24),
                  child: Row(
                    children: [
                      Icon(
                        widget.icon,
                        size: isCompact ? 64 : 88,
                        color: StudioTokens.cardText,
                      ),
                      SizedBox(width: isCompact ? 12 : 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontSize: isCompact ? 24 : 32,
                                    color: StudioTokens.cardText,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.description,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: StudioTokens.cardText,
                                    fontSize: isCompact ? 15 : 17,
                                    height: 1.4,
                                  ),
                            ),
                            if (widget.requiresPassword) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.lock_outline,
                                    size: 20,
                                    color: StudioTokens.cardText,
                                  ),
                                  SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Admin password required',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: StudioTokens.cardText,
                                            fontSize: 15,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: isCompact ? 8 : 16),
                      CircleAvatar(
                        radius: isCompact ? 18 : 22,
                        backgroundColor: _isAdmin
                            ? Colors.white
                            : StudioTokens.cardText,
                        foregroundColor: StudioTokens.cardText,
                        child: Icon(
                          Icons.chevron_right,
                          size: isCompact ? 24 : 28,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
