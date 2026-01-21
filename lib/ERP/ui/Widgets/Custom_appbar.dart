import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/colors_constants.dart';
import 'TextWidgets.dart';

Widget CustomAppbar(BuildContext context,{String title="",String subTitle="Project Monitoring and Entry System"}){
  return Container(
    child: Row(
      children: [
        InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              // color:ColorConstants.primary,
                border: Border.all(
                    width: 1,
                    color: Colors.grey.withOpacity(.3)
                ),
                borderRadius: BorderRadius.circular(5)
            ),
            child: Icon(Icons.arrow_back,color: Colors.grey,size: 15,),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.lalezar(
                height: 1,
                fontSize: 20,
                color: ColorConstants.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            cText(subTitle,color: Colors.black54)
          ],
        ),
      ],
    )
  );
}
