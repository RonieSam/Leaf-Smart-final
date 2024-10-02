import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiseaseDetector extends StatefulWidget {
  const DiseaseDetector({Key? key}) : super(key: key);

  @override
  _DiseaseDetectorState createState() => _DiseaseDetectorState();
}

class _DiseaseDetectorState extends State<DiseaseDetector> {
  XFile? _image;
  String _cropName = '';
  String _cropHybrid = '';
  String _result = '';

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final uri = Uri.parse('https://82b6-2409-40f4-a1-6c2a-34ed-c9a-477b-95b4.ngrok-free.app/detect');
    var request = http.MultipartRequest('POST', uri)
      ..fields['cropName'] = _cropName
      ..fields['cropHybrid'] = _cropHybrid
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path)); // Changed 'image' to 'file'

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonData = jsonDecode(responseString);
        setState(() {
          _result = 'Class: ${jsonData['class']}\nConfidence: ${jsonData['confidence']}';
        });
      } else {
        setState(() {
          _result = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Disease Detector')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: Text('Pick Image from Gallery'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.camera),
              child: Text('Take a Photo'),
            ),
            SizedBox(height: 20),
            if (_image != null) Image.file(File(_image!.path)),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Crop Name'),
              onChanged: (value) => _cropName = value,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Crop Hybrid'),
              onChanged: (value) => _cropHybrid = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Detect Disease'),
            ),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}