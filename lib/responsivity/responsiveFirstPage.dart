import 'package:flutter/material.dart';

class responsiveFirstPage extends StatelessWidget {
   final Widget mobileFirstPage;
   final Widget desktopFirstPage;

  const responsiveFirstPage({super.key, required this.mobileFirstPage, required this.desktopFirstPage});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      if(constraints.maxWidth < 700){
             return mobileFirstPage;
      }else{
               return desktopFirstPage;
      }
    });
  }
}