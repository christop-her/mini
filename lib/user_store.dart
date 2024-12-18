import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini/register_store.dart';
import 'package:mini/responsivity/desktopFirstPage.dart';
import 'package:mini/responsivity/mobileFirstPage.dart';
import 'package:mini/responsivity/responsiveFirstPage.dart';
import 'package:mini/ipconfig.dart';


class userStore extends StatefulWidget {
  const userStore({super.key});

  @override
  State<userStore> createState() => _userStoreState();
}

class _userStoreState extends State<userStore> {

  List<dynamic> userLocations = [];
  String email = '';
  String Name = '';
  String storeType = '';
  String caption = '';
  String contact = '';
  String description = '';
  String mainImage = '';
  File? _image;
  final picker = ImagePicker();
     Future<void> userDetails() async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email') ?? '';
  });
  
     var url = "http://$ipconfig/practice/store_data.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'email': email
    },
    );
   if(response.statusCode == 200){
    var jsonResponse = json.decode(response.body);
    if(jsonResponse['message'] == 'login successful'){
    var userData = jsonResponse['data'][0];
    setState(() {
      Name = userData['name'];
    }); 

    print('addressName: $Name');
    }
    }
  }

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

  @override
   void initState(){
    super.initState();
    userDetails();
    
  }
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Your store', style: TextStyle(fontWeight: FontWeight.w300),)),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 40, right: 40,),
          color: Color(0xFFF8F4F4),
          width: 1000,
          child: SingleChildScrollView(
            
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(onPressed: (){}, child: Text('Closed')),
                ],
              ),
          
              SizedBox(height: 10,),
          
               Container(
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
               border: Border.all(
                
                width: 1,
                color: Colors.green
               )
               ),
               width: 500,
               height: 150,
               child: Image(image: AssetImage('images/sperf.JPG'),
               fit: BoxFit.cover,),
                         ),

          SizedBox(height: 20,),

                Text('Description of your store thats appealing for users to read and also patronize you, thats appealing for users to read and also patronize you,thats appealing for users to read and also patronize you', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),

                SizedBox(height: 20,),
          
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_city, color: Colors.black26,),
                        SizedBox(width: 5,),
                        Text('your address'),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Row(
                      children: [
                        Icon(Icons.contact_phone, color: Colors.black12,),
                         SizedBox(width: 5,),
                        Text('08076923882'),

                        SizedBox(width: 20,),
                         GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => registerStore()));
                          },
                 child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color:  Color(0xFF2F8332),
                    borderRadius: BorderRadius.circular(10)
                  ),
                   child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(color: Color(0xFFE4BE86,),
                        borderRadius: BorderRadius.circular(50)
                        ),
                        
                        child: Icon(Icons.person, color: Colors.white,)),

                        SizedBox(width: 5,),
                      Text('Update Profile', style: TextStyle(color: Colors.white),),
                    ],
                                   ),
                 ),
               ),

                      ],
                    )
                  ],
                ) ,
SizedBox(height: 20,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Container(
                      
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                 color:Color(0xFFE4B56F),
                                 borderRadius: BorderRadius.circular(50),
                                ),
                        // child: Image(image: AssetImage('images/sperf.JPG'),
                        child: Icon(Icons.person, size: 80,color: Colors.white,),
                        //  fit: BoxFit.cover
                        //  ),
                                
                               ),
                               SizedBox(width: 20,),

                               Padding(
                                 padding: const EdgeInsets.only(bottom: 20),
                                 child: Text(Name),
                               )
                   ],
                 ),  

                 SizedBox(height: 20,),

                 Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                      decoration: BoxDecoration(color: Colors.grey,
                       borderRadius: BorderRadius.circular(10)),
                      
                      child: Icon(Icons.thumb_up_off_alt_sharp,)),
