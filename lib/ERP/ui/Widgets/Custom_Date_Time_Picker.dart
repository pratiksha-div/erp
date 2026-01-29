
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';

import '../Utils/colors_constants.dart';
import 'Gradient.dart';

class CustomDateTimeTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final onTap;
  bool showTitle;
  String title;

  CustomDateTimeTextField(
      {super.key,required this.hint, required this.icon,this.onTap,this.showTitle=true,this.title="Select Date"});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(showTitle)
        Row(
          children: [
            Icon(Icons.date_range, color: Colors.grey, size: 15),
            SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            sideGradientBar(),
            // Container(
            //   height: 35,
            //   width: 5,
            //   // margin: EdgeInsets.only(bottom: 10),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     gradient: const LinearGradient(
            //       colors: [
            //         ColorConstants.primary,
            //         ColorConstants.secondary,
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(
              width:5
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      readOnly: true,
                      enableInteractiveSelection: false,
                      onTap: onTap,
                      cursorColor: ColorConstants.primary,
                      style: const TextStyle(color:  Colors.black),
                      onSubmitted: (val){
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: const TextStyle(color:  Colors.black54, fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onTap,
                    child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: ColorConstants.primary,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorConstants.primary,
                                ColorConstants.secondary.withOpacity(.6),
                              ],
                            )
                        ),
                        child: Center(
                          child:Icon(
                            icon,
                            size: 12,
                            color:  Colors.white,
                          ),)
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}


Widget txtFiled(
    BuildContext context,
    TextEditingController controller,
    String hint,
    String title, {
      int maxLines = 1,
      bool enable = true,
      Function(String)? onChanged,
      bool isNumber = false, // <--- new: set true to show numeric keyboard & allow digits only
    }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: EdgeInsets.only(left: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(height: 3),
      Row(
        children: [
          Container(
            height: maxLines!=1?60:40,
            width: 5,
            // margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [ColorConstants.primary, ColorConstants.secondary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            width: 80.w,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              enabled: enable,
              cursorColor: ColorConstants.primary,
              // choose keyboard type based on isNumber
              keyboardType: isNumber
                  ? TextInputType.numberWithOptions(signed: false, decimal: false)
                  : TextInputType.text,
              // apply digits-only formatter only when numeric mode is requested
              inputFormatters: isNumber
                  ? <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ]
                  : null,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onChanged: onChanged,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
                border: InputBorder.none,
              ),
              onSubmitted: (val) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    ],
  );
}

