import 'package:flutter/material.dart';
import 'package:budget_planner/features/dashboard/widgets/progress_ring.dart';
import 'package:budget_planner/data/models/transaction_item.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ELS10: mock data; swap with repo later
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

    // ----- numbers (replace with real data later)
    const double dailyLimit = 1267.0; // 🔹 fixed target
    const double spentToday = 1100.0; // try 1267.0 to see 360°
    final double remaining = (dailyLimit - spentToday).clamp(0, dailyLimit);

    // ring progress (0..1)
    final double progress = (spentToday / dailyLimit).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  Text(
                    'Home',
                    style: text.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {}, // TODO: go to profile/settings
                    icon: Icon(Icons.person_outline, color: scheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // SPEND RING CARD (centered, large)
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
                        width: 320, // <<< large ring
                        height: 400,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ProgressRing(
                              progress: progress,
                              size: 320,
                              stroke: 16,
                              roundedCaps: false, // precise visual length
                              trackColor: scheme.primary.withOpacity(0.15),
                              progressColor: const Color(
                                0xFF1A237E,
                              ), // brand blue
                            ),
                            // inner texts
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Spent today
                                Text(
                                  '\$${spentToday.toStringAsFixed(0)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: scheme.onSurface,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'you spent today',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: scheme.onSurface.withOpacity(
                                          0.6,
                                        ),
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

                                // Remaining balance
                                Text(
                                  'balance for today',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: scheme.onSurface.withOpacity(
                                          0.6,
                                        ),
                                      ),
                                ),
                                Text(
                                  '\$${remaining.toStringAsFixed(0)}',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
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
                    // (Optional) space for small hint/CTA below the ring
                    // const SizedBox(height: 12),
                    // Text('Tap + to add a transaction', style: text.bodySmall?.copyWith(color: scheme.onSurface.withOpacity(.6))),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // LAST ACTIONS TITLE
              Text(
                'Last actions',
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),

              // LAST ACTIONS CARD
              Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _lastActions.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: scheme.outlineVariant),
                  itemBuilder: (context, i) {
                    final t = _lastActions[i];
                    return ListTile(
                      leading: Text(
                        t.emoji,
                        style: const TextStyle(fontSize: 24),
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
                        (t.isNegative ? '-' : '+') +
                            '\$${t.amount.abs().toStringAsFixed(0)}',
                        style: text.titleMedium?.copyWith(
                          color: t.trailingColor(scheme),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onTap: () {
                        // TODO: open details
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
