import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nutrition_provider.dart';
import '../utils/app_theme.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<NutritionProvider>().initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTodayTab(),
            _buildFoodTab(),
            _buildGoalsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.secondaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Nutrition',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.secondaryColor,
                AppTheme.primaryColor,
              ],
            ),
          ),
        ),
      ),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [
          Tab(text: 'Today'),
          Tab(text: 'Food'),
          Tab(text: 'Goals'),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    return Consumer<NutritionProvider>(
      builder: (context, nutritionProvider, child) {
        if (nutritionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final progress = nutritionProvider.getNutritionProgress();
        final todayLog = nutritionProvider.getTodayLog();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Nutrition overview
            _buildNutritionOverview(progress),
            const SizedBox(height: 24),
            // Meals
            _buildMealsSection(todayLog),
            const SizedBox(height: 24),
            // Water intake
            _buildWaterIntake(),
          ],
        );
      },
    );
  }

  Widget _buildNutritionOverview(Map<String, dynamic> progress) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Nutrition',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildNutritionBar('Calories', progress['calories'], AppTheme.primaryColor),
            const SizedBox(height: 16),
            _buildNutritionBar('Protein', progress['protein'], AppTheme.secondaryColor),
            const SizedBox(height: 16),
            _buildNutritionBar('Carbs', progress['carbs'], AppTheme.accentColor),
            const SizedBox(height: 16),
            _buildNutritionBar('Fat', progress['fat'], AppTheme.warningColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionBar(String label, Map<String, dynamic> data, Color color) {
    final percentage = data['percentage'] as double;
    final consumed = data['consumed'];
    final goal = data['goal'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '$consumed / $goal',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
        const SizedBox(height: 4),
        Text(
          '${percentage.toStringAsFixed(1)}% of daily goal',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMealsSection(todayLog) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Meals',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                _showAddFoodDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Food'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildMealCard('Breakfast', Icons.wb_sunny, Colors.orange),
        const SizedBox(height: 12),
        _buildMealCard('Lunch', Icons.wb_sunny_outlined, Colors.blue),
        const SizedBox(height: 12),
        _buildMealCard('Dinner', Icons.nightlight_round, Colors.purple),
        const SizedBox(height: 12),
        _buildMealCard('Snacks', Icons.local_pizza, Colors.green),
      ],
    );
  }

  Widget _buildMealCard(String mealName, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          mealName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text('0 items • 0 calories'),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            _showAddFoodDialog();
          },
        ),
      ),
    );
  }

  Widget _buildWaterIntake() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Water Intake',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    _showWaterDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Water'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.water_drop, color: Colors.blue[400]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '0 / 2.5 L',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '0% of daily goal',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.0, // 0% progress
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodTab() {
    return Consumer<NutritionProvider>(
      builder: (context, nutritionProvider, child) {
        if (nutritionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final foodItems = nutritionProvider.foodItems;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search food items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Food categories
            _buildFoodCategories(),
            const SizedBox(height: 16),
            // Food items
            Text(
              'Popular Foods',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...foodItems.map((food) => _buildFoodItemCard(food)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildFoodCategories() {
    final categories = ['All', 'Protein', 'Carbs', 'Fruits', 'Vegetables', 'Dairy'];
    
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: false,
              onSelected: (selected) {
                // Filter by category
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodItemCard(food) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getCategoryColor(food.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(food.category),
            color: _getCategoryColor(food.category),
          ),
        ),
        title: Text(
          food.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(food.description),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildNutritionInfo('${food.caloriesPerUnit}', 'cal'),
                const SizedBox(width: 8),
                _buildNutritionInfo('${food.proteinPerUnit}g', 'protein'),
                const SizedBox(width: 8),
                _buildNutritionInfo('${food.carbsPerUnit}g', 'carbs'),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            _showAddFoodDialog();
          },
        ),
      ),
    );
  }

  Widget _buildNutritionInfo(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$value $label',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGoalsTab() {
    return Consumer<NutritionProvider>(
      builder: (context, nutritionProvider, child) {
        final goals = nutritionProvider.goals;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Goals overview
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Goals',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildGoalItem('Calories', '${goals.dailyCalories}', 'kcal', Icons.local_fire_department, AppTheme.primaryColor),
                    const SizedBox(height: 16),
                    _buildGoalItem('Protein', '${goals.dailyProtein}g', 'grams', Icons.fitness_center, AppTheme.secondaryColor),
                    const SizedBox(height: 16),
                    _buildGoalItem('Carbs', '${goals.dailyCarbs}g', 'grams', Icons.grain, AppTheme.accentColor),
                    const SizedBox(height: 16),
                    _buildGoalItem('Fat', '${goals.dailyFat}g', 'grams', Icons.opacity, AppTheme.warningColor),
                    const SizedBox(height: 16),
                    _buildGoalItem('Water', '${goals.dailyWater}L', 'liters', Icons.water_drop, Colors.blue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Goal settings
            Text(
              'Goal Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.edit, color: AppTheme.primaryColor),
                title: const Text('Edit Goals'),
                subtitle: const Text('Adjust your daily nutrition targets'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showEditGoalsDialog();
                },
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.track_changes, color: AppTheme.secondaryColor),
                title: const Text('Goal Type'),
                subtitle: Text(goals.goal.toUpperCase()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showGoalTypeDialog();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGoalItem(String label, String value, String unit, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '$value $unit',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddFoodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Food'),
        content: const Text('Food logging feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showWaterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Water'),
        content: const Text('Water tracking feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEditGoalsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Goals'),
        content: const Text('Goal editing feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showGoalTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Goal Type'),
        content: const Text('Goal type selection feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'protein':
        return Colors.red;
      case 'carbs':
        return Colors.orange;
      case 'fruits':
        return Colors.green;
      case 'vegetables':
        return Colors.lightGreen;
      case 'dairy':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'protein':
        return Icons.fitness_center;
      case 'carbs':
        return Icons.grain;
      case 'fruits':
        return Icons.apple;
      case 'vegetables':
        return Icons.eco;
      case 'dairy':
        return Icons.local_drink;
      default:
        return Icons.restaurant;
    }
  }
}
