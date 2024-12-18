import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mini/home.dart';
import 'package:mini/reusesableAppbar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mini/ipconfig.dart';




class ImageComment extends StatefulWidget {
  final String imageUrl;
  

  const ImageComment({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ImageComment> createState() => _ImageCommentState();
}

class _ImageCommentState extends State<ImageComment> {
 



  Future AllPerson () async{
  var url = "http://$ipconfig/practice/outputComments.php";
  var response = await http.get(Uri.parse(url));
  return json.decode(response.body);
}

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

  final uri = Uri.parse("http://192.168.132.26/practice/comments.php");
  var request = http.MultipartRequest('POST', uri);
  request.fields['name'] = widget.imageUrl.split('/').last.split('.').first;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Post', style: TextStyle(fontWeight: FontWeight.w600),),
      ),
      body:
      SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
  SizedBox(
        height:250,
        width:MediaQuery.of(context).size.width,
        child: Center(
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
            
          ),
          
        ),
      ),
      Text(widget.imageUrl.split('/').last.split('.').first),

      Container(
  child: Row(
  children: [
    commentIcon(),

  ],
),
      ),

 Container(
  height: 90,
  width: 90,
   child: FutureBuilder(
          future:  AllPerson(), 
          builder: (context,snapshot){
   
            if(snapshot.hasError) print(snapshot.error);
   
          return  snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: ((context, index) {
   
            List list = snapshot.data;
            // var commentsurl = Uri.parse("http://192.168.33.26/practice/comments_img/${list[index]['image_01']}");
            var urlname = list[index]['name'];
              if(urlname == widget.imageUrl.split('/').last.split('.').first){

              
            //  String imageName = widget.imageUrl;
            //         String originalName =
            //             imageName.split('/').last.split('.').first;
            return  ListTile(

              title: Container(width: 50, height: 50, child: Image.network("http://192.168.132.26/practice/comments_img/${list[index]['image_01']}"),),
              
              subtitle: Text(list[index]['name']),

              
            );
            }else{
              return Container();
            }
          })) : const Center(child: CircularProgressIndicator(),);
        }),
 ),
SingleChildScrollView(
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
                labelText: 'comment'
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){
              uploadImage();
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
            }, child: Text('send'))
          ],
        ),
      ),

          ],
        ),
      )
     
    );
  }
}
