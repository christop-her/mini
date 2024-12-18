// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mini/responsivity/desktopRegisterStore.dart';
// import 'package:mini/responsivity/mobileRegisterStore.dart';
// import 'package:mini/responsivity/responsiveRegisterStore.dart';


// class desktopUserStore extends StatefulWidget {
//   const desktopUserStore({super.key});

//   @override
//   State<desktopUserStore> createState() => _desktopUserStoreState();
// }

// class _desktopUserStoreState extends State<desktopUserStore> {
//  TextEditingController price = TextEditingController();
//   TextEditingController name = TextEditingController();

//   List<dynamic> userUploads = [];
//   var userData;
//   String userEmail = '';
//   String email = '';
//   String storeName = '';
//   String address = '';
//   String storeType = '';
//   String caption = '';
//   String contact = '';
//   String description = '';
//   String mainImage = '';
//   File? _image;
//   final picker = ImagePicker();

//      Future<void> userDetails() async{
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//   setState(() {
//     email = preferences.getString('email') ?? '';
//   });
  
//      var url = "http://192.168.208.26/practice/store_data.php";
//       var myUrl = "http://192.168.208.26/practice/output_user_service.php";
//       var followUrl = "http://192.168.208.26/practice/store_data.php";
//     var response = await http.post(Uri.parse(url),
//     body: {
//         'email': email
//     },
//     );
//    if(response.statusCode == 200){
//     var jsonResponse = json.decode(response.body);
//     if(jsonResponse['message'] == 'login successful'){
   
//     setState(() {
//        userData = jsonResponse['data'][0];
//       storeName = userData['storeName'];
//       address = userData['address'];
//       storeType = userData['storeType'];
//       mainImage = userData['image_01'];
//     }); 

//     // print('addressName: $Name');

//    var output = await http.post(Uri.parse(myUrl),
//     body: {
//         'email': email
//     }
//     );

//     var jsonOutput = json.decode(output.body);
//     setState(() {
//        userUploads = jsonOutput;
//     });
//     print(userData);
//     print(email);
//     // print('addressName: $addressName');
  
//     }
//     }
//   }

//    Future<void> _getImageFromGallery() async {
    
//   final pickedImage = await picker.pickVideo(source: ImageSource.gallery);

//     setState(() {
//       if (pickedImage != null) {
//         _image = File(pickedImage.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }


//   Future<void> postService() async {
//   if (_image == null) {
//     // Handle the case where _image is null
//     return;
//   }

//   final uri = Uri.parse("http://192.168.208.26/practice/upload_service.php");
//   var request = http.MultipartRequest('POST', uri);
//   request.fields['price'] = price.text;
//   request.fields['name'] = name.text;
//   request.fields['email'] = email;


//   var pic = await http.MultipartFile.fromPath("image_01", _image!.path); // Use ! to assert that _image is not null
//   request.files.add(pic);
//   var response = await request.send();

//   if (response.statusCode == 200) {
//     print('image uploaded');
//     userDetails();
//     successPopup(context);

//      setState(() {
//       price.clear();
//       name.clear();
//     });

//     // Clear image
//     setState(() {
//       _image = null;
//     });

//   } else {
//     showPopup(context);
//     // print('image not uploaded');
//   }
// }




// int calculateCrossAxisCount(BuildContext context) {
//     // Calculate the appropriate cross axis count based on screen width
//     double screenWidth = MediaQuery.of(context).size.width;
//     int crossAxisCount = (screenWidth / 120).round(); // Adjust 150 as per your item size
//     return crossAxisCount;
//   }


//   void successPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
        
//         Future.delayed(Duration(seconds: 1), () {
//           Navigator.of(context).pop();
//         });

        
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//           insetPadding: EdgeInsets.only(bottom: 650),
//             child: Container(
//               color: Colors.black,
//               width: MediaQuery.of(context).size.width,
//               height: 80,
//               child: Column(
                
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 28),
//                     child: Text('Photo added successfully', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
//                   )
//                 ],
//               ),
//             ),
//         );
//       },
//     );
//   }

//   void showPopup(BuildContext context) {
    
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
        
