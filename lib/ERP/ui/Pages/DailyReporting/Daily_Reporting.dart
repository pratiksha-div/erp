import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Utils/colors_constants.dart';
import '../../Utils/utils.dart';
import '../../Widgets/Cards.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/TextWidgets.dart';
import 'Machine_Reading.dart';
import 'Material_Consumption.dart';
import 'New_Entry.dart';

class DailyReporting extends StatefulWidget {
  DailyReporting({super.key, required this.roles});
  final List<String> roles;

  @override
  State<DailyReporting> createState() => _DailyReportingState();
}

class _DailyReportingState extends State<DailyReporting> {

  int selectedIndex = 0;

  final List<AccountItem> items = [
    AccountItem(title: 'Add Machine Reading', subtitle: 'Tracks reading', icon: Icons.add),
    AccountItem(title: 'Add Material Consumption', subtitle: 'Consumed on-site.', icon: Icons.apartment_rounded),
  ];

  final List<AccountItem> newEntry = [
    AccountItem(
      title: 'Add New Entry',
      subtitle: 'Add and manage new entries effortlessly for daily operations.',
      icon: Icons.add,
    ),
  ];

  /// ===== ROLE FLAGS =====
  bool get isAdmin => widget.roles.contains("Admin");
  bool get isManager => widget.roles.contains("Project Manager");
  bool get isCoordinator => widget.roles.contains("Project Coordinator");
  bool get isSubCoordinator => widget.roles.contains("Project Sub-Coordinator");

  /// ===== PRIORITY LOGIC =====
  /// Sub Coordinator overrides all → restricted view
  bool get showMaterialSection =>
      !isSubCoordinator && (isAdmin || isManager || isCoordinator);

  bool get showNewEntry =>
      isSubCoordinator || isAdmin || isManager || isCoordinator;

  void _onCardTap(int index) {
    /// Block access if Sub Coordinator
    if (isSubCoordinator) return;

    setState(() => selectedIndex = index);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (selectedIndex == 0) {
        Utils.navigateTo(context, MachineReading());
      } else if (selectedIndex == 1) {
        Utils.navigateTo(context, MaterialConsumption());
      }
    });
  }

  @override
  void initState() {
    super.initState();

    print("Received Roles: ${widget.roles}");

    if (isSubCoordinator) {
      print("Sub Coordinator Access (Restricted)");
    } else if (isAdmin) {
      print("Admin Access");
    } else if (isManager) {
      print("Manager Access");
    } else if (isCoordinator) {
      print("Coordinator Access");
    }
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

              /// Top bar
              CustomAppbar(
                context,
                title: "Daily Reporting",
                subTitle: "Smart, fast, and secure entry management",
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      const SizedBox(height: 20),

                      /// =========================
                      /// Material Reading Section
                      /// =========================
                      if (showMaterialSection)
                        ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                  color: ColorConstants.primary.withOpacity(0.08)),
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

                                subTitle("Material reading and Consumption"),

                                subTxt(
                                    "Tracks material inflow and consumption across daily operations."),

                                const SizedBox(height: 25),

                                GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 1,
                                  children: [
                                    for (int i = 0; i < items.length; i++)
                                      AccountCard(
                                        item: items[i],
                                        selected: selectedIndex == i,
                                        onTap: () => _onCardTap(i),
                                      ),
                                  ],
                                ),

                                const SizedBox(height: 18),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],

                      /// =========================
                      /// New Entry Section
                      /// =========================
                      if (showNewEntry)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                                color: ColorConstants.primary.withOpacity(0.08)),
                          ),
                          child: Column(
                            children: [

                              const SizedBox(height: 15),

                              subTitle("Today's Work Details"),

                              subTxt(
                                  "Smart, fast, and secure gate entry management"),

                              const SizedBox(height: 20),

                              CardEntry(
                                item: newEntry[0],
                                selected: true,
                                onTap: () {
                                  Utils.navigateTo(context, NewEntry());
                                },
                              ),

                              const SizedBox(height: 18),
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