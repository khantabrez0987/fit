import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nutrition_provider.dart';
import '../utils/app_theme.dart';
import '../models/nutrition.dart';

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
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    _showAddFoodDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Food'),
                ),
                TextButton.icon(
                  onPressed: () {
                    _showManualCalorieDialog();
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Quick Add'),
                ),
              ],
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
    return Consumer<NutritionProvider>(
      builder: (context, nutritionProvider, child) {
        final todayLog = nutritionProvider.getTodayLog();
        final mealEntries = todayLog?.meals.where((entry) => entry.mealType == mealName).toList() ?? [];
        final totalCalories = mealEntries.fold(0, (sum, entry) => sum + entry.calories);
        
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
            subtitle: Text('${mealEntries.length} items • $totalCalories calories'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showAddFoodDialog();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaterIntake() {
    return Consumer<NutritionProvider>(
      builder: (context, nutritionProvider, child) {
        final progress = nutritionProvider.getNutritionProgress();
        final waterData = progress['water'];
        final consumed = waterData['consumed'] as double;
        final goal = waterData['goal'] as double;
        final percentage = waterData['percentage'] as double;

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
                            '${consumed.toStringAsFixed(1)} / ${goal.toStringAsFixed(1)} L',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(1)}% of daily goal',
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
                        widthFactor: (percentage / 100).clamp(0.0, 1.0),
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
      },
    );
  }

  Widget _buildFoodTab() {
    return Consumer<NutritionProvider>(
      builder: (context, nutritionProvider, child) {
        if (nutritionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return FoodSearchTab(nutritionProvider: nutritionProvider);
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
            _showAddFoodDialog(selectedFoodId: food.id);
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

  void _showAddFoodDialog({String? selectedFoodId}) {
    showDialog(
      context: context,
      builder: (context) => AddFoodDialog(
        selectedFoodId: selectedFoodId,
        onFoodAdded: (foodId, quantity, mealType) {
          context.read<NutritionProvider>().addFoodToLog(foodId, quantity, mealType);
        },
      ),
    );
  }

  void _showWaterDialog() {
    showDialog(
      context: context,
      builder: (context) => AddWaterDialog(
        onWaterAdded: (amount) {
          context.read<NutritionProvider>().addWaterToLog(amount);
        },
      ),
    );
  }

  void _showEditGoalsDialog() {
    showDialog(
      context: context,
      builder: (context) => EditGoalsDialog(
        onGoalsUpdated: (newGoals) {
          context.read<NutritionProvider>().updateGoals(newGoals);
        },
      ),
    );
  }

  void _showGoalTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => GoalTypeDialog(
        onGoalTypeUpdated: (goalType) {
          final currentGoals = context.read<NutritionProvider>().goals;
          final newGoals = UserNutritionGoals(
            dailyCalories: currentGoals.dailyCalories,
            dailyProtein: currentGoals.dailyProtein,
            dailyCarbs: currentGoals.dailyCarbs,
            dailyFat: currentGoals.dailyFat,
            dailyWater: currentGoals.dailyWater,
            goal: goalType,
          );
          context.read<NutritionProvider>().updateGoals(newGoals);
        },
      ),
    );
  }

  void _showManualCalorieDialog() {
    showDialog(
      context: context,
      builder: (context) => ManualCalorieDialog(
        onCalorieAdded: (calories, mealType, description) {
          context.read<NutritionProvider>().addManualCalorieEntry(calories, mealType, description);
        },
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

class AddFoodDialog extends StatefulWidget {
  final String? selectedFoodId;
  final Function(String foodId, double quantity, String mealType) onFoodAdded;

  const AddFoodDialog({
    super.key,
    this.selectedFoodId,
    required this.onFoodAdded,
  });

  @override
  State<AddFoodDialog> createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  String? _selectedFoodId;
  double _quantity = 1.0;
  String _selectedMealType = 'Breakfast';
  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  @override
  void initState() {
    super.initState();
    _selectedFoodId = widget.selectedFoodId;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NutritionProvider>(
      builder: (context, nutritionProvider, child) {
        final foodItems = nutritionProvider.foodItems;
        final selectedFood = _selectedFoodId != null
            ? foodItems.firstWhere((f) => f.id == _selectedFoodId)
            : null;

        return AlertDialog(
          title: const Text('Add Food'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Food selection dropdown
                DropdownButtonFormField<String>(
                  value: _selectedFoodId,
                  decoration: const InputDecoration(
                    labelText: 'Select Food',
                    border: OutlineInputBorder(),
                  ),
                  items: foodItems.map((food) {
                    return DropdownMenuItem(
                      value: food.id,
                      child: Text(food.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFoodId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Quantity input
                TextFormField(
                  initialValue: _quantity.toString(),
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: const OutlineInputBorder(),
                    suffixText: selectedFood?.unit ?? 'units',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _quantity = double.tryParse(value) ?? 1.0;
                  },
                ),
                const SizedBox(height: 16),
                
                // Meal type selection
                DropdownButtonFormField<String>(
                  value: _selectedMealType,
                  decoration: const InputDecoration(
                    labelText: 'Meal Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _mealTypes.map((mealType) {
                    return DropdownMenuItem(
                      value: mealType,
                      child: Text(mealType),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMealType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Nutrition preview
                if (selectedFood != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nutrition Info (${_quantity}x ${selectedFood.unit})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Calories: ${(_quantity * selectedFood.caloriesPerUnit).round()}'),
                              Text('Protein: ${(_quantity * selectedFood.proteinPerUnit).toStringAsFixed(1)}g'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Carbs: ${(_quantity * selectedFood.carbsPerUnit).toStringAsFixed(1)}g'),
                              Text('Fat: ${(_quantity * selectedFood.fatPerUnit).toStringAsFixed(1)}g'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _selectedFoodId != null
                  ? () {
                      widget.onFoodAdded(_selectedFoodId!, _quantity, _selectedMealType);
                      Navigator.pop(context);
                    }
                  : null,
              child: const Text('Add Food'),
            ),
          ],
        );
      },
    );
  }
}

class AddWaterDialog extends StatefulWidget {
  final Function(double amount) onWaterAdded;

  const AddWaterDialog({
    super.key,
    required this.onWaterAdded,
  });

  @override
  State<AddWaterDialog> createState() => _AddWaterDialogState();
}

class _AddWaterDialogState extends State<AddWaterDialog> {
  double _amount = 0.25; // Default to 250ml
  final List<double> _quickAmounts = [0.25, 0.5, 0.75, 1.0]; // 250ml, 500ml, 750ml, 1L

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Water'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select amount to add:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          
          // Quick amount buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickAmounts.map((amount) {
              final isSelected = _amount == amount;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _amount = amount;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(amount * 1000).round()}ml',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Custom amount input
          TextFormField(
            initialValue: (_amount * 1000).round().toString(),
            decoration: const InputDecoration(
              labelText: 'Custom Amount (ml)',
              border: OutlineInputBorder(),
              suffixText: 'ml',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final mlAmount = double.tryParse(value) ?? 0;
              _amount = mlAmount / 1000; // Convert to liters
            },
          ),
          
          const SizedBox(height: 16),
          
          // Current selection display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.water_drop, color: Colors.blue[400]),
                const SizedBox(width: 8),
                Text(
                  'Adding ${(_amount * 1000).round()}ml (${_amount.toStringAsFixed(2)}L)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _amount > 0
              ? () {
                  widget.onWaterAdded(_amount);
                  Navigator.pop(context);
                }
              : null,
          child: const Text('Add Water'),
        ),
      ],
    );
  }
}

class EditGoalsDialog extends StatefulWidget {
  final Function(UserNutritionGoals newGoals) onGoalsUpdated;

  const EditGoalsDialog({
    super.key,
    required this.onGoalsUpdated,
  });

  @override
  State<EditGoalsDialog> createState() => _EditGoalsDialogState();
}

class _EditGoalsDialogState extends State<EditGoalsDialog> {
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;
  late TextEditingController _waterController;

  @override
  void initState() {
    super.initState();
    // Initialize with default values - will be updated in build method
    _caloriesController = TextEditingController(text: '2000');
    _proteinController = TextEditingController(text: '150');
    _carbsController = TextEditingController(text: '250');
    _fatController = TextEditingController(text: '65');
    _waterController = TextEditingController(text: '2.5');
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NutritionProvider>(
      builder: (context, nutritionProvider, child) {
        // Update controllers with current values if they haven't been set yet
        if (_caloriesController.text == '2000') {
          final currentGoals = nutritionProvider.goals;
          _caloriesController.text = currentGoals.dailyCalories.toString();
          _proteinController.text = currentGoals.dailyProtein.toString();
          _carbsController.text = currentGoals.dailyCarbs.toString();
          _fatController.text = currentGoals.dailyFat.toString();
          _waterController.text = currentGoals.dailyWater.toString();
        }

        return AlertDialog(
          title: const Text('Edit Daily Goals'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _caloriesController,
                  decoration: const InputDecoration(
                    labelText: 'Daily Calories',
                    border: OutlineInputBorder(),
                    suffixText: 'kcal',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _proteinController,
                  decoration: const InputDecoration(
                    labelText: 'Daily Protein',
                    border: OutlineInputBorder(),
                    suffixText: 'g',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _carbsController,
                  decoration: const InputDecoration(
                    labelText: 'Daily Carbs',
                    border: OutlineInputBorder(),
                    suffixText: 'g',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fatController,
                  decoration: const InputDecoration(
                    labelText: 'Daily Fat',
                    border: OutlineInputBorder(),
                    suffixText: 'g',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _waterController,
                  decoration: const InputDecoration(
                    labelText: 'Daily Water',
                    border: OutlineInputBorder(),
                    suffixText: 'L',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newGoals = UserNutritionGoals(
                  dailyCalories: int.tryParse(_caloriesController.text) ?? 2000,
                  dailyProtein: double.tryParse(_proteinController.text) ?? 150,
                  dailyCarbs: double.tryParse(_carbsController.text) ?? 250,
                  dailyFat: double.tryParse(_fatController.text) ?? 65,
                  dailyWater: double.tryParse(_waterController.text) ?? 2.5,
                  goal: nutritionProvider.goals.goal,
                );
                widget.onGoalsUpdated(newGoals);
                Navigator.pop(context);
              },
              child: const Text('Save Goals'),
            ),
          ],
        );
      },
    );
  }
}

class GoalTypeDialog extends StatefulWidget {
  final Function(String goalType) onGoalTypeUpdated;

  const GoalTypeDialog({
    super.key,
    required this.onGoalTypeUpdated,
  });

  @override
  State<GoalTypeDialog> createState() => _GoalTypeDialogState();
}

class _GoalTypeDialogState extends State<GoalTypeDialog> {
  String _selectedGoalType = 'maintenance';
  final List<Map<String, dynamic>> _goalTypes = [
    {
      'value': 'weight_loss',
      'label': 'Weight Loss',
      'description': 'Reduce calorie intake to lose weight',
      'icon': Icons.trending_down,
      'color': Colors.red,
    },
    {
      'value': 'maintenance',
      'label': 'Weight Maintenance',
      'description': 'Maintain current weight',
      'icon': Icons.trending_flat,
      'color': Colors.green,
    },
    {
      'value': 'weight_gain',
      'label': 'Weight Gain',
      'description': 'Increase calorie intake to gain weight',
      'icon': Icons.trending_up,
      'color': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedGoalType = 'maintenance'; // Default value
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NutritionProvider>(
      builder: (context, nutritionProvider, child) {
        // Update selected goal type with current value if it's still default
        if (_selectedGoalType == 'maintenance') {
          _selectedGoalType = nutritionProvider.goals.goal;
        }

        return AlertDialog(
          title: const Text('Select Goal Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _goalTypes.map((goalType) {
              final isSelected = _selectedGoalType == goalType['value'];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: isSelected ? goalType['color'].withOpacity(0.1) : null,
                child: ListTile(
                  leading: Icon(
                    goalType['icon'],
                    color: goalType['color'],
                  ),
                  title: Text(
                    goalType['label'],
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(goalType['description']),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: goalType['color'])
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedGoalType = goalType['value'];
                    });
                  },
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onGoalTypeUpdated(_selectedGoalType);
                Navigator.pop(context);
              },
              child: const Text('Save Goal Type'),
            ),
          ],
        );
      },
    );
  }
}

class FoodSearchTab extends StatefulWidget {
  final NutritionProvider nutritionProvider;

  const FoodSearchTab({
    super.key,
    required this.nutritionProvider,
  });

  @override
  State<FoodSearchTab> createState() => _FoodSearchTabState();
}

class _FoodSearchTabState extends State<FoodSearchTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<FoodItem> _filteredFoods = [];

  @override
  void initState() {
    super.initState();
    _filteredFoods = widget.nutritionProvider.foodItems;
  }

  void _filterFoods() {
    setState(() {
      final searchQuery = _searchController.text.toLowerCase();
      final foods = widget.nutritionProvider.foodItems;
      
      _filteredFoods = foods.where((food) {
        final matchesSearch = searchQuery.isEmpty || 
            food.name.toLowerCase().contains(searchQuery) ||
            food.description.toLowerCase().contains(searchQuery);
        
        final matchesCategory = _selectedCategory == 'All' || 
            food.category.toLowerCase() == _selectedCategory.toLowerCase();
        
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Search bar
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search food items...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (_) => _filterFoods(),
        ),
        const SizedBox(height: 16),
        
        // Food categories
        _buildFoodCategories(),
        const SizedBox(height: 16),
        
        // Food items
        Text(
          _selectedCategory == 'All' ? 'All Foods' : _selectedCategory,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Food items list
        if (_filteredFoods.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No foods found',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          )
        else
          ..._filteredFoods.map((food) => _buildFoodItemCard(food)).toList(),
      ],
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
          final isSelected = _selectedCategory == category;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
                _filterFoods();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodItemCard(FoodItem food) {
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
            Navigator.of(context).pop(); // Close the tab view
            // Show add food dialog with pre-selected food
            showDialog(
              context: context,
              builder: (context) => AddFoodDialog(
                selectedFoodId: food.id,
                onFoodAdded: (foodId, quantity, mealType) {
                  widget.nutritionProvider.addFoodToLog(foodId, quantity, mealType);
                },
              ),
            );
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class ManualCalorieDialog extends StatefulWidget {
  final Function(int calories, String mealType, String description) onCalorieAdded;

  const ManualCalorieDialog({
    super.key,
    required this.onCalorieAdded,
  });

  @override
  State<ManualCalorieDialog> createState() => _ManualCalorieDialogState();
}

class _ManualCalorieDialogState extends State<ManualCalorieDialog> {
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedMealType = 'Breakfast';
  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  final List<Map<String, dynamic>> _quickCalories = [
    {'name': 'Apple', 'calories': 95},
    {'name': 'Banana', 'calories': 105},
    {'name': 'Coffee', 'calories': 5},
    {'name': 'Tea', 'calories': 2},
    {'name': 'Cookie', 'calories': 150},
    {'name': 'Candy', 'calories': 200},
    {'name': 'Soda', 'calories': 140},
    {'name': 'Beer', 'calories': 150},
  ];

  @override
  void dispose() {
    _caloriesController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quick Add Calories'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick calorie buttons
            Text(
              'Quick Add:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickCalories.map((item) {
                return GestureDetector(
                  onTap: () {
                    _caloriesController.text = item['calories'].toString();
                    _descriptionController.text = item['name'];
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      '${item['name']} (${item['calories']} cal)',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Manual input
            TextFormField(
              controller: _caloriesController,
              decoration: const InputDecoration(
                labelText: 'Calories',
                border: OutlineInputBorder(),
                suffixText: 'kcal',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                hintText: 'e.g., Homemade sandwich',
              ),
            ),
            const SizedBox(height: 16),
            
            // Meal type selection
            DropdownButtonFormField<String>(
              value: _selectedMealType,
              decoration: const InputDecoration(
                labelText: 'Meal Type',
                border: OutlineInputBorder(),
              ),
              items: _mealTypes.map((mealType) {
                return DropdownMenuItem(
                  value: mealType,
                  child: Text(mealType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMealType = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final calories = int.tryParse(_caloriesController.text) ?? 0;
            final description = _descriptionController.text.trim();
            
            if (calories > 0 && description.isNotEmpty) {
              widget.onCalorieAdded(calories, _selectedMealType, description);
              Navigator.pop(context);
            }
          },
          child: const Text('Add Calories'),
        ),
      ],
    );
  }
}
