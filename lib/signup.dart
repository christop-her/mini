import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini/dropDown.dart';
import 'package:mini/ipconfig.dart';

import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:mini/responsivity/login1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class signUp extends StatefulWidget {

  
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {

  bool obscuretext = true;
  bool isRememberMeChecked = false;
  bool _isChecked = false;
  bool _isFormValid = false;
  bool isPasswordMatchError = false;

  final TextEditingController _addressController = TextEditingController();
  String _labelText = 'Click to get location';

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController= TextEditingController();
  TextEditingController cpasswordController= TextEditingController();
  File? _image;
  final picker = ImagePicker();

  
   bool isLoading = false;
  String address = 'Not available';
  double latitude = 0.0;
  double longitude = 0.0;


  void Popup(BuildContext context) {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });

        
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          insetPadding: EdgeInsets.only(bottom: 650),
            child: Container(
              // color:Color(0xFF248560),
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Column(
                
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Text('Registered successfully', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                  )
                ],
              ),
            ),
        );
      },
    );
  }

void successPopup(BuildContext context) {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });

        
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          insetPadding: EdgeInsets.only(bottom: 650),
            child: Container(
              // color:Color(0xFF248560),
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Column(
                
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Text('account already exist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                  )
                ],
              ),
            ),
        );
      },
    );
  }


  Future<void> _getAddress() async {
    // Request location permission
    var permissionStatus = await Permission.location.request();
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
          latitude = locationData.latitude!;
          longitude = locationData.longitude!;
           
        _addressController.text = 'Location: $address';
        _labelText = ''; 
    
        });
      } catch (e) {
        print('Error getting location: $e');
      }
    } else {
      print('Location permission not granted');
    }
  }


  Future<void> signUp() async {
    _showLoadingDialog(context);
 final url = Uri.parse("http://$ipconfig/apisocial/signup.php");

  var request = http.MultipartRequest('POST', url);
  request.fields['address_locality'] = address;
  request.fields['name'] = nameController.text;
  request.fields['email'] = emailController.text;
  request.fields['password'] = passwordController.text;
  request.fields['cpassword'] = cpasswordController.text;
  request.fields['lattitude'] = latitude.toString();
   request.fields['longitude'] = longitude.toString();

  print("Request prepared: ${request.fields}");

  if (_image != null) {
    var pic = await http.MultipartFile.fromPath("image_01", _image!.path);
    request.files.add(pic);
  }

      // Send sign-up request with the new address
      // var response = await http.post(
      //   Uri.parse(url),
      //   body: {
      //     'address_locality': address,
      //     'name': nameController.text,
      //     'email': emailController.text,
      //     'password': passwordController.text,
      //     'cpassword': cpasswordController.text,
      //     'lattitude': latitude.toString(),
      //     'longitude': longitude.toString()
      //   },
      // );
      
      var response = await request.send();
Navigator.pop(context);
      if (response.statusCode == 200) {
       
        var responseData = await response.stream.bytesToString();
        print('account already exist $responseData');
        var jsonResponse = json.decode(responseData);
        if (jsonResponse['success'] == 'account already exist') {
          print('account already exist');
        } else {
           _showSuccessDialog(context,'Success','Your account has been \n successfully registerd');
          
        }
      } else {
        print('request failed with status: ${response.statusCode}');
         _unSuccessDialog(context,'Unsuccessful','try to login');
      }
    
  
}

 Future<void> _getImageFromGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  


