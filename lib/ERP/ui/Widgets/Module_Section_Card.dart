import 'package:flutter/material.dart';
import '../Utils/colors_constants.dart';
import 'TextWidgets.dart';

class ModuleSectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final double topMargin;

  const ModuleSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.topMargin = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: topMargin),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: ColorConstants.primary.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.primary.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          subTitle(title),
          subTxt(subtitle),
          const SizedBox(height: 25),
          child,
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
