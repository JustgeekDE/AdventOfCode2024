class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() => 'X: $x, Y: $y';

  Point operator +(Point other) {
    return Point(this.x + other.x, this.y + other.y);
  }

  Point operator *(int scalar) {
    return Point(this.x * scalar, this.y * scalar);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Point) return false;
    return x == other.x && y == other.y;
  }

  @override
  int get hashCode => Object.hash(x, y);  
}

class Entry {
  Point buttonA;
  Point buttonB;
  Point prize;

  Entry(this.buttonA, this.buttonB, this.prize);

  @override
  String toString() => 'Button A: $buttonA, Button B: $buttonB, Prize: $prize';

  int? bestCost() {
    int bestCost = 4001; // Should be more than the maximum of 100*(3+1)
    for (var a = 0; a <= 100; a++) {
        for (var b = 0; b <= 100; b++) {
            final cost = a * 3 + b;
            final result = (buttonA * a) + (buttonB * b);
            if ((result == prize) && (cost < bestCost)) {
                print('Found a match with cost $cost');
                bestCost = cost;
            }
        } 
    } 
    if (bestCost < 4001) {
        return bestCost;
    }
    return null;
  }
}

List<Entry> parseInput(String input) {
  final lines = input.split('\n').where((line) => line.isNotEmpty).toList();
  final entries = <Entry>[];

  for (var i = 0; i < lines.length; i += 3) {
    final buttonALine = lines[i];
    final buttonBLine = lines[i + 1];
    final prizeLine = lines[i + 2];

    final buttonA = parsePoint(buttonALine.split(':')[1].trim());
    final buttonB = parsePoint(buttonBLine.split(':')[1].trim());
    final prize = parsePoint(prizeLine.split(':')[1].trim(), isPrize: true);

    entries.add(Entry(buttonA, buttonB, prize));
  }

  return entries;
}

Point parsePoint(String pointData, {bool isPrize = false}) {
  final regex = isPrize
      ? RegExp(r'X=(\d+), Y=(\d+)')
      : RegExp(r'X\+(\d+), Y\+(\d+)');
  final match = regex.firstMatch(pointData);

  if (match != null) {
    final x = int.parse(match.group(1)!);
    final y = int.parse(match.group(2)!);
    return Point(x, y);
  } else {
    throw FormatException('Invalid point format: $pointData');
  }
}

