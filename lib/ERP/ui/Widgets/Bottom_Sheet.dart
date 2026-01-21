import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/colors_constants.dart';
import 'Custom_Button.dart';
import 'TextWidgets.dart';

class OnDelete extends StatefulWidget {
  OnDelete({
    super.key,
    required this.title1,
    required this.title2,
    this.onCancel,
    this.onConfirm,
  });
  String title1;
  String title2;
  final onCancel;
  final onConfirm;

  @override
  State<OnDelete> createState() => _OnDeleteState();
}

class _OnDeleteState extends State<OnDelete> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Dark grey background
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            // Container(
            //   width: 55,
            //   height: 55,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     gradient:  LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         ColorConstants.primary,
            //         ColorConstants.secondary.withOpacity(.8)
            //       ],
            //     ),
            //     border: Border.all(
            //       color: ColorConstants.primary.withOpacity(.2)
            //     ),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.06),
            //         blurRadius: 8,
            //         offset: Offset(0, 4),
            //       ),
            //     ],
            //   ),
            //   child: Center(
            //     child: Icon(
            //       Icons.close_rounded,
            //       size: 20,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            Center(
              child: Text(
                widget.title1,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            cText(
              widget.title2,
              color: Colors.black54,
              fontSize: 14.0,
              // weight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    title: "Confirm",
                    onAction: () {
                      widget.onConfirm();
                    },
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorConstants.primary,
                            ColorConstants.primary.withOpacity(.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.grey.withOpacity(.2)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                //
                // InkWell(
                //           onTap: () async {
                //             Navigator.of(context).pop();
                //           },
                //           child: Container(
                //             padding:
                //             const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
                //             decoration: ShapeDecoration(
                //                 shape: ContinuousRectangleBorder(
                //                     side: BorderSide(color: Colors.grey.withOpacity(.2)),
                //                     borderRadius: BorderRadius.circular(30)),
                //                 color: ColorConstants.primary),
                //             child: const Icon(Icons.close, size: 18, color: Colors.white),
                //           ),
                //         )
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class onError extends StatefulWidget {
  onError({
    super.key,
    required this.title1,
    required this.title2,
    required this.btnTitle,
    this.onbtnGreenTap,
    this.onbtnBlackTap,
  });
  String title1;
  String title2;
  String btnTitle;
  final onbtnGreenTap;
  final onbtnBlackTap;
  @override
  State<onError> createState() => _onErrorState();
}

class _onErrorState extends State<onError> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Dark grey background
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 60),

            Center(
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: ColorConstants.primary),
                ),
              ),
            ),
            Center(
              child: Text(
                widget.title1,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 4.0),
            cText(
              widget.title2,
              color: Colors.black.withOpacity(.6),
              fontSize: 14.0,
              // weight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
            PrimaryButton(
              title: widget.btnTitle,
              onAction: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