void _checkFormValid() {
    setState(() {
      _isFormValid = emailController.text.isNotEmpty &&
          nameController.text.isNotEmpty &&
          passwordController.text.length >= 8 &&
          passwordController.text == cpasswordController.text &&
          _isChecked;
    });
  }

  _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, 
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), 
          ),
          content: const SizedBox(
            height: 44.0, 
            width: 44.0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF010043)),
              ),
            ),
          ),
        );
      },
    );
  } 

 void _showSuccessDialog(BuildContext context,String text,String body) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set background color to white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Optional: make it a square
          ),
          content: SizedBox(
            height: 290.0, // Adjust the height
            width: 200.0, // Adjust the width to make it a square
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
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) =>  mobilefirstPage_2()));
                  },
                  child: const Text('Login now',
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
          backgroundColor: Colors.white, // Set background color to white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Optional: make it a square
          ),
          content: SizedBox(
            height: 290.0, // Adjust the height
            width: 200.0, // Adjust the width to make it a square
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
              ],
            ),
          ),
        );
      },
    );
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010043),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: Text(
                "Signup",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            Container(
              height: MediaQuery.of(context).size.height * 1.1,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text('please stay in business location to sign up so we can get your correct address.'),
                    SizedBox(height: 20,),

                    TextFormField(
                      readOnly: true,
      controller: _addressController,
      decoration: InputDecoration(
        labelText: _labelText.isEmpty ? 'Address' : _labelText, // Use labelText for floating effect
        border: OutlineInputBorder(),
      ),
      onTap: () async {
       
          await _getAddress();
        
      },
    ),
                    SizedBox(height: 20,),
                    // Email TextField
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: emailController,
                          onChanged: (val) => _checkFormValid(),
                                          validator: (val) => RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val!)
                                          ? null
                                          : "Please enter a valid email",
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.email, color: Color(0xFF010043)),
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: nameController,
                           onChanged: (val) => _checkFormValid(),
                          validator: (val) => val!.isEmpty ? "Name cannot be blank" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.email, color: Color(0xFF010043)),
                            ),
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password TextField
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          controller: passwordController,
                           obscureText: obscuretext,
                          onChanged: (val) => _checkFormValid(),
                                      validator: (val) => val!.length < 8 ? "Password too short" : null,
                                      
                                     
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.lock, color: Color(0xFF010043)),
                            ),
                         
                            labelText: 'Password',
                             suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obscuretext = !obscuretext;
                                          });
                                        },
                                        icon: Icon(
                                          obscuretext ? Icons.remove_red_eye : Icons.visibility_off,
                                          size: 20,
                                        ),
                                      ),
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),
                   
                    const SizedBox(height: 20),
                    // Password TextField
                    Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: TextFormField(
          controller: cpasswordController,
          obscureText: obscuretext,
          onChanged: (val) {
            setState(() {
              // Update the flag based on password match status
              isPasswordMatchError = val != passwordController.text;
            });
            _checkFormValid();
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Icon(Icons.lock, color: Color(0xFF010043)),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscuretext ? Icons.visibility_off : Icons.visibility,
                size: 20,
              ),
              onPressed: () => setState(() => obscuretext = !obscuretext),
            ),
            labelText: 'Confirm Password',
            labelStyle: TextStyle(color: Colors.grey[700]),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    ),
    // Error message shown below the TextFormField
    Visibility(
      visible: isPasswordMatchError,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 8),
        child: Text(
          "Passwords do not match",
          style: TextStyle(
            color: Colors.red,
            fontSize: 12.0,
          ),
        ),
      ),
    ),
  ],
)
,
                    const SizedBox(height: 20,),

                    Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value!;
                      _checkFormValid();
                    });
                  },
                  activeColor: const Color(0xFF010043),
                ),
                Text(
                  "I agree to the terms and conditions",
                  // style: GoogleFonts.poppins(
                  //   fontSize: MediaQuery.sizeOf(context).width / 27,
                  //   color: Colors.black87,
                  // ),
                ),
              ],
            ),
                    const SizedBox(height: 30),
                    // Login Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _isFormValid ? signUp() : null;
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 100),
                          backgroundColor: Color(0xFF002366),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('already have an account?'),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => mobilefirstPage_2()));
                          },
                          child: Text('Login', style: TextStyle(color: Colors.red),)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}