import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

// lib/presentation/add_medicine/widgets/meal_instruction_widget.dart

class MealInstructionWidget extends StatefulWidget {
  final String selectedInstruction;
  final Function(String) onInstructionChanged;

  const MealInstructionWidget({
    super.key,
    required this.selectedInstruction,
    required this.onInstructionChanged,
  });

  @override
  State<MealInstructionWidget> createState() => _MealInstructionWidgetState();
}

class _MealInstructionWidgetState extends State<MealInstructionWidget> {
  final List<Map<String, dynamic>> _mealInstructions = [
    {
      'id': 'Before meals',
      'name': 'Before Meals',
      'description': 'Take 30 minutes before eating',
      'icon': 'restaurant',
      'color': Colors.orange,
    },
    {
      'id': 'After meals',
      'name': 'After Meals',
      'description': 'Take 30 minutes after eating',
      'icon': 'restaurant_menu',
      'color': Colors.green,
    },
    {
      'id': 'With meals',
      'name': 'With Meals',
      'description': 'Take during or with food',
      'icon': 'local_dining',
      'color': Colors.blue,
    },
    {
      'id': 'Empty stomach',
      'name': 'Empty Stomach',
      'description': 'Take on empty stomach',
      'icon': 'no_meals',
      'color': Colors.purple,
    },
  ];

  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meal Instructions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: _mealInstructions.length,
          itemBuilder: (context, index) {
            final instruction = _mealInstructions[index];
            final isSelected = widget.selectedInstruction == instruction['id'];

            return GestureDetector(
              onTap: () => widget.onInstructionChanged(instruction['id']),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha(51),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : instruction['color'].withAlpha(26),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: instruction['icon'],
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : instruction['color'],
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      instruction['name'],
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        instruction['description'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 8),
        Text(
          'Select when to take the medication in relation to meals',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
