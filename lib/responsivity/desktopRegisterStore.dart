// import 'dart:convert';
// import 'dart:io';
// import 'package:geocoding/geocoding.dart';
// import 'package:location/location.dart' as loc;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mini/login.dart';
// import 'package:mini/responsivity/desktopUserStore.dart';
// import 'package:mini/responsivity/mobileUserStore.dart';
// import 'package:mini/responsivity/responsiveUserStore.dart';

// class desktopRegisterStore extends StatefulWidget {
//   const desktopRegisterStore({super.key});

//   @override
//   State<desktopRegisterStore> createState() => _desktopRegisterStoreState();
// }

// class _desktopRegisterStoreState extends State<desktopRegisterStore> {
//      File? _image;
//   final picker = ImagePicker();
//   TextEditingController storeType = TextEditingController();
//   TextEditingController name = TextEditingController();
//   TextEditingController storeName = TextEditingController();
//   TextEditingController description = TextEditingController();
//   TextEditingController contact = TextEditingController();
//   TextEditingController caption = TextEditingController();
//   String email = '';

//   bool isLoading = false;
//   String address = 'Address: Not available';

//   Future<void> getAddress() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       loc.LocationData locationData = await loc.Location.instance.getLocation();
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           locationData.latitude!, locationData.longitude!);
//       Placemark placemark = placemarks.first;
//       String formattedAddress = '${placemark.subLocality}';
//       setState(() {
//         address =  formattedAddress;
//       });
//     } catch (e) {
//       print('Error getting address: $e');
//       setState(() {
//         address = 'Address: Not available';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> getPermission() async {
//     var permissionStatus = await Permission.location.request();
//     if (permissionStatus.isGranted) {
//       getAddress();
//     } else {
//       print('Location permission not granted');
//       // Handle case where permission is not granted
//     }
//   }


//  Future getEmail() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   setState(() {
//     email = preferences.getString('email') ?? '';
//   });

// }



