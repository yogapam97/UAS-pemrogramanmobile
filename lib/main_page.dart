import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'recipe_detail_page.dart';

class RecipeListPage extends StatefulWidget {
  @override
  _RecipeListPageState createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _recipes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRandomRecipes(); // Tampilkan resep acak saat pertama kali
  }

  // Fetch Random Recipes
  Future<void> fetchRandomRecipes() async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php');
    List<dynamic> randomMeals = [];
    for (int i = 0; i < 5; i++) {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        randomMeals.add(data['meals'][0]);
      }
    }
    setState(() {
      _recipes = randomMeals;
      _isLoading = false;
    });
  }

  // Search Recipes
  Future<void> searchRecipes(String query) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _recipes = data['meals'] ?? [];
        _isLoading = false;
      });
    } else {
      setState(() {
        _recipes = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Your Food'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Form Pencarian
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Recipe',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final query = _searchController.text.trim();
                    if (query.isNotEmpty) {
                      searchRecipes(query);
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Loading Indicator
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_recipes.isEmpty)
              Center(child: Text('No recipes found')),
            // List Resep dalam Card
            Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];
                  return _buildRecipeCard(recipe);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(dynamic recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetailPage(recipe: recipe),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Gambar Masakan
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  recipe['strMealThumb'] ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(width: 80, height: 80, color: Colors.grey),
                ),
              ),
              SizedBox(width: 16),
              // Info Resep
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['strMeal'] ?? 'Unknown Recipe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Category: ${recipe['strCategory'] ?? 'No Category'}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
