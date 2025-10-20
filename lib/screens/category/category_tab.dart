import 'package:budget_planner/screens/transactions/transaction_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:budget_planner/utils/user_utils.dart';
import 'package:budget_planner/services/hive_transaction_service.dart';
import 'package:lottie/lottie.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key});

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  //  Local list of user categories
  List<Map<String, dynamic>> userCategories = [];

  @override
  void initState() {
    super.initState();
    _loadUserCategories();
  }

  ///  Load categories for the logged-in user
  Future<void> _loadUserCategories() async {
    await loadCurrentUser();
    final list = await loadUserCategoriesForUser(
      currentUserId,
    );
    if (!mounted) return;
    setState(() => userCategories = list);
  }

  ///  Delete category by name
  Future<void> _deleteCategory(String name) async {
    await loadCurrentUser();

    // 🧹 Delete from user preferences and related transactions
    await deleteUserCategory(
      name,
    ); // uses the cleanup logic in user_utils.dart

    // Reload category list (to remove from UI)
    await _loadUserCategories();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name deleted successfully')),
    );
  }

  ///  Count total transactions belonging to a specific category
  int _getTransactionCount(String categoryName) {
    final allTxns =
        HiveTransactionService.getTransactionsByCategory(
          categoryName,
        );
    return allTxns.length;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.background,
        elevation: 0,
        // centerTitle: true,
        title: const Text(
          "Categories",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      //  Handle empty state
      body: userCategories.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/empty_box.json',
                    width: 300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No category yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add one from the + button',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: userCategories.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                itemBuilder: (context, index) {
                  final cat = userCategories[index];
                  final name = cat['name'];
                  final icon =
                      cat['icon'] ?? FontAwesomeIcons.tag;

                  return GestureDetector(
                    onLongPress: () =>
                        _showDeleteDialog(name),
                    onTap: () {
                      //  Navigate to Transaction List screen for this category
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TransactionListScreen(
                                categoryName: name,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface,
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.05,
                            ),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                //  Category icon circle
                                CircleAvatar(
                                  radius: 42,
                                  backgroundColor:
                                      Colors.black,
                                  child: Icon(
                                    icon,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),

                                //  Count badge overlay
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.circular(
                                            10,
                                          ),
                                    ),
                                    child: Text(
                                      _getTransactionCount(
                                        name,
                                      ).toString(),
                                      style:
                                          const TextStyle(
                                            color: Colors
                                                .white,
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            //  Category name
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  /// 🗑️ Confirm deletion dialog
  void _showDeleteDialog(String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Category"),
        content: Text(
          "Are you sure you want to delete '$name'?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _deleteCategory(name);
              setState(() {}); // refresh CategoryTab itself
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
