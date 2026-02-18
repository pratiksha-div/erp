import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/local/AppUtils.dart';
import '../Pages/Authentication/Login.dart';
import '../Pages/DailyReporting/Daily_Reporting.dart';
import '../Pages/GateEntry/GateEntry.dart';
import '../Pages/GatePass/Add_Gate_Pass.dart';
import '../Pages/Projects/All_Projects.dart';
import '../Utils/colors_constants.dart';
import '../Utils/images_constants.dart';
import '../Utils/utils.dart';
import 'Custom_Dialog.dart';

Drawer buildCustomDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.white,
    child: Container(
      margin: EdgeInsets.only(left: 20),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 60,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      // color:ColorConstants.primary,
                        border: Border.all(
                            width: 1,
                            color: Colors.black.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                      size: 18,
                    ),
                  )),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            height: 100,
            child: Image.asset(
              ImageConstants.mrlogo,
            ),
          ),
          SizedBox(
            height: 55,
          ),
          buildDrawerItem('Home', Icons.home, onTap: () {
            Navigator.pop(context);
          }),
          buildDrawerItem('Gate entry', Icons.assistant_direction, onTap: () {
            Utils.navigateTo(context, GateEntry());
          }),
          // buildDrawerItem('Daily reporting', Icons.report, onTap: () {
          //   Utils.navigateTo(context, DailyReporting());
          // }),
          buildDrawerItem('Gate pass', Icons.book, onTap: () {
            Utils.navigateTo(context, AddGatePass(id: '',));
          }),
          buildDrawerItem('Projects', Icons.pages, onTap: () {
            Utils.navigateTo(context, AllProjects());
          }),
          buildDrawerItem('My account', Icons.person, onTap: () {
            // Utils.navigateTo(context, AllProjects());
            Navigator.pop(context);
          }),
          buildDrawerItem('Logout', Icons.logout, onTap: () async {
            showConfirmDialog(
                context: context,
                title: "Logout",
                message: "Are you sure you want to logout?",
                content: "",
                barrierDismissible: true,
                confirmText: "Confirm",
                cancelText: "Cancel",
                callback: () async{
                  bool check = await AppUtils().logoutUser();
                  if (check) {
                    Utils.navigateRemoveAll(context, LoginScreen());
                  }
                }
            );
          }),
        ],
      ),
    ),
  );
}

Widget buildDrawerItem(String title, IconData icon,
    {bool selected = false, final onTap}) {
  return Container(
    color: selected ? Colors.grey[800] : Colors.transparent,
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: -4, horizontal: 0),
      visualDensity: VisualDensity(vertical: -1),
      leading: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: ColorConstants.primary,
          border: Border.all(color: ColorConstants.primary.withOpacity(.4)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              ColorConstants.primary,
              ColorConstants.primary.withOpacity(.4)
            ],
          ),
        ),
        child: Icon(
          icon,
          size: 15,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        onTap();
      },
    ),
  );
}
