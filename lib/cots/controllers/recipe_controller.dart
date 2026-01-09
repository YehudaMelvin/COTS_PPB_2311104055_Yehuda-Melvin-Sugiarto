import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

class RecipeController extends ChangeNotifier {
  final RecipeService _service = RecipeService();
  
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  
  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;

  // Hitung jumlah data untuk dashboard
  int get totalRecipes => _recipes.length;
  int get sarapanCount => _recipes.where((r) => r.category == 'Sarapan').length;
  int get siangCount => _recipes.where((r) => r.category == 'Makan Siang').length;
  int get malamCount => _recipes.where((r) => r.category == 'Makan Malam').length;
  int get dessertCount => _recipes.where((r) => r.category == 'Dessert').length;

  // Fetch Data
  Future<void> fetchRecipes() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _recipes = await _service.getRecipes();
    } catch (e) {
      debugPrint("Controller Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add Data
  Future<bool> addRecipe(Recipe recipe) async {
    _isLoading = true;
    notifyListeners();

    bool success = await _service.addRecipe(recipe);
    
    if (success) {
      await fetchRecipes(); // Refresh data otomatis jika berhasil simpan
    } 
    
    _isLoading = false;
    notifyListeners();
    
    return success;
  }
}