//         Future.delayed(Duration(seconds: 1), () {
//           Navigator.of(context).pop();
//         });

        
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//           insetPadding: EdgeInsets.only(bottom: 650),
//             child: Container(
//               // color:Color(0xFF248560),
//               color: Colors.black,
//               width: MediaQuery.of(context).size.width,
//               height: 80,
//               child: Column(
                
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 25),
//                     child: Text('Photo Not Added, Try Again ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
//                   )
//                 ],
//               ),
//             ),
//         );
//       },
//     );
//   }



//   @override
//    void initState(){
//     super.initState();
//     userDetails();
    
//   }
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(title: Text('Your store', style: TextStyle(fontWeight: FontWeight.w300),)),
//       body: 
      
//        userData == null 
      
      
//       ? Center(
//         child: Container(
//           padding: EdgeInsets.all(20),
//           height: 400,
//           width: 400,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10)
//           ),
//           child: Column(
//             children: [
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(50)
//                 ),
//                 child: Icon(Icons.shopify_sharp, size: 60,)),
//               SizedBox(height: 5,),
//               Text('You have not registered your store yet'),
//               SizedBox(height: 5,),
//               Container(
//                             padding: EdgeInsets.only(left: 10, right: 10),
//                              child: GestureDetector(
//                               onTap: (){
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) => responsiveRegisterStore(mobileRegisterStore: mobileRegisterStore(), desktopRegisterStore: desktopRegisterStore())));
//                               },
//                                          child: Container(
//                                           padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
//                                           decoration: BoxDecoration(
//                                                        color:  Color(0xFF248560),
                                                       
//                                                        borderRadius: BorderRadius.circular(10)
//                                           ),
//                                            child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                                        children: [
//                                                          Container(
//                                                            width: 30,
//                                                            height: 30,
//                                                            decoration: BoxDecoration(color: const Color.fromARGB(83, 245, 245, 245),
//                                                            borderRadius: BorderRadius.circular(50)
//                                                            ),
                                                           
//                                                            child: Icon(Icons.store_sharp, color: Colors.white,)),
                                                       
//                                                            SizedBox(width: 5,),
//                                                          Text('Register Store', style: TextStyle(color: Colors.white),),
//                                                        ],
//                                        ),
//                                          ),
//                                        ),
//                            ) ,
//             ],
//           ),
//         ),
//       )
      
//       :Center(
//         child: Container(
//           // padding: EdgeInsets.only(left: 40, right: 40,),
//           // color: Color(0xFFF8F4F4),
//           width: 1600,
//           child: SingleChildScrollView(
            
//           child: Column(
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//              Container(
//                 color: Colors.white,
//                 padding: EdgeInsets.only(left: 10,right: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(onPressed: (){}, child: Text('Closed')),
                
//                     Column(
//                       children: [
//                         Icon(Icons.store, color: Colors.green,),
//                         Text(storeType, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
          
//               SizedBox(height: 10,),
          
//                Column(
//                  children: [
//                    Container(
//                     height: 250,
//                      child: Stack(
//                        children: [
//                          Container(
//                          decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                          ),
//                          width: 500,
//                          height: 200,
//                          child: Image.network(
//                           "http://192.168.208.26/practice/uploaded_img/${mainImage}",
//                           fit: BoxFit.cover,)
                         
//                                    ),
                     
                                  
                     
//                                     Positioned(
//                                       left: 20,
//                                       top: 90,
//                                       child: _image != null
//                                                               ? Container(
//                                                                 width: 100,
//                                                                height: 100,
//                                                                 decoration: BoxDecoration(
//                                                                 ),
//                                                                 child: Image.file(
//                                       _image!,
//                                       fit: BoxFit.cover,
                                      
//                                                                   ),
//                                                               )
                                                              
//                                                               :Container(
//                                                                 width: 150,
//                                                                height: 150,
//                                                                 decoration: BoxDecoration(
//                                                                    color: Colors.black12,
//                                                                    border: Border.all(
//                                                                     color: Colors.white,
//                                                                     width: 5
//                                                                    ),
//                                                                    borderRadius: BorderRadius.circular(100)
//                                                                 ),
//                                                      child: Icon(Icons.person_add_alt_rounded, size: 100, color: Colors.white,),
//                                                               ),
//                                     ),
//                        ],
                     
                     
//                      ),
                   
//                    ),

//                    Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                      children: [
//                        Container(
//                         padding: EdgeInsets.only(left: 40, right: 40),
//                         child: Text(storeName, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),),
//                      ],
//                    ),

