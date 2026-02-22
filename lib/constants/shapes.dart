/// Shape keys and cell offsets [row, col] relative to top-left.
/// Must match backend SHAPES in gameService.js.
const Map<String, List<List<int>>> kShapes = {
  'I': [
    [0, 0],
    [0, 1],
    [0, 2],
    [0, 3],
  ],
  'O': [
    [0, 0],
    [0, 1],
    [1, 0],
    [1, 1],
  ],
  'T': [
    [0, 0],
    [0, 1],
    [0, 2],
    [1, 1],
  ],
  'S': [
    [0, 1],
    [0, 2],
    [1, 0],
    [1, 1],
  ],
  'Z': [
    [0, 0],
    [0, 1],
    [1, 1],
    [1, 2],
  ],
  'L': [
    [0, 0],
    [1, 0],
    [2, 0],
    [2, 1],
  ],
  'J': [
    [0, 1],
    [1, 1],
    [2, 0],
    [2, 1],
  ],
};

List<String> get shapeKeys => kShapes.keys.toList();
