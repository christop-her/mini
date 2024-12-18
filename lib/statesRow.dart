import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini/home.dart';
import 'package:mini/login.dart';
import 'package:mini/reusablestatesRow.dart';

class stateRow extends StatefulWidget {
  const stateRow({super.key});

  @override
  State<stateRow> createState() => _stateRowState();
}

class _stateRowState extends State<stateRow> {
//   String engText = '';
//   String eduText = '';
    

//   Future Allstates () async{
//   var url = "http://192.168.247.26/practice/alldata.php";
//   var response = await http.get(Uri.parse(url));
//   var jsonResponse = json.decode(response.body);
//   var userData = jsonResponse;
//   // print(userData[0]['edu']);
//   setState(() {
//     engText = userData[0]['eng'];
//     eduText = userData[0]['edu'];
//   });
 
// } 
  @override
  // void initState(){
  //   super.initState();
  //   Allstates();
  // }
  
  Widget build(BuildContext context) {
    return SafeArea(child: SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
           StatesRow(Colors.red, 'Delta', Icons.star_rate, context, login()),
           SizedBox(width: 10,),
           StatesRow(Colors.red, 'Edo', Icons.star_rate, context, login()),
           SizedBox(width: 10,),
           StatesRow(Colors.red, 'Lagos', Icons.star_rate, context, login()),
           SizedBox(width: 10,),
           StatesRow(Colors.red, 'Abuja', Icons.star_rate, context, login()),
           SizedBox(width: 10,),
           StatesRow(Colors.red, 'Nassarawa', Icons.star_rate, context, login()),
           SizedBox(width: 10,),
           StatesRow(Colors.red, 'Abia', Icons.star_rate, context, login()),
           SizedBox(width: 10,),
           StatesRow(Colors.red, 'Adamawa', Icons.star_rate, context, login()),
            SizedBox(width: 10,),
           StatesRow(Colors.red, 'Yola', Icons.star_rate, context, login()),
            SizedBox(width: 10,),
           StatesRow(Colors.red, 'Akwa ibom', Icons.star_rate, context, login()),
            SizedBox(width: 10,),
           StatesRow(Colors.red, 'Anambra', Icons.star_rate, context, login()),
            SizedBox(width: 10,),
           StatesRow(Colors.red, 'Orka', Icons.star_rate, context, login()),
            SizedBox(width: 10,),
           StatesRow(Colors.red, 'Bauchi', Icons.star_rate, context, login()),
             
              ],
            ),
          )
        ],
      ),
    ));
  }
}