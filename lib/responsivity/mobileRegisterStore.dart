import 'dart:convert';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:mini/ipconfig.dart';
import 'package:mini/responsivity/selectStore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini/login.dart';
import 'package:mini/responsivity/desktopUserStore.dart';
import 'package:mini/responsivity/mobileUserStore.dart';
import 'package:mini/responsivity/responsiveUserStore.dart';

class mobileRegisterStore extends StatefulWidget {
  const mobileRegisterStore({super.key});

  @override
  State<mobileRegisterStore> createState() => _mobileRegisterStoreState();
}

class _mobileRegisterStoreState extends State<mobileRegisterStore> {
   File? _image;
  final picker = ImagePicker();
  TextEditingController storeType = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController storeName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController caption = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _labelText = 'Click to get location';
  String email = '';
  bool _isFormValid = false;

  bool isLoading = false;
  bool onLoading = false;
  String address = 'Address: Not available';
  double lattitude = 0.0;
  double longitude = 0.0;



void _checkFormValid() {
    setState(() {
      _isFormValid = storeName.text.isNotEmpty &&
          name.text.isNotEmpty &&
          storeName.text.isNotEmpty &&
          description.text.isNotEmpty &&
          contact.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          caption.text.isNotEmpty &&
          storeType.text.isNotEmpty;
    });
  }

   Future<void> _getAddress() async {
    // Request location permission
    var permissionStatus = await Permission.location.request();
    if (permissionStatus.isDenied) {
      print('object');
        permissionStatus = await Permission.location.request();
    }
    if (permissionStatus.isPermanentlyDenied) {
    // Open app settings for manual permission
    openAppSettings();
    print('Location permission is permanently denied. Open settings.');
    return;
  }
    if (permissionStatus.isGranted) {
      try {
        loc.LocationData locationData = await loc.Location.instance.getLocation();
        List<Placemark> placemarks = await placemarkFromCoordinates(
          locationData.latitude!,
          locationData.longitude!,
        );
        Placemark placemark = placemarks.first;
        String formattedAddress = '${placemark.locality}';
        
        setState(() {
          address = formattedAddress;
          lattitude = locationData.latitude!;
          longitude = locationData.longitude!;
           
        _addressController.text = 'Location: $address';
        _labelText = ''; 
    
        });
      } catch (e) {
        print('Error getting location: $e');
      }
    } else {
      print('Location permission not granted');
      print('Permission status: $permissionStatus');
    }
  }


 Future getEmail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email') ?? '';
  });

}


     Future<void> RegisterUserStore() async {
      setState(() {
        onLoading = true;
      });
  

  final uri = Uri.parse("http://$ipconfig/apisocial/registeredStore.php");
  var request = http.MultipartRequest('POST', uri);
  request.fields['name'] = name.text;
  request.fields['storeName'] = storeName.text;
  request.fields['storeType'] = storeType.text;
  request.fields['description'] = description.text;
  request.fields['caption'] = caption.text;
  request.fields['contact'] = contact.text;
  request.fields['email'] = email;
  request.fields['address'] = address;
  request.fields['lattitude'] = lattitude.toString();
  request.fields['longitude'] = longitude.toString();


  // var pic = await http.MultipartFile.fromPath("image_01", _image!.path); // Use ! to assert that _image is not null
  // request.files.add(pic);
  var response = await request.send();
  
 if (response.statusCode == 200) {
    
    var responseData = await response.stream.bytesToString();
    var jsonResponse = json.decode(responseData);
    
    if (jsonResponse["success"] == "store registered") {
      setState(() {
        onLoading = false;
      });
      _showSuccessDialog(context,'Success','Your account has been \n successfully registerd');
       
    } else if (jsonResponse["success"] == "email is  already registered") {
        
        _unSuccessDialog(context,'email is  already registered','Registration Unsuccessful');

    } else {
      print(jsonResponse);
        _unSuccessDialog(context,'unexpected response','Registration Unsuccessful');
    }
} else {
    _unSuccessDialog(context,'not successful','Registration Unsuccessful');
}
}


