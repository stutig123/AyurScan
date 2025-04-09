import 'dart:io';
import 'package:flutter/material.dart';
import 'history_storage.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prediction History")),
      body: FutureBuilder<List<PredictionHistoryItem>>(
        future: HistoryStorage.loadHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final history = snapshot.data!;
          if (history.isEmpty) return Center(child: Text("No history yet"));
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.file(File(item.imagePath), width: 60, fit: BoxFit.cover),
                  title: Text(item.plantName),
                  subtitle: Text("Confidence: ${item.confidence.toStringAsFixed(2)}%\nTime: ${item.timestamp}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
