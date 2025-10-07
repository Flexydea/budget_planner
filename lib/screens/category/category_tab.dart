import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:budget_planner/utils/user_utils.dart';

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
    final list = await loadUserCategoriesForUser(
      currentUserId,
    );

    list.removeWhere(
      (c) =>
          (c['name'] as String).toLowerCase() ==
          name.toLowerCase(),
    );

    await saveUserCategoriesForUser(currentUserId, list);
    await _loadUserCategories();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name deleted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Categories",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: userCategories.isEmpty
          ? const Center(
              child: Text(
                "No categories yet",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: userCategories.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.2,
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
                      // 👉 later: navigate to category detail page
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
                                //  Icon
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                      Colors.black,
                                  child: Icon(
                                    icon,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),

                                //  Count badge
                                Container(
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
                                  child: const Text(
                                    "0",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
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
