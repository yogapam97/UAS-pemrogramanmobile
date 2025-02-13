import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final dynamic recipe;

  RecipeDetailPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final ingredients = <String>[];

    // Ambil bahan-bahan (strIngredient1-strIngredient20)
    for (int i = 1; i <= 20; i++) {
      final ingredient = recipe['strIngredient$i'];
      final measure = recipe['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add('$ingredient - $measure');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['strMeal'] ?? 'Recipe Detail'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Resep
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                recipe['strMealThumb'] ?? '',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),

            // Nama Resep
            Text(
              recipe['strMeal'] ?? 'Unknown Recipe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Kategori & Area
            Row(
              children: [
                Chip(
                  label: Text(recipe['strCategory'] ?? 'No Category'),
                  backgroundColor: Colors.orange.shade100,
                ),
                SizedBox(width: 8),
                if (recipe['strArea'] != null)
                  Chip(
                    label: Text(recipe['strArea'] ?? 'Unknown Area'),
                    backgroundColor: Colors.green.shade100,
                  ),
              ],
            ),
            SizedBox(height: 20),

            // Instruksi
            Text(
              'Instructions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              recipe['strInstructions'] ?? 'No instructions available',
              style: TextStyle(height: 1.5),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),

            // Bahan-bahan
            Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ingredients.isEmpty
                  ? [Text('No ingredients available')]
                  : ingredients
                      .map((ingredient) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 6),
                                SizedBox(width: 8),
                                Expanded(child: Text(ingredient)),
                              ],
                            ),
                          ))
                      .toList(),
            ),
            SizedBox(height: 30),

            // Tombol Kembali
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                label: Text('Back to Recipes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
