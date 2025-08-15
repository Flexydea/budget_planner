import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// : your 4 tabs (replace bodies with real screens later)
import 'package:budget_planner/features/dashboard/views/dashboard_screen.dart';
import 'package:budget_planner/features/categories/views/categories_screen.dart';
import 'package:budget_planner/features/stats/views/stats_screen.dart';
import 'package:budget_planner/features/tips/views/tips_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0; // : 0=Home, 1=Categories, 2=FAB, 3=Stats, 4=Tips

  // : pages you’ll build out
  final _pages = const [
    DashboardScreen(), // Home
    CategoriesScreen(), // Categories
    SizedBox.shrink(), // placeholder; FAB overlays content
    StatsScreen(), // Statistics
    TipsScreen(), // Tips
  ];

  void _onTap(int i) {
    if (i == 2) {
      _showAddSheet(); // : central plus action
      return;
    }
    setState(() => _index = i);
  }

  Future<void> _showAddSheet() async {
    final scheme = Theme.of(context).colorScheme;
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text('Add Expense'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/expense/new'); // wire later
                },
              ),
              ListTile(
                leading: const Icon(Icons.category_outlined),
                title: const Text('Add Category'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/category/new'); // wire later
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: _pages[_index],

      // // In your Scaffold:
      // floatingActionButton: Transform.translate(
      //   offset: const Offset(
      //     0,
      //     8,
      //   ), // ↓ move FAB down ~8px (tweak 6–10 if needed)
      //   child: FloatingActionButton(
      //     heroTag: 'mainFab',
      //     onPressed: _showAddSheet,
      //     backgroundColor: const Color(0xFF1A237E),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(16),
      //     ),
      //     child: const Icon(Icons.add),
      //   ),
      // ),
      // floatingActionButtonLocation:
      //     _LoweredFabLocation(), // custom FAB position
      // In your Scaffold:
      bottomNavigationBar: BottomAppBar(
        elevation: 6,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.show_chart, label: 'Home', index: 0),
              _NavItem(
                icon: Icons.category_outlined,
                label: 'Categories',
                index: 1,
              ),

              // ⬇️ Middle “tab” plus – aligned with others
              _PlusTab(onTap: _showAddSheet),

              _NavItem(icon: Icons.bar_chart, label: 'Statistics', index: 3),
              _NavItem(icon: Icons.lightbulb_outline, label: 'Tips', index: 4),
            ],
          ),
        ),
      ),
    );
  }
}

///  Simple item for the BottomAppBar row
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_HomeShellState>()!;
    final scheme = Theme.of(context).colorScheme;
    final selected = state._index == index;
    final color = selected ? scheme.primary : scheme.onSurface.withOpacity(.45);

    return InkWell(
      onTap: () => state._onTap(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 1),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlusTab extends StatelessWidget {
  final VoidCallback onTap;
  const _PlusTab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E), // same as login button
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
