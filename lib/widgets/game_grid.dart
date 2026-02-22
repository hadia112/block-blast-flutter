import 'package:flutter/material.dart';
import 'package:block_blast_flutter/theme/app_theme.dart';
import 'package:block_blast_flutter/widgets/modern_block.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({
    super.key,
    required this.grid,
    required this.cellSize,
    this.onCellTap,
  });

  final List<List<int>> grid;
  final double cellSize;
  final void Function(int row, int col)? onCellTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rows = grid.length;
        final cols = rows > 0 ? grid[0].length : 0;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(rows, (r) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(cols, (c) {
                return GestureDetector(
                  onTap: onCellTap != null ? () => onCellTap!(r, c) : null,
                  child: ModernBlock(
                    cellSize: cellSize,
                    cellId: grid[r][c],
                    showBorder: true,
                  ),
                );
              }),
            );
          }),
        );
      },
    );
  }
}