void _showSuccessDialog(BuildContext context,String text,String body) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), 
          ),
          content: SizedBox(
            height: 290.0,
            width: 200.0, 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.check,
                      color: Color(0xFF010043),
                      size: 50.0, // Adjust the size if needed
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Registration $text',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                const SizedBox(height: 5.0),

                Text(
                  body,
                  style: TextStyle(
                    fontSize: 18.0,
                      color: Colors.grey.shade300,
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF010043), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Selectstore()));
                  },
                  child: const Text('Go to Store',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _unSuccessDialog(BuildContext context,String text,String body) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), 
          ),
          content: SizedBox(
            height: 290.0,
            width: 200.0, 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.check,
                      color: Color(0xFF010043),
                      size: 50.0, 
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Registration $text',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                const SizedBox(height: 5.0),

                Text(
                  body,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey.shade300,
                  ),
                ),


              ],
            ),
          ),
        );
      },
    );
  }




  @override
   void initState(){
    super.initState();
    getEmail();
    
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register'),),
      body: SafeArea(
        child: SingleChildScrollView(
        padding: EdgeInsets.only( top: 10),
        child: Container(
          padding: EdgeInsets.only(left: 10,right: 10,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Row(
                    children: [
                     Icon(Icons.email, size: 12,),
                      Text(email, style: TextStyle(fontSize: 12),),
                    ],
                  ),
               SizedBox(height: 40,),
               

                  TextFormField(
                      readOnly: true,
      controller: _addressController,
      decoration: InputDecoration(
        labelText: _labelText.isEmpty ? 'Address' : _labelText, 
        border: OutlineInputBorder(),
      ),
      onTap: () async {
       
          await _getAddress();
        
      },
    ),
              SizedBox(height: 10,),
      
               Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: storeName,
                           onChanged: (val) => _checkFormValid(),
                          validator: (val) => val!.isEmpty ? "Name cannot be blank" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.email, color: Color(0xFF010043)),
                            ),
                            labelText: 'Name of Store ',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),
                          SizedBox(height: 20,),
                           Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: description,
                           onChanged: (val) => _checkFormValid(),
                          validator: (val) => val!.isEmpty ? "Name cannot be blank" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.email, color: Color(0xFF010043)),
                            ),
                            labelText: 'Description e.g whats your service',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),
      
                               SizedBox(height: 20,),
      
                                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: storeType,
                           onChanged: (val) => _checkFormValid(),
                          validator: (val) => val!.isEmpty ? "Name cannot be blank" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.email, color: Color(0xFF010043)),
                            ),
                            labelText: 'Type of Store e.g provision store',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),
                          SizedBox(height: 20,),
                          Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: contact,
                           onChanged: (val) => _checkFormValid(),
                          validator: (val) => val!.isEmpty ? "Name cannot be blank" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.email, color: Color(0xFF010043)),
                            ),
                            labelText: 'Phone',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),
                               SizedBox(height: 20,),
      
                                Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: name,
                           onChanged: (val) => _checkFormValid(),
                          validator: (val) => val!.isEmpty ? "Name cannot be blank" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.email, color: Color(0xFF010043)),
                            ),
                            labelText: 'Your Name',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),
                          SizedBox(height: 20,),
                           Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: caption,
                           onChanged: (val) => _checkFormValid(),
                          validator: (val) => val!.isEmpty ? "Name cannot be blank" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.email, color: Color(0xFF010043)),
                            ),
                            labelText: 'Caption e.g introduce yourself',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),
                   SizedBox(height: 20,),
 
      
      Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                           child: GestureDetector(
                            onTap: (){_isFormValid ?
                                 RegisterUserStore() : null;
                            },
                                       child: Container(
                                        padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                                        decoration: BoxDecoration(
                                                     color:  Color(0xFF248560),
                                                     
                                                     borderRadius: BorderRadius.circular(10)
                                        ),
                                         child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [  
                                                      onLoading ? CircularProgressIndicator() : Text('Register Store', style: TextStyle(color: Colors.white),),
                                                     ],
                                     ),
                                       ),
                                     ),
                         ) ,

      
                                       SizedBox(height: 20,),
                             Container(
              width: MediaQuery.of(context).size.width,
               padding: EdgeInsets.all(15),
                    
              decoration: BoxDecoration(
                      color:Color(0xFFA2E4A4),
                      borderRadius: BorderRadius.circular(10)
                    ),
               child: Row(
                 children: [
                 Icon(Icons.shop, color: Colors.white,),
                   Expanded(
                     child: Container(
                       padding: EdgeInsets.only(left: 15),
                      child: Text('AFTER THIS REGISTRATION YOU CAN PROCEED TO ADD PRODUCTS IMAGES, CHECK YOUR STORE FOR THIS', 
                      style: TextStyle(fontSize: 16, color: Colors.black),),),
                   ),
                 ],
               ),
             ),
          
            ],
          )
        ),
      )),
    );
  }
}