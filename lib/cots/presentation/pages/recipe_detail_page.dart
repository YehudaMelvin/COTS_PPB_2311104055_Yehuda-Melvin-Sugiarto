import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../widgets/custom_card.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Resep", style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recipe.title, style: AppTextStyles.title.copyWith(fontSize: 24, color: AppColors.primary)),
            const SizedBox(height: 8),
            Chip(
              label: Text(recipe.category),
              backgroundColor: AppColors.primary.withOpacity(0.1),
              labelStyle: const TextStyle(color: AppColors.primary),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle("Bahan-bahan"),
            CustomCard(
              child: SizedBox(width: double.infinity, child: Text(recipe.ingredients, style: AppTextStyles.body)),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle("Langkah-langkah"),
            CustomCard(
              child: SizedBox(width: double.infinity, child: Text(recipe.steps, style: AppTextStyles.body)),
            ),
            const SizedBox(height: 16),
            
            if (recipe.note.isNotEmpty) ...[
              _buildSectionTitle("Catatan"),
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  border: Border.all(color: Colors.yellow[200]!),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text(recipe.note, style: AppTextStyles.caption.copyWith(color: Colors.orange[800])),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: AppTextStyles.section),
    );
  }
}