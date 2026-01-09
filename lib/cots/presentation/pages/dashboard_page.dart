import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/recipe_controller.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../widgets/custom_card.dart';
import 'add_recipe_page.dart';
import 'recipe_list_page.dart';
import 'recipe_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Memuat data saat aplikasi dibuka
    Future.microtask(() => 
      Provider.of<RecipeController>(context, listen: false).fetchRecipes()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Consumer<RecipeController>(
            builder: (context, controller, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER BARU: Kiri Total Resep, Kanan Link Daftar Resep
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total Resep", style: AppTextStyles.section),
                          Text(
                            "${controller.totalRecipes}", 
                            style: AppTextStyles.title.copyWith(fontSize: 32, color: AppColors.primary)
                          ),
                        ],
                      ),
                      // Link ke Daftar Resep di Pojok Kanan Atas
                      TextButton(
                        onPressed: () => Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => const RecipeListPage())
                        ),
                        child: const Text("Daftar Resep >", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Grid Kategori (Tetap)
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildCategoryCard("Sarapan", controller.sarapanCount),
                      _buildCategoryCard("Makan Siang", controller.siangCount),
                      _buildCategoryCard("Makan Malam", controller.malamCount),
                      _buildCategoryCard("Dessert", controller.dessertCount),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Resep Terbaru Header
                  const Text("Resep Terbaru", style: AppTextStyles.section),
                  const SizedBox(height: 12),

                  // List Recent Recipes
                  if (controller.isLoading) 
                    const Center(child: CircularProgressIndicator())
                  else if (controller.recipes.isEmpty)
                    const Text("Belum ada resep")
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.recipes.take(3).length, // Ambil 3 data saja
                      separatorBuilder: (c, i) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final recipe = controller.recipes[index];
                        return CustomCard(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe))),
                          child: Row(
                            children: [
                              Container(
                                width: 60, height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: const Icon(Icons.restaurant, color: AppColors.primary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(recipe.title, style: AppTextStyles.section),
                                    Text(recipe.category, style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: AppColors.muted)
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 32),

                  // BUTTON TAMBAH RESEP (KOTAK PANJANG DI BAWAH)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRecipePage())),
                      child: const Text("Tambah Resep Baru", style: AppTextStyles.button),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, int count) {
    return CustomCard(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("$count Resep", style: AppTextStyles.caption),
        ],
      ),
    );
  }
}