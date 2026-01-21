import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import '../Utils/colors_constants.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onAction;
  final BtnColorPrimary;
  final BtnColorSeconadry;

   PrimaryButton({
    Key? key,
    required this.title,
    required this.onAction,
    this.BtnColorPrimary=ColorConstants.primary,
    this.BtnColorSeconadry= ColorConstants.secondary
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color:  ColorConstants.primary
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            BtnColorPrimary,
            BtnColorSeconadry.withOpacity(.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // make transparent
          shadowColor: Colors.transparent, // remove shadow
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(30),
          // ),
        ),
        onPressed: onAction,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}


class ButtonWhite extends StatelessWidget {

  ButtonWhite({ required this.title, required this.onAction});


  String title;
  var onAction;

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height:6.h,
    //   width:100.w,
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(10)),
    //   child: ElevatedButton(
    //     style: ElevatedButton.styleFrom(backgroundColor: ColorConstants.primaryColor),
    //     onPressed:onAction,
    //     child:Text(
    //       title,
    //       style: TextStyle(color: Colors.white, fontSize: 11.sp,fontWeight:FontWeight.bold,fontFamily:"railLight"),textAlign: TextAlign.center,
    //     ),
    //   ),
    // );
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      // decoration: DecorationConstants.decorationGradient,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed:onAction,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                  style: TextStyle(color:Colors.black, fontSize: 11.sp,fontWeight:FontWeight.bold,fontFamily:"railLight"),textAlign: TextAlign.center,
              ),
              // SizedBox(
              //   width: 10,
              // ),
              // Container(
              //   height: 15,
              //   width: 15,
              //   decoration: BoxDecoration(
              //       color:Colors.white,
              //       borderRadius: BorderRadius.circular(100)
              //   ),
              //   child: Icon(Icons.arrow_forward,color: AppColors.primary,size: 10,),
              // )
            ],
          ),
        ),
      ),
    );
  }

}

class SecondaryButton extends StatelessWidget {

  SecondaryButton({ required this.title, required this.onAction});


  String title;
  var onAction;

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 50.w,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.lightBlueColor.withOpacity(.8),
          // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed:onAction,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add,color: Colors.white,size: 15,),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
                style: TextStyle(color: Colors.white, fontSize: 11.sp,fontWeight:FontWeight.bold,fontFamily:"railLight"),textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}

class RemoveButton extends StatelessWidget {

  RemoveButton({ required this.title, required this.onAction});


  String title;
  var onAction;

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      // margin: EdgeInsets.symmetric(horizontal: 10),
      // decoration: DecorationConstants.decorationGradient,
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorConstants.primary
        )
      ),
      child: SizedBox(
        // width: 30.w,
        height: 50,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                  style: TextStyle(color: Colors.white, fontSize: 11.sp,fontWeight:FontWeight.bold,fontFamily:"railLight"),textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.close,color: Colors.white,size: 15,),
            ],
          ),
      ),
    );
  }

}