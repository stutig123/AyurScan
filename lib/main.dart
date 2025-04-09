import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';
import 'theme.dart';
import 'history_screen.dart';
import 'history_storage.dart';
import 'plant_info.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AyurScan',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  String? _prediction;
  String? _className;
  double? _confidence;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final status = await Permission.camera.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera permission is required")),
      );
      return;
    }

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _prediction = null;
        _className = null;
        _confidence = null;
      });
      await _sendToBackend(_image!);
    }
  }

  Future<void> _sendToBackend(File image) async {
    final uri = Uri.parse('${ApiService.baseUrl}/predict');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        filename: p.basename(image.path),
        contentType: MediaType('image', 'jpeg'),
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);
      final plantName = data['class_name'];
      final confidence = data['confidence'] * 100;
      final timestamp = DateTime.now().toLocal().toString();

      final normalizedMap = plantInfo.map((key, value) => MapEntry(
        key.toLowerCase().replaceAll(' ', ''),
        value,
      ));
      final normalizedKey = plantName.toLowerCase().replaceAll(' ', '');
      final plantDetails = normalizedMap[normalizedKey];

      if (plantDetails == null) {
        setState(() {
          _className = null;
          _confidence = null;
          _prediction = '❌ This doesn’t seem to be a plant. Please try again with a clearer plant image.';
        });
        return;
      }

      setState(() {
        _className = plantName;
        _confidence = confidence;
        _prediction = null;
      });

      await HistoryStorage.savePrediction(PredictionHistoryItem(
        imagePath: image.path,
        plantName: plantName,
        confidence: confidence,
        timestamp: timestamp,
      ));
    } else {
      setState(() {
        _prediction = '❌ Failed to get prediction';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantDetails = _className != null
        ? plantInfo.entries.firstWhere(
            (entry) => entry.key.toLowerCase().replaceAll(' ', '') ==
                _className!.toLowerCase().replaceAll(' ', ''),
            orElse: () => MapEntry('', {'benefits': '', 'usage': ''}),
          ).value
        : null;

    return Scaffold(
      appBar: AppBar(title: Text("AyurScan")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image != null
                  ? Image.file(_image!, height: 250)
                  : Text("No image selected", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              if (_className != null && _confidence != null)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("🌿 Plant: $_className", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("🔍 Confidence: ${_confidence!.toStringAsFixed(2)}%", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 12),
                      if (plantDetails != null) ...[
                        Text("✨ Benefits:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(plantDetails['benefits'] ?? "", style: TextStyle(fontSize: 14)),
                        SizedBox(height: 8),
                        Text("🏠 Home Usage:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(plantDetails['usage'] ?? "", style: TextStyle(fontSize: 14)),
                      ],
                    ],
                  ),
                ),

              if (_prediction != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_prediction!, style: TextStyle(color: Colors.red)),
                ),

              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => _getImage(ImageSource.camera),
                icon: Icon(Icons.camera_alt),
                label: Text("Capture with Camera"),
              ),
              ElevatedButton.icon(
                onPressed: () => _getImage(ImageSource.gallery),
                icon: Icon(Icons.photo_library),
                label: Text("Pick from Gallery"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryScreen()),
                  );
                },
                icon: Icon(Icons.history),
                label: Text("View Prediction History"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
