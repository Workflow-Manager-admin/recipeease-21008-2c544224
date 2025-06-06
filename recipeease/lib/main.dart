import 'package:flutter/material.dart';

// Recipe model class
class Recipe {
  String title;
  String description;
  String imageUrl;
  List<String> ingredients;
  List<String> steps;
  Map<String, String> nutrition;
  bool isFavorite;

  Recipe({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.nutrition,
    this.isFavorite = false,
  });
}

// PUBLIC_INTERFACE
void main() {
  /** This is the public entrypoint to the app. */
  runApp(RecipeEaseApp());
}

// Main app widget
class RecipeEaseApp extends StatelessWidget {
  const RecipeEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFFF7043);
    final Color secondaryColor = const Color(0xFFFFF3E0);
    final Color accentColor = const Color(0xFF388E3C);

    return MaterialApp(
      title: 'RecipeEase',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: secondaryColor,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: accentColor,
          surface: secondaryColor, // changed from deprecated background
        ),
        appBarTheme: AppBarTheme(
          color: primaryColor,
          foregroundColor: Colors.white,
          elevation: 1,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const MainContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Main container with bottom navigation
class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;

  List<Recipe> recipes = [
    Recipe(
      title: "Classic Pancakes",
      description: "Fluffy, buttery pancakes perfect for breakfast.",
      imageUrl: "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
      ingredients: [
        "2 cups all-purpose flour",
        "2 tbsp sugar",
        "2 tsp baking powder",
        "1/2 tsp salt",
        "2 eggs",
        "1 1/2 cups milk",
        "2 tbsp melted butter",
        "1 tsp vanilla extract",
      ],
      steps: [
        "In a bowl, mix flour, sugar, baking powder, and salt.",
        "In another bowl, whisk eggs, milk, melted butter, vanilla.",
        "Combine wet and dry ingredients. Stir until just mixed.",
        "Heat a skillet, pour 1/4 cup batter, cook until bubbles form.",
        "Flip and cook until golden. Repeat for all pancakes.",
      ],
      nutrition: {
        "Calories": "200",
        "Fat": "6g",
        "Carbs": "30g",
        "Protein": "5g",
      },
    ),
    Recipe(
      title: "Veggie Stir Fry",
      description: "A quick & healthy vegetable stir fry.",
      imageUrl: "https://images.unsplash.com/photo-1464306076886-debca5e8a6b0",
      ingredients: [
        "1 cup broccoli florets",
        "1 cup sliced bell peppers",
        "1/2 cup snap peas",
        "1 carrot, sliced",
        "2 tbsp soy sauce",
        "1 tbsp sesame oil",
        "2 cloves garlic",
      ],
      steps: [
        "Heat oil in a wok over high heat.",
        "Add garlic, stir for 30s.",
        "Add veggies and stir fry for 3–4 min.",
        "Add soy sauce. Stir and serve.",
      ],
      nutrition: {
        "Calories": "120",
        "Fat": "5g",
        "Carbs": "16g",
        "Protein": "3g",
      },
    ),
  ];

  // Search query string
  String _searchQuery = "";

  List<Recipe> get _filteredRecipes {
    if (_searchQuery.isEmpty) return recipes;
    return recipes
        .where(
          (r) =>
              r.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              r.description.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<Recipe> get _favoriteRecipes =>
      recipes.where((r) => r.isFavorite).toList();

  // Bottom navigation bar tap handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index != 0) {
        _searchQuery = "";
      }
    });
  }

  // Add a new recipe
  void _addRecipe(Recipe recipe) {
    setState(() {
      recipes.insert(0, recipe);
      _selectedIndex = 0;
    });
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen(
          recipes: _filteredRecipes,
          onSearch: (query) => setState(() => _searchQuery = query),
          onRecipeTap: (recipe) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(
                recipe: recipe,
                onToggleFavorite: _toggleFavorite,
              ),
            ),
          ),
        );
      case 1:
        return FavoritesScreen(
          recipes: _favoriteRecipes,
          onRecipeTap: (recipe) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(
                recipe: recipe,
                onToggleFavorite: _toggleFavorite,
              ),
            ),
          ),
        );
      case 2:
        return AddRecipeScreen(
          onRecipeAdded: _addRecipe,
        );
      default:
        return Container();
    }
  }

  // Toggle favorite status
  void _toggleFavorite(Recipe recipe) {
    setState(() {
      recipe.isFavorite = !recipe.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Recipe',
          ),
        ],
      ),
    );
  }
}

