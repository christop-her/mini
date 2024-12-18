import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini/login.dart';
import 'package:mini/responsivity/mobileUpdateSPic.dart';
import 'package:mini/responsivity/profilelist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String ipconfig = '192.168.193.26';
  String email = '';
  String username = '';
  String profilepic = '';
  var userData;
  List<String> lastMessage = [];
  List<String> mLastId = [];

  TextEditingController messageController = TextEditingController();

  // function to get the details of signed in user
  Future<void> userDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email') ?? '';
    });
    var url = "https://healthtok.onrender.com/patientData.php";
    var response = await http.post(
      Uri.parse(url),
      body: {'email': email},
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (!mounted) {
        return;
      }
      if (jsonResponse['message'] == 'login successful') {
        setState(() {
          userData = jsonResponse['data'][0];
          username = userData['username'];
          profilepic = userData['image_01'] ?? 'text';
        });
      }
    }
  }

  @override
  void initState() {
    userDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010043),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Stack(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      
                      child: ClipOval(
                        child: Image.network(
                          "https://healthtok.onrender.com/profile_img/$profilepic",
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 70,
                              color: Colors.white,
                            );
                          },
                        ),
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UpdateSpic()));
                      },
                      child: Container(
                        height: 40, // Larger camera icon
                        width: 40, // Larger camera icon
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Colors.white),
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20, // Adjust the size as needed
                          color: Color(0xFF010043),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hello,${username ?? 'User'}, ",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 550,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  profile_list(
                    image: "lib/icons/heart2.png",
                    title: "My Saved",
                    color: Colors.black87,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Divider(),
                  ),
                   profile_list(
                    image: "lib/icons/appoint.png",
                    title: "Appointmnet",
                    color: Colors.black87,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Divider(),
                  ),
                   profile_list(
                    image: "lib/icons/appoint.png",
                    title: "FAQs",
                    color: Colors.black87,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Divider(),
                  ),
                   profile_list(
                    image: "lib/icons/pay.png",
                    title: "Payment Method",
                    color: Colors.black87,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Divider(),
                  ),
                  GestureDetector(
                    onTap: () {
                      //  Navigator.of(context).pop(); // Close the dialog
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  login()));
                    },
                    child:  profile_list(
                      image: "lib/icons/logout.png",
                      title: "Log out",
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