SizedBox(width: 20,),
               GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)
                  ),
                   child: Row(
                    children: [
                      Icon(Icons.comment, color: Colors.black,),
                      Text('comments', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
                    ],
                                   ),
                 ),
               ),

               SizedBox(width: 20,),

               GestureDetector(
                 child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color:  Colors.grey,
                    borderRadius: BorderRadius.circular(10)
                  ),
                   child: Row(
                    children: [
                      Icon(Icons.messenger_rounded, color: Colors.black,),
                      Text('Messages', style: TextStyle(color: Colors.black),),
                    ],
                                   ),
                 ),
               ),


                  ],
                 )  ,
SizedBox(height: 25,),
                 Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 30, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 162, 228, 164)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.design_services),
                      SizedBox(width: 10,),
                      Text('upload service', style: TextStyle(fontWeight: FontWeight.w700),),
                    ],
                  ),
                 ),
                 
                 SizedBox(height: 20,),

                  Row(
   children: [
     Column(
       children: [
         _image != null
                        ? Container(
                          width: 100,
                         height: 100,
                          decoration: BoxDecoration(
                          ),
                          child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              
                            ),
                        )
                        :Container(
                          width: 250,
                         height: 200,
                          decoration: BoxDecoration(
                             color: Colors.black45,
                          ),
               child: Icon(Icons.car_rental, size: 100,),
                        ),
                        SizedBox(height: 10,),
 Row(
 mainAxisAlignment: MainAxisAlignment.start,
   children: [
     ElevatedButton(
                  onPressed: _getImageFromGallery,
                  child: Text('Select Image'),
                ),
SizedBox(width: 20,),
                 ElevatedButton(
                  onPressed: _getImageFromGallery,
                  child: Text('Post'),
                ),
   ],
 ),
       ],
     ),

SizedBox(width: 10,),
                   
                       Expanded(
                         child: Column(
                           children: [
                             Container(
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 15,left: 10, right: 10),
                                    height: 50,
                                    color: Colors.grey,
                                    child: Text('Price', style: TextStyle(fontSize: 15),)),
                             
                                  Expanded(
                                    child: Container(
                                      width: 400,
                                                 decoration: BoxDecoration(
                                                  border: Border.all(
                                                   color: Colors.black,
                                                   width: 0.2
                                                  ),
                                                 ),
                                                 child: TextField(
                                                  
                                                   decoration: InputDecoration(
                                                     contentPadding: EdgeInsets.only(left: 10),
                                                     hintText: '# Amount', hintStyle: TextStyle(fontSize: 15),
                                                     border: InputBorder.none
                                                   ),
                                                   
                                                 ),
                                               ),
                                  ),
                                ],
                              ),
                             ),
                         
                             SizedBox(height: 20,),
                         
                             Container(
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 15,left: 10, right: 10),
                                    height: 50,
                                    color: Colors.grey,
                                    child: Text('Name', style: TextStyle(fontSize: 15),)),
                             
                                  Expanded(
                                    child: Container(
                                      width: 400,
                                                 decoration: BoxDecoration(
                                                  border: Border.all(
                                                   color: Colors.black,
                                                   width: 0.2
                                                  ),
                                                 ),
                                                 child: TextField(
                                                  
                                                   decoration: InputDecoration(
                                                     contentPadding: EdgeInsets.only(left: 10),
                                                     hintText: 'Name of service/description', hintStyle: TextStyle(fontSize: 15),
                                                     border: InputBorder.none
                                                   ),
                                                   
                                                 ),
                                               ),
                                  ),
                                ],
                              ),
                             ),
                         
                           ],
                         ),
                       ),
                       ],
 ),  


 SizedBox(height: 25,),
                 Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 30, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 162, 228, 164)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.design_services),
                      SizedBox(width: 10,),
                      Text('Uploaded Service', style: TextStyle(fontWeight: FontWeight.w700),),
                    ],
                  ),
                 ),
                 
                 SizedBox(height: 20,),

 
            ],

            
            
          ),
              ),
        ),
      ),
    );

  
  }
}