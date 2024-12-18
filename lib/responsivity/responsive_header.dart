import 'package:flutter/material.dart';

class responsiveHeader extends StatelessWidget {
   final Widget mobileHeader;
   final Widget desktopHeader;

  const responsiveHeader({super.key, required this.mobileHeader, required this.desktopHeader});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      if(constraints.maxWidth < 600){
             return mobileHeader;
      }else{
               return desktopHeader;
      }
    });
  }
}