import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mini/home.dart';


class _UploadItem extends StatefulWidget {
  const _UploadItem({super.key});

  @override
  State<_UploadItem> createState() => __UploadItemState();
}

class __UploadItemState extends State<_UploadItem> {

    File? _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();


  Future<void> _getImageFromGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }


  
    Future<void> uploadImage() async {
  if (_image == null) {
    // Handle the case where _image is null
    return;
  }

  final uri = Uri.parse("http://192.168.54.26/practice/upload.php");
  var request = http.MultipartRequest('POST', uri);
  request.fields['name'] = nameController.text;
  var pic = await http.MultipartFile.fromPath("image_01", _image!.path); // Use ! to assert that _image is not null
  request.files.add(pic);
  var response = await request.send();

  if (response.statusCode == 200) {
    print('image uploaded');
  } else {
    print('image not uploaded');
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            _image != null
                ? Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                  )
                : Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: 200,
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImageFromGallery,
              child: Text('Select Image'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'name'
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){
              uploadImage();
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
            }, child: Text('upload image'))
          ],
        ),
      ),
    );
  }
}