import 'package:flutter/material.dart';
import 'package:block_blast_flutter/constants/shapes.dart';
import 'package:block_blast_flutter/theme/app_theme.dart';
import 'package:block_blast_flutter/widgets/modern_block.dart';

class ShapePicker extends StatelessWidget {
  const ShapePicker({
    super.key,
    required this.selectedShape,
    required this.onShapeSelected,
    this.cellSize = 20,
  });

  final String? selectedShape;
  final ValueChanged<String> onShapeSelected;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: shapeKeys.map((key) {
        final isSelected = selectedShape == key;
        final cells = kShapes[key]!;
        final maxR = cells.fold<int>(0, (m, c) => c[0] > m ? c[0] : m);
        final maxC = cells.fold<int>(0, (m, c) => c[1] > m ? c[1] : m);
        final size = (cellSize * (maxC + 1) + 4).clamp(40.0, 80.0);
        final blockSize = size / (maxC + 1);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onShapeSelected(key),
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                    : Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: size,
                    height: blockSize * (maxR + 1),
                    child: Stack(
                      children: [
                        for (final cell in cells)
                          Positioned(
                            left: cell[1] * blockSize,
                            top: cell[0] * blockSize,
                            child: ModernBlock(
                              cellSize: blockSize * 0.92,
                              color: AppTheme.blockColorForId(1, context),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    key,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
