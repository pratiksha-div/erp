import 'package:flutter/material.dart';
import '../../../data/local/AppUtils.dart';
import '../../Widgets/Cards.dart';
import '../../Widgets/MR_Logo.dart';
import '../../Widgets/TextWidgets.dart';
import '../../Widgets/Custom_Drawer.dart';
import '../DailyReporting/Daily_Reporting.dart';
import '../GateEntry/GateEntry.dart';
import '../GatePass/Gate_Pass.dart';
import '../GoodsReceivedNotes/GoodsReceiveNotes.dart';
import '../Projects/All_Projects.dart';
import '../../Utils/colors_constants.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = -1;

  // Role constants
  static const String projectManager = "Project Manager";
  static const String projectCoordinator = "Project Coordinator";
  static const String projectSubCoordinator = "Project Sub-Coordinator";

  // Dynamic items list
  List<AccountItem> items = [];
  List<String> roles=[];

  @override
  void initState() {
    super.initState();
    getLoginInfo();
  }

  void getLoginInfo() async {
    roles = await AppUtils().getUserRole();
    print(
      '''
      Roles : ${roles}
      '''
    );
    setupMenu(roles);
  }

  void setupMenu(List<String> roles) {
    List<AccountItem> tempItems = [];

    // ================= Project Manager =================
    if (roles.contains(projectManager)) {
      tempItems = _allItems();
    }

    // ================= Project Coordinator =================
    else if (roles.contains(projectCoordinator)) {
      tempItems = [
        _gatePass(),
        _projects(),
        _dailyReporting(),
        _grn(),
      ];
    }

    // ================= Project Sub-Coordinator =================
    else if (roles.contains(projectSubCoordinator)) {
      tempItems = [
        _gateEntry(),
        _dailyReporting(),
      ];
    }

    // ================= Default =================
    else {
      tempItems = _allItems();
    }

    setState(() {
      items = tempItems;
    });
  }

  // ===== Reusable Menu Items =====

  List<AccountItem> _allItems() {
    return [
      _gatePass(),
      _projects(),
      _dailyReporting(),
      _gateEntry(),
      _grn(),
    ];
  }

  AccountItem _gatePass() => AccountItem(
    title: 'Gate Pass',
    subtitle: 'All gate pass records',
    icon: Icons.touch_app_rounded,
  );

  AccountItem _projects() => AccountItem(
    title: 'Projects',
    subtitle: 'Manage and monitor',
    icon: Icons.summarize_rounded,
  );

  AccountItem _dailyReporting() => AccountItem(
    title: 'Daily Reporting',
    subtitle: 'Reporting modules',
    icon: Icons.assessment,
  );

  AccountItem _gateEntry() => AccountItem(
    title: 'Gate Entry',
    subtitle: 'Tracks in-out movements',
    icon: Icons.door_sliding_rounded,
  );

  AccountItem _grn() => AccountItem(
    title: 'Goods Received Notes',
    subtitle: 'Record and verify',
    icon: Icons.summarize_rounded,
  );

  // ================= Navigation =================

  Future<void> _onCardTap(int index) async {
    setState(() => selectedIndex = index);

    Widget page;

    switch (items[index].title) {
      case 'Gate Pass':
        page = GatePass();
        break;
      case 'Projects':
        page = AllProjects();
        break;
      case 'Daily Reporting':
        page = DailyReporting(roles: roles);
        break;
      case 'Gate Entry':
        page = GateEntry();
        break;
      case 'Goods Received Notes':
        page = GoodsReceivedNotesPage();
        break;
      case 'Add New Entry':
        page = GateEntry(); // adjust if different screen
        break;
      default:
        page = GatePass();
    }

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );

    if (!mounted) return;
    setState(() => selectedIndex = -1);
  }

  // ================= UI (UNCHANGED) =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorConstants.background,
      drawer: buildCustomDrawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: InkWell(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: Colors.black.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(
                    Icons.menu,
                    size: 18,
                    color: Colors.black.withOpacity(.6),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    mr_logo(),
                    mrTitle("MR Constructions"),
                    subTitle(
                        "Project Monitoring and Entry System"),
                    subTxt(
                        "A smart platform to manage project data, daily reports,"
                            " and gate entries in one unified dashboard."),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(22),
                        border: Border.all(
                            color: ColorConstants.primary
                                .withOpacity(0.08)),
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstants.primary
                                .withOpacity(0.12),
                            blurRadius: 18,
                            offset:
                            const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics:
                            const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1,
                            children: [
                              for (int i = 0;
                              i < items.length;
                              i++)
                                AccountCard(
                                  item: items[i],
                                  selected:
                                  selectedIndex ==
                                      i,
                                  onTap: () =>
                                      _onCardTap(i),
                                ),
                            ],
                          ),
                          const SizedBox(height: 30),
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
    );
  }
}
