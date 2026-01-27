import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../Utils/colors_constants.dart';
import 'TextWidgets.dart';

Widget homeCards(String title,IconData icon, {required Null Function() onAction})
{
  return InkWell(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: onAction,
    child: Container(
      width: 50.w,
      height: 200,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        // gradient: LinearGradient(colors: [
        //   ColorConstants.primary,
        //   ColorConstants.secondary.withOpacity(.8),
        // ],begin: Alignment.topCenter,end: Alignment.bottomCenter,),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side - Course Info
          Icon(icon,color:Colors.white),
          SizedBox(width: 20,),
          Text(
            title,
            style: txt_bold(color: Colors.white,textSize: 16),
          ),
          Expanded(child: Text("")),
          Icon(Icons.arrow_forward_ios_rounded,color:Colors.white,size: 15,),
        ],
      ),
    ),
  );
}

class AccountItem {
  final String title;
  final String subtitle;
  final IconData icon;
  AccountItem({required this.title, required this.subtitle, required this.icon});
}

class AccountCard extends StatelessWidget {
  final AccountItem item;
  final VoidCallback onTap;
  final bool selected;

  const AccountCard({
    Key? key,
    required this.item,
    required this.onTap,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // card gradient when selected or default translucent white
    final Gradient activeGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorConstants.primary.withOpacity(.9), ColorConstants.secondary.withOpacity(.8)],
    );

    final Gradient inactiveGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.06),
        Colors.white.withOpacity(0.03),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // duration: const Duration(milliseconds: 220),
        // curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          gradient: selected ? activeGradient : inactiveGradient,
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(
            color:ColorConstants.primary.withOpacity(.4),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon circle
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: selected?Colors.white.withOpacity(.3): Colors.grey.withOpacity(.06),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: ColorConstants.primary, size: 25),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  height: 1,
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              item.subtitle,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  height: 1,
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 11,
                ),
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class CardEntry extends StatelessWidget {
  final AccountItem item;
  final VoidCallback onTap;
  final bool selected;

  const CardEntry({
    Key? key,
    required this.item,
    required this.onTap,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // card gradient when selected or default translucent white
    final Gradient activeGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorConstants.primary.withOpacity(.9), ColorConstants.secondary.withOpacity(.8)],
    );

    final Gradient inactiveGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.06),
        Colors.white.withOpacity(0.03),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // duration: const Duration(milliseconds: 220),
        // curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        decoration: BoxDecoration(
          gradient: !selected ? activeGradient : inactiveGradient,
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
            color:ColorConstants.primary.withOpacity(.4),
          ),
        ),
        child: Row(
          children: [
            // icon circle
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: ColorConstants.primary.withOpacity(.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: ColorConstants.primary, size: 20),
            ),
            SizedBox(
              width: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      height: 1,
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 50.w,
                  child: Text(
                    item.subtitle,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        height: 1,
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                    // textAlign: TextAlign.center,
                  ),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}


Widget infoCard(String title, String? value) {
  return card(title, value ?? "--", Icons.info_outline);
}

Widget card(String title, String subtitle, IconData icon) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: ColorConstants.primary, size: 15),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              height: 35,
              width: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [
                    ColorConstants.primary,
                    ColorConstants.secondary,
                  ],
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(.6),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget row(Widget a, Widget b) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: a),
      const SizedBox(width: 20),
      Expanded(child: b),
    ],
  );
}

Widget txtFiledCustom(String title, String subtitle, IconData icon,TextEditingController controller)
{
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: ColorConstants.primary, size: 15),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              height: 35,
              width: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [
                    ColorConstants.primary,
                    ColorConstants.secondary,
                  ],
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Container(
                height:45,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(.6),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: controller,
                  cursorColor: ColorConstants.primary,
                  // choose keyboard type based on isNumber
                  keyboardType:TextInputType.text,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: subtitle,
                    hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (val) {

                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}