//                     Padding(
//                       padding: const EdgeInsets.only(left: 40,right: 40),
//                       child: Row(
//                                         children: [
//                       Row(
//                         children: [
//                           Icon(Icons.location_city, color: Colors.red[400],),
//                           SizedBox(width: 5,),
//                           Text(address),
//                         ],
//                       ),
//                       SizedBox(width: 20,),
//                       Row(
//                         children: [
//                           Icon(Icons.contact_phone, color: Colors.blue[400],),
//                            SizedBox(width: 5,),
//                           Text('08076923882'),
                      
//                           SizedBox(width: 20,),
//                            GestureDetector(
//                             onTap: (){
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => responsiveRegisterStore(mobileRegisterStore: mobileRegisterStore(), desktopRegisterStore: desktopRegisterStore())));
                            
//                             },
//                                        child: Container(
//                                         padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
//                                         decoration: BoxDecoration(
//                       color:  Color(0xFF2F8332),
//                       borderRadius: BorderRadius.circular(10)
//                                         ),
//                                          child: Row(
//                       children: [
//                         Container(
//                           width: 30,
//                           height: 30,
//                           decoration: BoxDecoration(color: Color(0xFFE4BE86,),
//                           borderRadius: BorderRadius.circular(50)
//                           ),
                          
//                           child: Icon(Icons.person, color: Colors.white,)),
                      
//                           SizedBox(width: 5,),
//                         Text('Update Profile', style: TextStyle(color: Colors.white),),
//                       ],
//                                      ),
//                                        ),
//                                      ),
                      
//                         ],
//                       )
//                                         ],
//                                       ),
//                     ) ,
//                  ],
//                ),

//           SizedBox(height: 20,),

//                 Padding(
//                   padding: const EdgeInsets.only(left: 40, right: 40),
//                   child: Text('Description of your store thats appealing for users to read and also patronize you, thats appealing for users to read and also patronize you,thats appealing for users to read and also patronize you', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
//                 ),

          
               
// SizedBox(height: 20,),
                
//                  Padding(
//                    padding: const EdgeInsets.only(left: 40, right: 40),
//                    child: Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
//                         decoration: BoxDecoration(color: Color(0xFFC9C9C9),
//                          borderRadius: BorderRadius.circular(10)),
                        
//                         child: Icon(Icons.thumb_up_off_alt_sharp,)),
//                    SizedBox(width: 20,),
//                                   GestureDetector(
//                                    child: Container(
//                     padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
//                     decoration: BoxDecoration(
//                       color: Color(0xFFC9C9C9),
//                       borderRadius: BorderRadius.circular(10)
//                     ),
//                      child: Row(
//                       children: [
//                         Icon(Icons.comment, color: Colors.black,),
//                         SizedBox(width: 8,),
//                         Text('comments', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
//                       ],
//                                      ),
//                    ),
//                                   ),
                   
//                                   SizedBox(width: 20,),
                   
//                                   GestureDetector(
//                    child: Container(
//                     padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
//                     decoration: BoxDecoration(
//                       color:  Color(0xFFC9C9C9),
//                       borderRadius: BorderRadius.circular(10)
//                     ),
//                      child: Row(
//                       children: [
//                         Icon(Icons.messenger_rounded, color: Colors.black87,),
//                         SizedBox(width: 8,),
//                         Text('Messages', style: TextStyle(color: Colors.black),),
//                       ],
//                                      ),
//                    ),
//                                   ),
                   
                   
//                     ],
//                    ),
//                  )  ,
// SizedBox(height: 25,),
//                  Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
//                   decoration: BoxDecoration(
//                     // borderRadius: BorderRadius.circular(10),
//                     color: Colors.grey
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.design_services),
//                       SizedBox(width: 10,),
//                       Text('upload service', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
//                     ],
//                   ),
//                  ),
                 
//                  SizedBox(height: 20,),

//                   Container(
//                     padding: EdgeInsets.only(left: 40, right: 40),
//                     child: Row(
//                        children: [
//                          Column(
//                            children: [
//                              _image != null
//                           ? Container(
//                             width: 100,
//                            height: 100,
//                             decoration: BoxDecoration(
//                             ),
//                             child: Image.file(
//                                 _image!,
//                                 fit: BoxFit.cover,
                                