// Home Screen with search and recipe grid/list
class HomeScreen extends StatelessWidget {
  final List<Recipe> recipes;
  final void Function(String) onSearch;
  final void Function(Recipe) onRecipeTap;

  const HomeScreen({
    super.key,
    required this.recipes,
    required this.onSearch,
    required this.onRecipeTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // AppBar simulated with paddings for custom design
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                Icon(Icons.restaurant_menu,
                    color: Theme.of(context).colorScheme.primary, size: 32),
                SizedBox(width: 10),
                Text(
                  'RecipeEase',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: recipes.isEmpty
                ? Center(
                    child: Text(
                      "No recipes found.",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: recipes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).orientation == Orientation.portrait
                              ? 2
                              : 3,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, idx) {
                      return RecipeCard(
                        recipe: recipes[idx],
                        onTap: () => onRecipeTap(recipes[idx]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Recipe card used in grid/list
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 2,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                child: recipe.imageUrl.isNotEmpty
                    ? Image.network(
                        recipe.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, o, s) => Icon(Icons.photo, size: 48),
                      )
                    : Container(
                        color: Color(0xFFFFF3E0),
                        child: Icon(Icons.photo, size: 48),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                recipe.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Text(
                recipe.description,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// Favorites Screen
class FavoritesScreen extends StatelessWidget {
  final List<Recipe> recipes;
  final void Function(Recipe) onRecipeTap;

  const FavoritesScreen({super.key, required this.recipes, required this.onRecipeTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: recipes.isEmpty
          ? Center(
              child: Text(
                'No favorite recipes yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(14),
              itemCount: recipes.length,
              itemBuilder: (context, idx) {
                final recipe = recipes[idx];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: recipe.imageUrl.isNotEmpty
                        ? Image.network(
                            recipe.imageUrl,
                            height: 46,
                            width: 46,
                            fit: BoxFit.cover,
                            errorBuilder: (c, o, s) =>
                                Icon(Icons.photo, size: 28),
                          )
                        : Container(
                            color: Color(0xFFFFF3E0),
                            child: Icon(Icons.photo, size: 22),
                          ),
                  ),
                  title: Text(recipe.title,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    recipe.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () => onRecipeTap(recipe),
                );
              },
            ),
    );
  }
}

// Add Recipe Screen
class AddRecipeScreen extends StatefulWidget {
  final void Function(Recipe) onRecipeAdded;

  const AddRecipeScreen({super.key, required this.onRecipeAdded});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}
class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final List<TextEditingController> _ingredientControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> _stepControllers = [TextEditingController()];
  final Map<String, TextEditingController> _nutritionControllers = {
    "Calories": TextEditingController(),
    "Fat": TextEditingController(),
    "Carbs": TextEditingController(),
    "Protein": TextEditingController(),
  };

  void _addIngredientField() {
    setState(() => _ingredientControllers.add(TextEditingController()));
  }

  void _addStepField() {
    setState(() => _stepControllers.add(TextEditingController()));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final recipe = Recipe(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      ingredients: _ingredientControllers
          .map((c) => c.text.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      steps: _stepControllers
          .map((c) => c.text.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      nutrition: {
        for (var key in _nutritionControllers.keys)
          key: _nutritionControllers[key]!.text.trim()
      },
    );
    widget.onRecipeAdded(recipe);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Add Recipe'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Recipe Title'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter title' : null,
                  ),
                  SizedBox(height: 10),
                  // Description
                  TextFormField(
                    controller: _descController,
                    decoration: InputDecoration(labelText: 'Short Description'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter description' : null,
                  ),
                  SizedBox(height: 10),
                  // Image URL
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL (optional)'),
                  ),
                  SizedBox(height: 16),
                  Text("Ingredients", style: TextStyle(fontWeight: FontWeight.w600)),
                  ..._ingredientControllers.asMap().entries.map((entry) {
                    final idx = entry.key;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: entry.value,
                              decoration: InputDecoration(
                                labelText: 'Ingredient ${idx + 1}',
                              ),
                              validator: (v) {
                                if (idx == 0 &&
                                    (v == null || v.trim().isEmpty)) {
                                  return 'At least one ingredient';
                                }
                                return null;
                              },
                            ),
                          ),
                          if (idx == _ingredientControllers.length - 1)
                            IconButton(
                              icon: Icon(Icons.add_circle_outline,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              onPressed: _addIngredientField,
                            )
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 15),
                  Text("Steps", style: TextStyle(fontWeight: FontWeight.w600)),
                  ..._stepControllers.asMap().entries.map((entry) {
                    final idx = entry.key;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: entry.value,
                              decoration: InputDecoration(
                                labelText: 'Step ${idx + 1}',
                              ),
                              validator: (v) {
                                if (idx == 0 &&
                                    (v == null || v.trim().isEmpty)) {
                                  return 'At least one step';
                                }
                                return null;
                              },
                            ),
                          ),
                          if (idx == _stepControllers.length - 1)
                            IconButton(
                              icon: Icon(Icons.add_circle_outline,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              onPressed: _addStepField,
                            )
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 12),
                  Text("Nutritional Info (optional)",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nutritionControllers["Calories"],
                          decoration: InputDecoration(labelText: "Calories"),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _nutritionControllers["Fat"],
                          decoration: InputDecoration(labelText: "Fat"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nutritionControllers["Carbs"],
                          decoration: InputDecoration(labelText: "Carbs"),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _nutritionControllers["Protein"],
                          decoration: InputDecoration(labelText: "Protein"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      elevation: 1,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: Icon(Icons.check),
                    label: Text('Add Recipe'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Recipe Detail Screen
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  final void Function(Recipe) onToggleFavorite;

  const RecipeDetailScreen({super.key, required this.recipe, required this.onToggleFavorite});

  Widget _section(String heading, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: Icon(
              recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: recipe.isFavorite
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.white,
            ),
            onPressed: () => onToggleFavorite(recipe),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            recipe.imageUrl.isNotEmpty
                ? Image.network(
                    recipe.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => Container(
                      height: 220,
                      color: Color(0xFFFFF3E0),
                      child: Icon(Icons.photo, size: 46),
                    ),
                  )
                : Container(
                    height: 220,
                    color: Color(0xFFFFF3E0),
                    child: Icon(Icons.photo, size: 46),
                  ),
            Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.title,
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(recipe.description,
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey[700])),
                  SizedBox(height: 14),
                  // Ingredients Section
                  _section(
                    "Ingredients",
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: recipe.ingredients.isEmpty
                          ? [Text("(Not specified)")]
                          : recipe.ingredients
                              .map((i) => Row(
                                    children: [
                                      Icon(Icons.circle,
                                          size: 7,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      SizedBox(width: 7),
                                      Expanded(child: Text(i)),
                                    ],
                                  ))
                              .toList(),
                    ),
                  ),
                  // Steps Section
                  _section(
                    "Instructions",
                    recipe.steps.isEmpty
                        ? Text("(Not specified)")
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: recipe.steps
                                .asMap()
                                .entries
                                .map(
                                  (entry) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${entry.key + 1}. ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Expanded(child: Text(entry.value)),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  // Nutritional Info Section
                  if (recipe.nutrition.entries.any(
                      (e) => e.value.trim().isNotEmpty)) ...[
                    _section(
                      "Nutritional Information",
                      Table(
                        columnWidths: {
                          0: FlexColumnWidth(1.2),
                          1: FlexColumnWidth(1),
                        },
                        children: recipe.nutrition.entries
                            .where((e) => e.value.trim().isNotEmpty)
                            .map(
                              (entry) => TableRow(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 5),
                                      child: Text('${entry.key}:',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500))),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 5),
                                      child: Text(entry.value)),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
