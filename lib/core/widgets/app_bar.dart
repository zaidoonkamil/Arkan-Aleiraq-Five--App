import 'package:arkan_aleiraq_five_app/core/%20navigation/navigation.dart';
import 'package:arkan_aleiraq_five_app/core/styles/themes.dart';
import 'package:arkan_aleiraq_five_app/features/user/ditals_decument.dart';
import 'package:flutter/material.dart';

import 'constant.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
          ),
          Image.asset('assets/images/$logo',height: 40,width: 40,),
          InkWell(
            onTap: (){
              navigateTo(context, DitalsDecument());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.text_snippet_outlined,color: primaryColor,),
            ),
          )
        ],
      ),
    );
  }
}

class CustomAppBarBack extends StatelessWidget {
  const CustomAppBarBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: (){
                  navigateBack(context);
                },
                child: Icon(Icons.arrow_back_ios_new,color: Colors.black87,)),
            Image.asset('assets/images/$logo',height: 30,width: 30,),
            Container(width: 20,),
          ],
        ),
      ),
    );
  }
}
