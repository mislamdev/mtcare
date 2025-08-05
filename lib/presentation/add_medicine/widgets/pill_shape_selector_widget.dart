import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

// lib/presentation/add_medicine/widgets/pill_shape_selector_widget.dart

class PillShapeSelectorWidget extends StatefulWidget {
  final String selectedShape;
  final Function(String) onShapeChanged;

  const PillShapeSelectorWidget({
    super.key,
    required this.selectedShape,
    required this.onShapeChanged,
  });

  @override
  State<PillShapeSelectorWidget> createState() =>
      _PillShapeSelectorWidgetState();
}

class _PillShapeSelectorWidgetState extends State<PillShapeSelectorWidget> {
  final List<Map<String, dynamic>> _pillShapes = [
    {
      'id': 'round',
      'name': 'Round',
      'icon': 'circle',
      'description': 'Circular tablets',
    },
    {
      'id': 'oval',
      'name': 'Oval',
      'icon': 'oval',
      'description': 'Oval-shaped pills',
    },
    {
      'id': 'capsule',
      'name': 'Capsule',
      'icon': 'capsule',
      'description': 'Capsule medications',
    },
    {
      'id': 'square',
      'name': 'Square',
      'icon': 'square',
      'description': 'Square tablets',
    },
    {
      'id': 'triangle',
      'name': 'Triangle',
      'icon': 'triangle',
      'description': 'Triangular pills',
    },
    {
      'id': 'diamond',
      'name': 'Diamond',
      'icon': 'diamond',
      'description': 'Diamond-shaped',
    },
  ];

  Widget _buildShapeItem(Map<String, dynamic> shape) {
    final isSelected = widget.selectedShape == shape['id'];

    return GestureDetector(
      onTap: () => widget.onShapeChanged(shape['id']),
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
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: shape['icon'],
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              shape['name'],
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              shape['description'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pill Shape',
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
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: _pillShapes.length,
          itemBuilder: (context, index) {
            return _buildShapeItem(_pillShapes[index]);
          },
        ),
        SizedBox(height: 8),
        Text(
          'Select the shape that best matches your medication',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
