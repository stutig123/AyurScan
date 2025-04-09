import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PredictionHistoryItem {
  final String imagePath;
  final String plantName;
  final double confidence;
  final String timestamp;

  PredictionHistoryItem({
    required this.imagePath,
    required this.plantName,
    required this.confidence,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'plantName': plantName,
        'confidence': confidence,
        'timestamp': timestamp,
      };

  factory PredictionHistoryItem.fromJson(Map<String, dynamic> json) {
    return PredictionHistoryItem(
      imagePath: json['imagePath'],
      plantName: json['plantName'],
      confidence: json['confidence'],
      timestamp: json['timestamp'],
    );
  }
}

class HistoryStorage {
  static Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/history.json');
  }

  static Future<void> savePrediction(PredictionHistoryItem item) async {
    final file = await _getLocalFile();
    List<PredictionHistoryItem> history = await loadHistory();
    history.insert(0, item); // Add newest at top
    final jsonData = history.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonData));
  }

  static Future<List<PredictionHistoryItem>> loadHistory() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData
          .map((e) => PredictionHistoryItem.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
