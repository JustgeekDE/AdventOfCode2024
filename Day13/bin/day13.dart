import 'package:day13/machine.dart' as machine;
import 'dart:io';

void main(List<String> arguments) async {
 final filePath = "example.txt";

  try {
    final input = await File(filePath).readAsString();
    final entries = machine.parseInput(input);

    int totalCost = 0;
    for (final entry in entries) {
      print(entry);
      var cost = entry.bestCost2();
      if (cost != null) {
        totalCost += cost;
      }
      print("Total cost is $totalCost");

    }
  } catch (e) {
    print('Error reading file: $e');
  }
}