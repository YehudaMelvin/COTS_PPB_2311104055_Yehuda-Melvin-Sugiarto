import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/recipe.dart';

class RecipeService {
  
  // GET Recipes
  Future<List<Recipe>> getRecipes() async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/recipes?select=*');
      
      final response = await http.get(
        uri,
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => Recipe.fromJson(e)).toList();
      } else {
        debugPrint("GET Error: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      debugPrint("GET Exception: $e");
      return [];
    }
  }

  // POST Add Recipe
  Future<bool> addRecipe(Recipe recipe) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/recipes');
      
      final body = json.encode(recipe.toJson());

      debugPrint("POST Request ke: $uri");
      debugPrint("POST Body: $body");

      final response = await http.post(
        uri,
        headers: ApiConfig.headers,
        body: body,
      );

      debugPrint("POST Response Code: ${response.statusCode}");
      debugPrint("POST Response Body: ${response.body}");

      // 201 Created adalah kode sukses
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("POST Exception: $e");
      return false;
    }
  }
}