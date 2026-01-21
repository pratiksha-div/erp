
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
  const DailyReporting({super.key});

  @override
  State<DailyReporting> createState() => _DailyReportingState();
}

class _DailyReportingState extends State<DailyReporting> {

  int selectedIndex=0;

  final List<AccountItem> items = [
    AccountItem(title: 'Add Machine Reading', subtitle: 'Tracks reading', icon: Icons.add),
    AccountItem(title: 'Add Material Consumption', subtitle: 'Consumed on-site.', icon: Icons.apartment_rounded),
  ];

  final List<AccountItem> new_entry = [
    AccountItem(title: 'Add New Entry', subtitle: 'Add and manage new entries effortlessly for daily operations.', icon: Icons.add),
  ];

  void _onCardTap(int index) {
    setState(() => selectedIndex = index);
    Future.delayed(Duration(microseconds: 300),(){
      if(selectedIndex==0){
        Utils.navigateTo(context, MachineReading());
      }
      else if(selectedIndex==1){
        Utils.navigateTo(context, MaterialConsumption());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: ColorConstants.background,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top bar
              CustomAppbar(context,title: "Daily Reporting",subTitle: "Smart, fast, and secure entry management"),
              Expanded(
                child: SingleChildScrollView(
                  // padding: const EdgeInsets.all(16.0),
                  child: Container(
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // White rounded card background to host grid (slightly translucent)
                        SizedBox(
                          height: 20,
                        ),
                        // add material reading and Consumption
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: ColorConstants.primary.withOpacity(0.08)),
                            boxShadow: [
                              BoxShadow(
                                color: ColorConstants.primary.withOpacity(0.12),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            // subtle glass blur-like overlay effect could be added with BackdropFilter
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              subTitle("Material reading and Consumption"),
                              subTxt("Tracks material inflow and consumption across daily operations."),
                              SizedBox(
                                height: 25,
                              ),
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
                        SizedBox(
                          height: 20,
                        ),
                        //add new entry
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: ColorConstants.primary.withOpacity(0.08)),
                            // subtle glass blur-like overlay effect could be added with BackdropFilter
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              subTitle("Today's Work Details"),
                              subTxt("Smart, fast, and secure gate entry management"),
                              SizedBox(
                                height: 20,
                              ),
                              CardEntry(item: new_entry[0], selected: true,
                                onTap: () {
                                  Utils.navigateTo(
                                      context, NewEntry()
                                  );
                                },),
                              const SizedBox(height: 18),

                            ],
                          ),
                        ),
                      ],
                    ),
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
