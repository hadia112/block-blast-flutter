import 'package:flutter/material.dart';
import 'package:block_blast_flutter/theme/app_theme.dart';

/// Single cell in the grid or in a piece – modern rounded block with gradient.
class ModernBlock extends StatelessWidget {
  const ModernBlock({
    super.key,
    required this.cellSize,
    this.color,
    this.cellId = 0,
    this.showBorder = false,
  });

  final double cellSize;
  final Color? color;
  final int cellId;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.blockColorForId(cellId, context);
    if (cellId == 0 && color == null) {
      return SizedBox(
        width: cellSize,
        height: cellSize,
        child: showBorder
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.gridLineColor(context).withOpacity(0.5),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            : null,
      );
    }

    return Container(
      width: cellSize,
      height: cellSize,
      margin: EdgeInsets.all(cellSize * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cellSize * 0.2),
        boxShadow: [
          BoxShadow(
            color: c.withOpacity(0.4),
            blurRadius: cellSize * 0.15,
            offset: Offset(0, cellSize * 0.06),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: cellSize * 0.1,
            offset: Offset(0, cellSize * 0.04),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(c, Colors.white, 0.25)!,
            c,
            Color.lerp(c, Colors.black, 0.15)!,
          ],
        ),
      ),
    );
  }
}
