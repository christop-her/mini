import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class UploadImageDemo extends StatefulWidget {
  @override
  _UploadImageDemoState createState() => _UploadImageDemoState();
}

class _UploadImageDemoState extends State

{
  List<File> _images = []; // Updated to hold multiple images
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();

  Future<void> _getImagesFromGallery() async {
    final pickedImages = await picker.pickMultiImage(); // Updated to pick multiple images

    setState(() {
      if (pickedImages != null) {
        _images.clear(); // Clear existing images
        for (final pickedImage in pickedImages) {
          _images.add(File(pickedImage.path)); // Add new images
        }
      } else {
        print('No images selected.');
      }
    });
  }

  Future<void> uploadImages() async {
    const url = "http://192.168.93.26/practice/status.php";
    final name = nameController.text;

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = name;

    for (var i = 0; i < _images.length; i++) {
      final image = _images[i];
      request.files.add(await http.MultipartFile.fromPath('image_$i', image.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Images uploaded successfully');
    } else {
      print('Failed to upload images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Image Uploader',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            _images.isNotEmpty
                ? Column(
                    children: _images.map((image) {
                      return Image.file(
                        image,
                        height: 200,
                        width: 200,
                      );
                    }).toList(),
                  )
                : Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: 200,
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImagesFromGallery,
              child: Text('Select Images'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                uploadImages();
              },
              child: Text('Upload Images'),
            )
          ],
        ),
      ),
    );
  }
}