//                               ),
//                           )
//                           :Container(
//                             width: 250,
//                            height: 200,
//                             decoration: BoxDecoration(
//                                color: Colors.black12,
//                             ),
//                                    child: Icon(Icons.car_rental, size: 100,),
//                           ),
//                           SizedBox(height: 10,),
//                      Row(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                        children: [
//                          ElevatedButton(
//                     onPressed: _getImageFromGallery,
//                     child: Text('Select Image'),
//                                     ),
//                     SizedBox(width: 20,),


//                                      Container(
//              padding: EdgeInsets.only(left: 10, right: 10),
//              child: GestureDetector(
//               onTap: (){postService();},
//               child: Container(
//                 padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
//                 // width: 30,
//                 // height: 30,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF248560),
//                   borderRadius: BorderRadius.circular(10)
//                 ),
//                 child: Text('Upload', style: TextStyle(color: Colors.white),),
//               ),

//              ),
//            )
//                        ],
//                      ),
//                            ],
//                          ),
                    
//                     SizedBox(width: 10,),
                     
//                          Expanded(
//                            child: Column(
//                              children: [
//                                Container(
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.only(top: 15,left: 10, right: 10),
//                                       height: 50,
//                                      decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),
//                                          color: Color(0xFFC9C9C9),
//                                       ),
//                                       child: Text('Price', style: TextStyle(fontSize: 15),)),
                               
//                                     Expanded(
//                                       child: Container(
//                                         width: 400,
//                                                    decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                      color: Colors.black,
//                                                      width: 0.2
//                                                     ),
//                                                    ),
//                                                    child: TextField(
                                                    
//                                                      decoration: InputDecoration(
//                                                        contentPadding: EdgeInsets.only(left: 10),
//                                                        hintText: '# Amount', hintStyle: TextStyle(fontSize: 15),
//                                                        border: InputBorder.none
//                                                      ),
                                                     
//                                                    ),
//                                                  ),
//                                     ),
//                                   ],
//                                 ),
//                                ),
                           
//                                SizedBox(height: 20,),
                           
//                                Container(
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.only(top: 15,left: 10, right: 10),
//                                       height: 50,
//                                         decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),
//                                          color: Color(0xFFC9C9C9),
//                                       ),
//                                       child: Text('Name', style: TextStyle(fontSize: 15),)),
                               
//                                     Expanded(
//                                       child: Container(
//                                         width: 400,
//                                                    decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                      color: Colors.black,
//                                                      width: 0.2
//                                                     ),
//                                                    ),
//                                                    child: TextField(
                                                    
//                                                      decoration: InputDecoration(
//                                                        contentPadding: EdgeInsets.only(left: 10),
//                                                        hintText: 'Name of service/description', hintStyle: TextStyle(fontSize: 15),
//                                                        border: InputBorder.none
//                                                      ),
                                                     
//                                                    ),
//                                                  ),
//                                     ),
//                                   ],
//                                 ),
//                                ),
                           
//                              ],
//                            ),
//                          ),
//                          ],
//                      ),
//                   ),  


//  SizedBox(height: 25,),
//                  Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
//                   decoration: BoxDecoration(
//                     color:Colors.grey
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.design_services),
//                       SizedBox(width: 10,),
//                       Text('Uploaded Service', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
//                     ],
//                   ),
//                  ),
                 
//                  SizedBox(height: 20,),

//   Container(width: MediaQuery.of(context).size.width,
//         height: 500,
//           child:GridView.builder(
//             physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: calculateCrossAxisCount(context), // Number of columns in the grid
//           crossAxisSpacing: 8.0, // Spacing between columns
//           mainAxisSpacing: 8.0, // Spacing between rows
//         ),
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           // var uploads = userUploads[index];
//           return Card(
//             color: Colors.red[50],
//             elevation: 3.0,
//             child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'infinix',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 4.0),
//                   Text('200000'),
//                   // Add more details if needed
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//         ),
 
//             ],

            
            
//           ),
//               ),
//         ),
//       ),
//     );

  
//   }
//   //  int calculateCrossAxisCount(BuildContext context) {
//   //   // Calculate the appropriate cross axis count based on screen width
//   //   double screenWidth = MediaQuery.of(context).size.width;
//   //   int crossAxisCount = (screenWidth / 150).round(); // Adjust 150 as per your item size
//   //   return crossAxisCount;
//   // }
// }