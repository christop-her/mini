import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini/responsivity/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini/home.dart';
import 'package:mini/signup.dart';
import 'ipconfig.dart';

class login extends StatefulWidget {

  
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
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
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
         child: Container
               (
          width: 500,
          child: Padding(padding: EdgeInsets.only(top: 60, left: 30, right: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Center(
                    child: Text('hey, sign in', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500,color: Colors.green[800]),),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              
            
                Container(
                  decoration: BoxDecoration(
                   border: Border.all(
                    color: Colors.black,
                    width: 1
                   ),
                   borderRadius: BorderRadius.circular(50)
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon:Padding(padding: EdgeInsets.only(left: 20), child: Icon(Icons.email)),
                      label: Padding(padding: EdgeInsets.only(left: 10), child: Text('Email'),),
                      border: InputBorder.none,
                      
                    ),
                    
                  ),
                ),
            
                SizedBox(
                  height: 30,
                ),
            
                Container(
                  decoration: BoxDecoration(
                   border: Border.all(
                    color: Colors.black,
                    width: 1
                   ),
                   borderRadius: BorderRadius.circular(50) 
                  ),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon:Padding(padding: EdgeInsets.only(left: 20), child: Icon(Icons.key)),
                      label: Padding(padding: EdgeInsets.only(left: 10), child: Text('Password'),),
                      border: InputBorder.none
                    ),
                    
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
          
               Container(
                child: ElevatedButton(onPressed: (){ logIn();}, child: Text('Sign in', style: TextStyle(color: Colors.white, fontSize: 15),),
                style: ElevatedButton.styleFrom(padding: EdgeInsetsDirectional.symmetric(vertical: 17, horizontal: 90), backgroundColor: Colors.green[700]
                
                ),
                 
                )
               ),
               SizedBox(
                height: 10,
               ), 
         
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text('already have an account'),
                ),
             SizedBox(width: 10,),
                GestureDetector(
                  child: ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => signUp()));
                  }, child: Text('signup')),
                )
              ],
            )
              ],
            ),
          ),)
               
             ),
       ),
    );
    
  }
}