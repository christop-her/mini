import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini/ipconfig.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String email = '';
  var userData;
  String userName = '';

   Future<void> userMenu() async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email') ?? '';
  });
  
     var url = "http://$ipconfig/practice/userData.php";

    var response = await http.post(Uri.parse(url),
    body: {
        'email': email
    },
    );
   if(response.statusCode == 200){
    var jsonResponse = json.decode(response.body);
    if(jsonResponse['success'] == 'login successful'){
   
    setState(() {
       userData = jsonResponse['data'][0];
       userName = userData['name'];
      
    }); 

    }
   }
   }
    
  @override
  void initState(){
    super.initState();
    userMenu();
    
  }
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              print('object');
            },
            child: UserAccountsDrawerHeader(
                accountName: Text(userName), 
                accountEmail: Text(email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('images/sperf.JPG'),
                  ),
            
                  decoration: BoxDecoration(
                    color: Colors.green[900]
                  ),
            ),
          ),
              
          GestureDetector(
            child: ListTile(
              title: Row(
                children: [
                  Icon(Icons.headphones),
                  SizedBox(width: 10,),
                  Text('Favourite Stores'),
                ],
              ),
              onTap: () {
                // Add your action here
                Navigator.pop(context);
              },
            ),
          ),
          GestureDetector(
            child: ListTile(
              title: Row(
                children: [
                  Icon(Icons.list),
                  SizedBox(width: 10,),
                  Text('toBuy List'),
                ],
              ),
              onTap: () {
                // Add your action here
                Navigator.pop(context);
              },
            ),
          ),

           GestureDetector(
            child: ListTile(
              title: Row(
                children: [
                  Icon(Icons.help, color: Colors.red,),
                  SizedBox(width: 10,),
                  Text('Help'),
                ],
              ),
              onTap: () {
                // Add your action here
                Navigator.pop(context);
              },
            ),
          ),
            GestureDetector(
            child: ListTile(
              title: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 10,),
                  Text('Settings/Privacy'),
                ],
              ),
              onTap: () {
                // Add your action here
                Navigator.pop(context);
              },
            ),
          ),
          // Add more ListTile widgets for additional items
        ],
      ),
    );
  }
}
