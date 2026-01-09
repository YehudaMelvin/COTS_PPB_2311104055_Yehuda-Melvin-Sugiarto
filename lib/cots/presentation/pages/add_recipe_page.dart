import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/recipe_controller.dart';
import '../../models/recipe.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedCategory = "Sarapan";

  final List<String> _categories = ["Sarapan", "Makan Siang", "Makan Malam", "Dessert"];

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final newRecipe = Recipe(
        title: _titleController.text,
        category: _selectedCategory,
        ingredients: _ingredientsController.text,
        steps: _stepsController.text,
        note: _noteController.text,
        createdAt: DateTime.now().toIso8601String(),
      );

      final success = await Provider.of<RecipeController>(context, listen: false).addRecipe(newRecipe);

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Resep berhasil disimpan")));
      } else if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menyimpan resep")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Resep", style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Judul Resep"),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration("Contoh: Nasi Goreng"),
                validator: (val) => val!.isEmpty ? "Judul wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              
              _buildLabel("Kategori"),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: _inputDecoration(""),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),

              _buildLabel("Bahan-bahan"),
              TextFormField(
                controller: _ingredientsController,
                maxLines: 3,
                decoration: _inputDecoration("Pisahkan dengan koma"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              _buildLabel("Langkah-langkah"),
              TextFormField(
                controller: _stepsController,
                maxLines: 3,
                decoration: _inputDecoration("Jelaskan cara membuat"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              _buildLabel("Catatan (Opsional)"),
              TextFormField(
                controller: _noteController,
                decoration: _inputDecoration("Tambahan info"),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 48, // 
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // 
                  ),
                  onPressed: _submit,
                  child: const Text("Simpan Resep", style: AppTextStyles.button),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // 
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: AppTextStyles.section.copyWith(fontSize: 14)),
    );
  }
}