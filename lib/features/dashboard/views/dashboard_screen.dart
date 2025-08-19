import 'package:flutter/material.dart';
import 'package:budget_planner/features/dashboard/widgets/progress_ring.dart';
import 'package:budget_planner/data/models/transaction_item.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // 🔹 Dummy data for last actions
  List<TransactionItem> get _lastActions => const [
    TransactionItem(
      title: 'Food',
      subtitle: 'Pizza Day',
      amount: -223,
      emoji: '🍕',
    ),
    TransactionItem(
      title: 'Travel',
      subtitle: 'Plane tickets to Barcelona',
      amount: -423,
      emoji: '✈️',
    ),
    TransactionItem(
      title: 'Gift',
      subtitle: 'Birthday present',
      amount: 73,
      emoji: '🎁',
    ),
    TransactionItem(
      title: 'Food',
      subtitle: 'Pizza Day',
      amount: -223,
      emoji: '🍕',
    ),
    TransactionItem(
      title: 'Travel',
      subtitle: 'Plane tickets to Barcelona',
      amount: -423,
      emoji: '✈️',
    ),
    TransactionItem(
      title: 'Gift',
      subtitle: 'Birthday present',
      amount: 73,
      emoji: '🎁',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // 🔸 Static sample values (can be replaced with dynamic state later)
    const double dailyLimit = 1267.0;
    const double spentToday = 1100.0;
    final double remaining = (dailyLimit - spentToday).clamp(0, dailyLimit);
    final double progress = (spentToday / dailyLimit).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 HEADER
              Row(
                children: [
                  Text(
                    'Home',
                    style: text.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // TODO: Go to profile/settings
                    },
                    icon: Icon(Icons.person_outline, color: Color(0xFF1A237E)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 🔸 SPENDING RING CARD
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 320,
                        height: 400,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ProgressRing(
                              progress: progress,
                              size: 320,
                              stroke: 16,
                              roundedCaps: false,
                              trackColor: scheme.primary.withOpacity(0.15),
                              progressColor: const Color(0xFF1A237E),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${spentToday.toStringAsFixed(0)}',
                                  style: text.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'You spent today',
                                  style: text.bodyMedium?.copyWith(
                                    color: scheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Divider(
                                  thickness: 1,
                                  indent: 30,
                                  endIndent: 30,
                                  color: scheme.outline.withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Balance for today',
                                  style: text.bodyMedium?.copyWith(
                                    color: scheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                                Text(
                                  '\$${remaining.toStringAsFixed(0)}',
                                  style: text.titleMedium?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 LAST ACTIONS HEADER WITH VIEW ALL
              Row(
                children: [
                  Text(
                    'Last actions',
                    style: text.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to full transaction list screen
                    },
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              //  LAST ACTIONS LIST - IN CARDS
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _lastActions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final t = _lastActions[i];
                  return Card(
                    elevation: 1,
                    color: scheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: scheme.outlineVariant, width: 1),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Text(
                        t.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      title: Text(
                        t.title,
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        t.subtitle,
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(.6),
                        ),
                      ),
                      trailing: Text(
                        '${t.isNegative ? '-' : '+'}\$${t.amount.abs().toStringAsFixed(0)}',
                        style: text.titleMedium?.copyWith(
                          color: t.trailingColor(scheme),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onTap: () {
                        // TODO: Open transaction detail
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
