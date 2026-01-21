
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/colors_constants.dart';
import 'Custom_Button.dart';

class UploadErrorCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onRetry;
  final double width;
  final double height;

  const UploadErrorCard({
    Key? key,
    this.title = 'Upload error',
    this.subtitle = 'Sorry! Something went wrong',
    this.buttonText = 'Try again',
    this.onRetry,
    this.width = 320,
    this.height = 240,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          // color: ColorConstants.primary,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon area with soft circular background
            SizedBox(
              // width: 70,
              // height: 70,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // soft outer blob
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFFFEAF0), // very light pink
                          Colors.white,
                        ],
                        center: Alignment(-0.3, -0.3),
                        radius: 0.9,
                      ),
                    ),
                  ),
                  // inner circle with X
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:  LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorConstants.primary,
                          ColorConstants.secondary
                        ],
                      ),
                      color: ColorConstants.primary, // pink
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            // Title
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            // Subtitle
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            SizedBox(height: 18),
            // Button
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onRetry,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: ColorConstants.primary),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorConstants.primary,
                      ColorConstants.secondary.withOpacity(.6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Try again",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}


Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String content,
  final callback,
  String confirmText = "Yes",
  String cancelText = "Cancel",
  bool barrierDismissible = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: Colors.white,
        titlePadding: EdgeInsets.symmetric(horizontal: 30, ),
        insetPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),

        /// FIX: Make dialog compact
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(barrierDismissible)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 InkWell(
                   onTap: (){
                     Navigator.pop(context);
                   },
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Icon(Icons.close,size: 15,color: Colors.grey.withOpacity(.6),
                       ),
                     )
                 )
              ],
            ),
            /// Circle icon
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:  ColorConstants.primary
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorConstants.primary,
                    ColorConstants.secondary,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child:  Center(
                child: Icon(
                  barrierDismissible?Icons.login:Icons.done,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            /// Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            /// Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12,color: Colors.grey),
            ),

            const SizedBox(height: 14),
            /// Content text
            Text(
              content,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Buttons Row
            PrimaryButton(title: confirmText, onAction: (){
              callback();
            }),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );

  return result ?? false;
}


void showErrorDialog(BuildContext context,String title, String subtitle) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent,
      child: UploadErrorCard(
        title: title,
        subtitle: subtitle,
        onRetry: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}