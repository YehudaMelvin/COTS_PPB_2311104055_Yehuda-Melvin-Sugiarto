import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/recipe_controller.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import 'recipe_detail_page.dart';
import 'add_recipe_page.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  // State Lokal untuk Filter & Search
  String _selectedCategory = "Semua";
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ["Semua", "Sarapan", "Makan Siang", "Makan Malam", "Dessert"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Daftar Resep", style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.text),
        actions: [
          // Button Tambah di Kanan Atas
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRecipePage())),
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 28),
          )
        ],
      ),
      body: Column(
        children: [
          // 1. SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Cari resep atau bahan...", 
                prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // 2. FILTER CATEGORY (Horizontal Scroll)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: _categories.map((category) {
                final bool isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // 3. LIST RESEP (Filtered)
          Expanded(
            child: Consumer<RecipeController>(
              builder: (context, controller, _) {
                // Logika Filter Lokal
                final filteredRecipes = controller.recipes.where((recipe) {
                  // Filter by Category
                  final matchCategory = _selectedCategory == "Semua" || recipe.category == _selectedCategory;
                  // Filter by Search
                  final matchSearch = recipe.title.toLowerCase().contains(_searchQuery) || 
                                      recipe.ingredients.toLowerCase().contains(_searchQuery);
                  
                  return matchCategory && matchSearch;
                }).toList();

                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (filteredRecipes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off, size: 64, color: AppColors.muted),
                        SizedBox(height: 16),
                        Text("Resep tidak ditemukan", style: AppTextStyles.caption),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: filteredRecipes.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.fastfood, color: AppColors.primary),
                        ),
                        title: Text(recipe.title, style: AppTextStyles.section),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(recipe.category, style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.muted),
                        onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}