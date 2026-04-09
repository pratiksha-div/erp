import 'package:flutter/material.dart';
import '../../Utils/colors_constants.dart';
import '../../Utils/utils.dart';
import '../../Widgets/Cards.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/Module_Section_Card.dart';
import '../DailyReporting/Vehicle_Gate_Pass.dart';
import 'Gate_Pass.dart';

class GatePassSection extends StatefulWidget {
  const GatePassSection({super.key});

  @override
  State<GatePassSection> createState() => _GatePassSectionState();
}

class _GatePassSectionState extends State<GatePassSection> {
  int selectedIndex = -1;

  final List<AccountItem> items = [
    AccountItem(
      title: 'Material Gate Pass',
      subtitle: 'Create material gate pass',
      icon: Icons.touch_app_rounded,
    ),
    AccountItem(
      title: 'Vehicle Gate Pass',
      subtitle: 'Track vehicle pass',
      icon: Icons.directions_bus,
    ),
  ];

  void _onCardTap(int index) {
    setState(() => selectedIndex = index);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (index == 0) {
        Utils.navigateTo(context, GatePass());
      } else if (index == 1) {
        // Utils.navigateTo(context, GatePassHistory());
        Utils.navigateTo(context, VehicleGatePass());
      }
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
                title: "Gate Pass Management",
                subTitle: "Create and manage gate passes",
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ModuleSectionCard(
                        title: "Gate Pass Management",
                        subtitle: "Monitoring Material Flow and Vehicle Movement",
                        child: GridView.count(
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