//   Future<void> _getImageFromGallery() async {
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedImage != null) {
//         _image = File(pickedImage.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//      Future<void> RegisterUserStore() async {
//   if (_image == null) {
//     // Handle the case where _image is null
//     return;
//   }

//   final uri = Uri.parse("http://192.168.208.26/practice/registeredStore.php");
//   var request = http.MultipartRequest('POST', uri);
//   request.fields['name'] = name.text;
//   request.fields['storeName'] = storeName.text;
//   request.fields['storeType'] = storeType.text;
//   request.fields['description'] = description.text;
//   request.fields['caption'] = caption.text;
//   request.fields['contact'] = contact.text;
//   request.fields['email'] = email;
//   request.fields['address'] = address;


//   var pic = await http.MultipartFile.fromPath("image_01", _image!.path); // Use ! to assert that _image is not null
//   request.files.add(pic);
//   var response = await request.send();
  
//  if (response.statusCode == 200) {
    
//     var responseData = await response.stream.bytesToString();
//     var jsonResponse = json.decode(responseData);
    
//     if (jsonResponse["success"] == "store registered") {
//        successPopup(context);

//        Navigator.push(context, MaterialPageRoute(builder: (context) => responsiveUserStore(mobileUserStore: mobileUserStore(), desktopUserStore: desktopUserStore())));
//     } else if (jsonResponse["success"] == "account already exist") {
        
//         showPopup(context);

//     } else {
//         print('Unexpected response');
//     }
// } else {
//     print('Not registered successfully');
// }
// }


// void showPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
        
//         // Future.delayed(Duration(seconds: 1), () {
//         //   Navigator.of(context).pop();
//         // });

        
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//           insetPadding: EdgeInsets.only(bottom: 650),
//             child: Container(
//               color: Colors.black,
//               width: MediaQuery.of(context).size.width,
//               height: 120,
//               child: Column(
                
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 0),
//                     child: Text('Store Already Registered', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
//                   ),
             
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(elevation: 0),
//                         onPressed: (){Navigator.of(context).pop();}, child: Text('Close',)),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//         );
//       },
//     );
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
//               // color:Color(0xFF248560),
//               color: Colors.black,
//               width: MediaQuery.of(context).size.width,
//               height: 80,
//               child: Column(
                
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 25),
//                     child: Text('Registered successfully', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
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
//     getEmail();
    
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       appBar: AppBar(
//         title: Text('Register'),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//         padding: EdgeInsets.only(left: 60, right: 60, top: 30),
//         child: Container(
//           padding: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.white,
//           ),
          
//           child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    Padding(
//                      padding: const EdgeInsets.only(bottom: 20),
//                      child: Row(
//                        children: [
//                         Icon(Icons.account_box, color: Colors.green,),
//                         SizedBox(width: 10,),
//                          Text('Register Store', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
//                        ],
//                      ),
//                    ),
      
//                     Column(
//                      children: [
                     
//                      ElevatedButton(
//                     onPressed: () {
//                       login();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       elevation: 0,
//                     ),
//                     child: Text('change email?'),
//                   ),
      
//                     Row(
//                          children: [
//                           Icon(Icons.email),
//                            Text(email),
//                          ],
//                        ),
                   
      
//                      ],
//                    ),
//                  ],
//                ),
//                SizedBox(height: 20,),
//                isLoading ? CircularProgressIndicator() : Text(address),
//                   ElevatedButton(
//                     onPressed: () {
//                       getPermission();
//                     },
//                     child: Text('Get Address'),
//                   ),
//               SizedBox(height: 10,),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.only(top: 15,left: 10, right: 10),
//                                       height: 50,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),
//                                         color: Color(0xFFC9C9C9),
//                                       ),
                                     
//                                       child: Text('NAME OF STORE', style: TextStyle(fontSize: 15),)),
                               
//                                     Expanded(
//                                       child: Container(
//                                         width: 380,
//                                                    decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                      color: Colors.black,
//                                                      width: 0.2
//                                                     ),
//                                                    ),
//                                                    child: TextField(
//                                                     controller: storeName,
//                                                      decoration: InputDecoration(
//                                                        contentPadding: EdgeInsets.only(left: 10),
//                                                        hintText: 'e.g Ghost cuts', hintStyle: TextStyle(fontSize: 15),
//                                                        border: InputBorder.none
//                                                      ),
                                                     
//                                                    ),
//                                                  ),
//                                     ),
//                                   ],
//                                 ),
//                                ),
//                           SizedBox(height: 20,),
//                           Container(
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.only(top: 15,left: 10, right: 10),
//                                       height: 50,
//                                        decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),
//                                          color: Color(0xFFC9C9C9),
//                                       ),
//                                       child: Text('DESCRIPTION', style: TextStyle(fontSize: 15),)),
                               
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
//                                                     controller: description,
//                                                      decoration: InputDecoration(
//                                                        contentPadding: EdgeInsets.only(left: 10),
//                                                        hintText: 'whats your service', hintStyle: TextStyle(fontSize: 15),
//                                                        border: InputBorder.none
//                                                      ),
                                                     
//                                                    ),
//                                                  ),
//                                     ),
//                                   ],
//                                 ),
//                                ),
//                       ],
//                     ),
//                   ),
//           SizedBox(width: 15,),
//                    Expanded(
                    
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                        Container(
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.only(top: 15,left: 10, right: 10),
//                                       height: 50,
//                                        decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),
//                                         color: Color(0xFFC9C9C9),
//                                       ),
//                                       child: Text('TYPE OF STORE', style: TextStyle(fontSize: 15),)),
                               
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
//                                                     controller: storeType,
//                                                      decoration: InputDecoration(
//                                                        contentPadding: EdgeInsets.only(left: 10),
//                                                        hintText: 'e.g Provision Store', hintStyle: TextStyle(fontSize: 15),
//                                                        border: InputBorder.none
//                                                      ),
                                                     
//                                                    ),
//                                                  ),
//                                     ),
//                                   ],
//                                 ),
//                                ),
//                           SizedBox(height: 20,),
//                            Container(
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.only(top: 15,left: 10, right: 10),
//                                       height: 50,
//                                        decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),
//                                          color: Color(0xFFC9C9C9),
//                                       ),
//                                       child: Text('CONTACT', style: TextStyle(fontSize: 15),)),
                               
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
//                                                     controller: contact,
//                                                      decoration: InputDecoration(
//                                                        contentPadding: EdgeInsets.only(left: 10),
//                                                        hintText: 'e.g 08076923882', hintStyle: TextStyle(fontSize: 15),
//                                                        border: InputBorder.none
//                                                      ),
                                                     
//                                                    ),
//                                                  ),
//                                     ),
//                                   ],
//                                 ),
//                                ),
          
                          
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//           SizedBox(height: 20,),
          
//                      Container(
                    
//                       width: 780,
//                        child: Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: [
//                                  Container(
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         padding: EdgeInsets.only(top: 15,left: 10, right: 10),
//                                         height: 50,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),
//                                             color: Color(0xFFC9C9C9),
//                                           ),
//                                         child: Text('NAME', style: TextStyle(fontSize: 15),)),
                                 
//                                       Expanded(
//                                         child: Container(
//                                           width: 400,
//                                                      decoration: BoxDecoration(
//                                                       border: Border.all(
//                                                        color: Colors.black,
//                                                        width: 0.2
//                                                       ),
//                                                      ),
//                                                      child: TextField(
//                                                       controller: name,
//                                                        decoration: InputDecoration(
//                                                          contentPadding: EdgeInsets.only(left: 10),
//                                                          hintText: 'Enter Your Name', hintStyle: TextStyle(fontSize: 15),
//                                                          border: InputBorder.none
//                                                        ),
                                                       
//                                                      ),
//                                                    ),
//                                       ),
//                                     ],
//                                   ),
//                                  ),
                              
//                                  SizedBox(height: 22,),
                              
//                                  Container(
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         padding: EdgeInsets.only(top: 15,left: 10, right: 10),
//                                         height: 50,
//                                          decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),
//                                             color: Color(0xFFC9C9C9),
//                                           ),
//                                         child: Text('CAPTION', style: TextStyle(fontSize: 15),)),
                                 
//                                       Expanded(
//                                         child: Container(
//                                           width: 400,
//                                                      decoration: BoxDecoration(
//                                                       border: Border.all(
//                                                        color: Colors.black,
//                                                        width: 0.2
//                                                       ),
//                                                      ),
//                                                      child: TextField(
//                                                       controller: caption,
//                                                        decoration: InputDecoration(
//                                                          contentPadding: EdgeInsets.only(left: 10),
//                                                          hintText: 'Introduce Yourself', hintStyle: TextStyle(fontSize: 15),
//                                                          border: InputBorder.none
//                                                        ),
                                                       
//                                                      ),
//                                                    ),
//                                       ),
//                                     ],
//                                   ),
//                                  ),
                              
//                                ],
//                              ),
//                             ),
//                             SizedBox(width: 40,),
//                             Column(
//                               children: [
//                                 _image != null
//                             ? Container(
//                               width: 100,
//                              height: 100,
//                               decoration: BoxDecoration(
                               
//                               ),
//                               child: Image.file(
//                                   _image!,
//                                   fit: BoxFit.cover,
                                  
//                                 ),
//                             )
//                             :Container(
//                               width: 150,
//                              height: 150,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(100),
//                                color:Color.fromARGB(255, 219, 163, 78),
//                               ),
//                                       child: Icon(Icons.person, size: 100, color: Colors.white,),
//                             ),
//                             SizedBox(height: 10,),
//                         Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             ElevatedButton(
//                                          onPressed: _getImageFromGallery,
//                                          child: Text('Select Image'),
//                                        ),
//                           ],
//                         ),
//                               ],
//                             ),
                          
//                            ],
//                         ),
//                      ),  
      
//              SizedBox(height: 10,),
          
//              Container(
//               width: MediaQuery.of(context).size.width,
//                padding: EdgeInsets.all(15),
                    
//               decoration: BoxDecoration(
//                       color:Color(0xFFA2E4A4),
//                       borderRadius: BorderRadius.circular(10)
//                     ),
//                child: Expanded(
//                  child: Row(
//                    children: [
//                    Icon(Icons.shop, color: Colors.white,),
//                      Expanded(
//                        child: Container(
//                          padding: EdgeInsets.only(left: 15),
//                         child: Text('AFTER THIS REGISTRATION YOU CAN PROCEED TO ADD PRODUCTS IMAGES, CHECK YOUR STORE FOR THIS', 
//                         style: TextStyle(fontSize: 16, color: Colors.black),),),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
          
      
                
//             ],
          
//           ),
//         ),
//       )),
//     );
//   }
// }