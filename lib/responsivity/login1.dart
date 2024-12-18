import 'dart:convert';
import 'package:mini/ipconfig.dart';
import 'package:mini/responsivity/navbar.dart';
import 'package:mini/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mini/statesRow.dart';
import 'package:http/http.dart' as http;
import 'package:mini/stores.dart';

class mobilefirstPage_2 extends StatefulWidget {
  const mobilefirstPage_2({super.key});

  @override
  State<mobilefirstPage_2> createState() => _mobilefirstPage_2State();
}

class _mobilefirstPage_2State extends State<mobilefirstPage_2> {
  bool obscuretext = true;
  bool isRememberMeChecked = false;
 TextEditingController emailController = TextEditingController();
  TextEditingController passwordController= TextEditingController();

  Future<void> logIn() async{
     var url = "http://$ipconfig/apisocial/user_login.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'email': emailController.text,
        'password': passwordController.text,
    }
    );
   if(response.statusCode == 200){
    var jsonResponse = json.decode(response.body);
    if(jsonResponse['success'] == 'login successful'){
     print('login successful');

     SharedPreferences preferences = await SharedPreferences.getInstance();
     preferences.setString('email', emailController.text);
     
     Navigator.push(context, MaterialPageRoute(builder: (context) => NavBar()));
    }else{
    print('not successful');
   }
   }else{
    print('request failed with status: ${response.statusCode}');
   }
  }
  
  @override
  void initState(){
    super.initState();
   
    
  }
 Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010043),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 120),
            Center(
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email TextField
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextField(
                        controller: emailController,
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
                    const SizedBox(height: 20),
                    // Password TextField
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: obscuretext,
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
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Remember Me Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: isRememberMeChecked,
                          onChanged: (value) {
                            isRememberMeChecked = value!;
                          },
                          activeColor: const Color(0xFF010043),
                        ),
                        const Text(
                          "Remember Me",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Login Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          logIn();
                        },
                        child: const Text(
                          'Sign In',
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
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => signUp()));
                          },
                          child: Text('New user?Signup')),
                        const SizedBox(width: 5),
                        Text('Forgot password?'),
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


