import 'package:flutter/material.dart';
import 'package:mini/menu.dart';
import 'package:mini/responsivity/responsiveFirstPage.dart';
import 'package:mini/responsivity/desktopFirstPage.dart';
import 'package:mini/responsivity/desktopHeader.dart';
import 'package:mini/responsivity/mobileHeader.dart';
import 'package:mini/responsivity/mobileFirstPage.dart';
import 'package:mini/responsivity/responsive_header.dart';
import 'package:mini/reusesableAppbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
   
 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3FFF5),
      appBar: _appBar(context),
      drawer:  Menu(),
      // body:responsiveRegisterStore(mobileRegisterStore: mobileRegisterStore(), desktopRegisterStore: desktopRegisterStore()),
      // body: responsiveUserStore(mobileUserStore: mobileUserStore(), desktopUserStore: desktopUserStore()),
      body: responsiveFirstPage(mobileFirstPage: mobilefirstPage(), desktopFirstPage: desktopfirstPage())
    );
  }
}

PreferredSize _appBar(context){
  return PreferredSize(preferredSize: Size.fromHeight(115),  child: 
  Builder(
    builder: (context) {
      return Padding(
        // padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
        padding: const EdgeInsets.only(top: 35,),
      
      
        child: Container(
       padding: EdgeInsets.only(left: 20,right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(0, 3)
              )
            ]
          ),
          // child: Column(
          //  children: [
          //    FirstBar(context),
          //   const responsiveHeader(mobileHeader:mobileHeader(), desktopHeader: desktopHeader()),
          //  ],
          // ),
        ),
      );
    }
  )
        
  );
}


     

