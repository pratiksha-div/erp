
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sizer/sizer.dart';

import '../../api/models/DAOGetRegCustomer.dart';
import '../../bloc/DropDownValueBloc/registered_customer_bloc.dart';
import '../Utils/colors_constants.dart';

class headingText extends StatelessWidget {
  headingText({Key? key, required this.title}) : super(key: key);
  String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style:TextStyle(fontWeight:FontWeight.w600,color:Colors.white,fontFamily:"Aleo",
        fontSize:17.sp,letterSpacing:1),);
  }

}

class subheadingText extends StatelessWidget {
  subheadingText({Key? key, required this.title}) : super(key: key);
  String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style:TextStyle(color:Colors.white,fontSize:11.sp,fontWeight:FontWeight.w400,fontFamily:"railLight",letterSpacing: 1));
  }


}
class subheadingTextBOLD extends StatelessWidget {
  subheadingTextBOLD({Key? key, required this.title}) : super(key: key);
  String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style:TextStyle(color:Colors.white,fontSize:11.sp,fontFamily:"railBold"),);
  }


}

Widget mrTitle(String title){
  return Text(
    title,
    style: GoogleFonts.lalezar(
      textStyle: TextStyle(
        color: ColorConstants.primary,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    ),
  );
}

Widget subTitle(String txt,{double leftMargin=0,double bottomMargin=0})
{
  return  Container(
    margin: EdgeInsets.only(left: leftMargin,bottom: bottomMargin),
    child: Text(
      txt,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: Colors.black.withOpacity(0.95),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
Widget subTxt(String txt)
{
  return Text(
    txt,
    textAlign: TextAlign.center,
    style: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: Colors.black54,
          fontSize: 12.5,
        )),
  );
}

Widget cText(String text,
    {double fontSize = 14,
      color = Colors.white,
      FontWeight? weight,
      TextOverflow? overflow,
      TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: weight,
      overflow: overflow,
    ),
  );
}

TextStyle txt_bold({double textSize=14, Color color = Colors.grey}){
  return GoogleFonts.poppins(
    fontSize: textSize,
    color: color,
    fontWeight: FontWeight.bold,
  );
}


Widget txtField(
    BuildContext context,
    String title,
    TextEditingController controller, {
      Function(String)? onChange,
    }) {
  final fieldWidth = MediaQuery.of(context).size.width / 2 - 50;
  return Container(
    width: fieldWidth,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              height: 35,
              width: fieldWidth,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: controller,
                // DON'T use `const` here
                keyboardType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                // blocks letters, special chars, minus and decimal
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                cursorColor: ColorConstants.primary,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: "",
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: InputBorder.none,
                ),
                // do NOT mutate controller.text here — let inputFormatters do the work
                onChanged: (val) {
                  if (onChange != null) onChange(val);
                },
                onSubmitted: (val) {
                  if (onChange != null) onChange(val);
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    ),
  );
}

Widget txtSuggestionList(
    TextEditingController controller,
    List<RegCustomerData> customers,
    BuildContext context,
    ) {
  return Container(
    width: 80.w,
    constraints: const BoxConstraints(maxHeight: 200),
    margin: const EdgeInsets.only(top: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade400),
    ),
    child: ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final item = customers[index];
        return ListTile(
          dense: true,
          title: Text(item.cust_name ?? ''),
          onTap: () {
            controller.text = item.cust_name ?? '';
            FocusScope.of(context).unfocus();

            // Hide list after selection
            context
                .read<RegisteredCustomerBloc>()
                .add(ClearRegisteredCustomerEvent());
          },
        );
      },
    ),
  );
}

Widget errorText(String? text) {
  return Container(
    padding: const EdgeInsets.only(left: 15),
    child: Text(
      text ?? "",
      style: TextStyle(color: ColorConstants.redColor, fontSize: 13),
    ),
  );
}
