import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Utils/colors_constants.dart';
import '../../Utils/utils.dart';
import '../../Widgets/Cards.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/Module_Section_Card.dart';
import '../../Widgets/TextWidgets.dart';
import 'Vehicle_Gate_Pass.dart';
import 'Material_Consumption.dart';
import 'New_Report.dart';

class DailyReporting extends StatefulWidget {
  DailyReporting({super.key, required this.roles});
  final List<String> roles;

  @override
  State<DailyReporting> createState() => _DailyReportingState();
}

class _DailyReportingState extends State<DailyReporting> {
  int selectedIndex = -1;

  /// ===== ROLE FLAGS =====
  bool get isAdmin => widget.roles.contains("Admin");
  bool get isManager => widget.roles.contains("Project Manager");
  bool get isCoordinator => widget.roles.contains("Project Coordinator");
  bool get isSubCoordinator => widget.roles.contains("Project Sub-Coordinator");

  /// ===== DYNAMIC ITEMS =====
  List<AccountItem> get displayItems {
    List<AccountItem> list = [];
    if (!isSubCoordinator) {
      list.add(AccountItem(
          title: 'Add Material Consumption',
          subtitle: 'Consumed on-site.',
          icon: Icons.apartment_rounded));
    }
    list.add(AccountItem(
        title: 'Add Your Daily Reporting',
        subtitle: 'Add and manage daily report.',
        icon: Icons.add));
    return list;
  }

  void _onCardTap(int index) {
    final item = displayItems[index];
    setState(() => selectedIndex = index);

    Future.delayed(const Duration(milliseconds: 300), () async {
      if (item.title == 'Add Material Consumption') {
        await Utils.navigateTo(context, MaterialConsumption());
      } else if (item.title == 'Add Your Daily Reporting') {
        await Utils.navigateTo(context, NewReport());
      }
      if (mounted) setState(() => selectedIndex = -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppbar(
                context,
                title: "Daily Reporting",
                subTitle: "Smart, fast, and secure entry management",
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ModuleSectionCard(
                        title: isSubCoordinator
                            ? "Today's Work Details"
                            : "Material reading and Consumption",
                        subtitle: isSubCoordinator
                            ? "Manage your daily work entries effortlessly."
                            : "Tracks material inflow and consumption across daily operations.",
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 1,
                          children: [
                            for (int i = 0; i < displayItems.length; i++)
                              AccountCard(
                                item: displayItems[i],
                                selected: selectedIndex == i,
                                onTap: () => _onCardTap(i),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
