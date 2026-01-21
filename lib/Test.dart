// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sizer/sizer.dart';
// import 'ERP/UI/Pages/DailyReporting/Add_New_Entry.dart';
// import 'ERP/UI/Utils/colors_constants.dart';
// import 'ERP/UI/Utils/utils.dart';
// import 'ERP/UI/Widgets/Bottom_Sheet.dart';
// import 'ERP/UI/Widgets/Custom_appbar.dart';
// import 'ERP/UI/Widgets/Date_Formate.dart';
// import 'ERP/UI/Widgets/TextWidgets.dart';
// import 'ERP/api/models/DAOGetNewEntries.dart';
// import 'ERP/api/services/add_new_entry.dart';
// import 'ERP/bloc/DailyReporting/delete_new_entry_bloc.dart';
// import 'ERP/bloc/DailyReporting/get_new_entry_bloc.dart';
//
// class NewEntry extends StatefulWidget {
//   const NewEntry({super.key});
//
//   @override
//   State<NewEntry> createState() => _NewEntryState();
// }
//
// class _NewEntryState extends State<NewEntry> {
//   final ScrollController _scrollController = ScrollController();
//
//   static const int _pageSize = 10;
//
//   bool _isInitialLoading = false;
//   bool _isLoadingMore = false;
//   bool _hasMore = true;
//   String? _errorMessage;
//
//   final List<NewEntryData> _items = [];
//   NewEntryData? _lastRemovedItem;
//
//   late final NewEntryBloc _newEntryBloc;
//   late final DeleteNewEntryBloc _deleteNewEntryBloc;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _newEntryBloc = NewEntryBloc(service: NewEntryService());
//     _deleteNewEntryBloc = DeleteNewEntryBloc();
//
//     _loadInitialPage();
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 200 &&
//           !_isLoadingMore &&
//           _hasMore) {
//         _loadMore();
//       }
//     });
//   }
//
//   void _loadInitialPage() {
//     setState(() {
//       _isInitialLoading = true;
//       _errorMessage = null;
//     });
//
//     _newEntryBloc.add(
//       FetchNewEntrysEvent(start: 0, length: _pageSize),
//     );
//   }
//
//   void _loadMore() {
//     _isLoadingMore = true;
//     _newEntryBloc.add(
//       FetchNewEntrysEvent(start: _items.length, length: _pageSize),
//     );
//   }
//
//   Future<void> _onRefresh() async {
//     setState(() {
//       _items.clear();
//       _hasMore = true;
//       _isInitialLoading = true;
//       _errorMessage = null;
//     });
//
//     _newEntryBloc.add(
//       FetchNewEntrysEvent(start: 0, length: _pageSize),
//     );
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _newEntryBloc.close();
//     _deleteNewEntryBloc.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: _newEntryBloc),
//         BlocProvider.value(value: _deleteNewEntryBloc),
//       ],
//       child: Scaffold(
//         backgroundColor: ColorConstants.background,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             child: MultiBlocListener(
//               listeners: [
//                 BlocListener<NewEntryBloc, NewEntryState>(
//                   listener: (_, state) {
//                     if (state is NewEntryLoadSuccess) {
//                       setState(() {
//                         if (_isInitialLoading) _items.clear();
//                         _items.addAll(state.newEntry);
//
//                         _hasMore = state.newEntry.length == _pageSize;
//                         _isInitialLoading = false;
//                         _isLoadingMore = false;
//                       });
//                     }
//
//                     if (state is NewEntryLoadFailure) {
//                       setState(() {
//                         _isInitialLoading = false;
//                         _isLoadingMore = false;
//                         _errorMessage = state.message;
//                       });
//                     }
//                   },
//                 ),
//                 BlocListener<DeleteNewEntryBloc, DeleteNewEntryState>(
//                   listener: (_, state) {
//                     if (state is DeleteNewEntrySuccess) {
//                       Fluttertoast.showToast(msg: "Entry deleted");
//                       _lastRemovedItem = null;
//                       _onRefresh();
//                     }
//
//                     if (state is DeleteNewEntryFailed) {
//                       if (_lastRemovedItem != null) {
//                         setState(() {
//                           _items.insert(0, _lastRemovedItem!);
//                         });
//                       }
//                       Fluttertoast.showToast(msg: state.message);
//                     }
//                   },
//                 ),
//               ],
//               child: Column(
//                 children: [
//                   CustomAppbar(
//                     context,
//                     title: "New Entry List",
//                     subTitle: "Smart, fast, and secure gate entry",
//                   ),
//                   Expanded(
//                     child: RefreshIndicator(
//                       onRefresh: _onRefresh,
//                       color: ColorConstants.primary,
//                       child: _buildList(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildList() {
//     if (_errorMessage != null && _items.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_errorMessage!),
//             TextButton(onPressed: _loadInitialPage, child: const Text("Retry")),
//           ],
//         ),
//       );
//     }
//
//     return ListView.builder(
//       controller: _scrollController,
//       physics: const AlwaysScrollableScrollPhysics(),
//       itemCount: _items.length + 2,
//       itemBuilder: (_, index) {
//         if (index == 0) return _buildHeader();
//
//         if (index == _items.length + 1) {
//           if (_isLoadingMore) {
//             return const Padding(
//               padding: EdgeInsets.all(20),
//               child: Center(
//                 child:
//                 CircularProgressIndicator(color: ColorConstants.primary),
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         }
//
//         return _buildItemCard(_items[index - 1]);
//       },
//     );
//   }
//
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: InkWell(
//         onTap: () async {
//           final result =
//           await Utils.navigateTo(context, AddNewEntry(id: ""));
//           if (result == "true") _onRefresh();
//         },
//         child: Container(
//           width: 80.w,
//           padding: const EdgeInsets.symmetric(vertical: 15),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             gradient: LinearGradient(
//               colors: [ColorConstants.primary, ColorConstants.secondary],
//             ),
//           ),
//           child: Center(
//             child: Text(
//               "Add New Entry",
//               style: txt_bold(color: Colors.black, textSize: 12),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildItemCard(NewEntryData i) {
//     final type = (i.lookupvalue ?? '').toLowerCase();
//
//     Color fg = ColorConstants.primary;
//     Color bg = fg.withOpacity(.2);
//
//     if (type == 'permanent employee') {
//       fg = ColorConstants.green;
//       bg = fg.withOpacity(.2);
//     } else if (type == 'contractor') {
//       fg = ColorConstants.lightBlueColor;
//       bg = fg.withOpacity(.2);
//     }
//
//     return InkWell(
//       onTap: () async {
//         final result = await Utils.navigateTo(
//           context,
//           AddNewEntry(id: i.work_detail_id ?? ""),
//         );
//         if (result == "true") _onRefresh();
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if ((i.lookupvalue ?? '').isNotEmpty)
//               Align(
//                 alignment: Alignment.topRight,
//                 child: _typeChip(i.lookupvalue!, fg, bg),
//               ),
//             const SizedBox(height: 10),
//             _titleSection(i),
//             const SizedBox(height: 10),
//             if ((i.notes ?? '').isNotEmpty) cText(i.notes),
//             const SizedBox(height: 10),
//             _footerRow(i),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _typeChip(String text, Color fg, Color bg) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Text(
//         text,
//         style: GoogleFonts.poppins(
//           fontSize: 10,
//           color: fg,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   Widget _titleSection(NewEntryData i) {
//     return Row(
//       children: [
//         Container(
//           height: 30,
//           width: 5,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             gradient: LinearGradient(
//               colors: [
//                 ColorConstants.primary,
//                 ColorConstants.secondary,
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               i.employeename ?? i.empName ?? "",
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             if ((i.projectname ?? '').isNotEmpty)
//               SizedBox(
//                 width: 200,
//                 child: Text(
//                   i.projectname!,
//                   style: GoogleFonts.poppins(
//                     fontSize: 13,
//                     color: Colors.black54,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _footerRow(NewEntryData i) {
//     return Row(
//       children: [
//         if ((i.entryDate ?? '').isNotEmpty) ...[
//           const Text("Entry Date: "),
//           Text(
//             formatEntryDate(i.entryDate!),
//             style: GoogleFonts.poppins(
//               color: ColorConstants.primary,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//         const Spacer(),
//         const Icon(Icons.edit, size: 15, color: Colors.grey),
//         const SizedBox(width: 20),
//         InkWell(
//           onTap: () => _showDeleteSheet(i),
//           child: const Icon(Icons.close, size: 15, color: Colors.grey),
//         ),
//       ],
//     );
//   }
//
//   void _showDeleteSheet(NewEntryData i) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (sheetContext) {
//         return OnDelete(
//           title1: 'Delete Gate Entry',
//           title2: 'Are you sure you want to delete this entry?',
//           onCancel: () => Navigator.pop(sheetContext),
//           onConfirm: () {
//             _lastRemovedItem = i;
//             setState(() {
//               _items.remove(i);
//             });
//             context.read<DeleteNewEntryBloc>().add(
//               SubmitDeleteNewEntryEvent(
//                 work_detail_id: i.work_detail_id ?? "",
//               ),
//             );
//             Navigator.pop(sheetContext);
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'ERP/UI/Utils/colors_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Blinking Text Demo',
          home: const TestBlinkingTextPage(),
        );
      },
    );
  }
}

/* ------------------ BlinkingText Widget ------------------ */

class BlinkingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const BlinkingText({
    super.key,
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  State<BlinkingText> createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scale = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 100,
          padding: EdgeInsets.symmetric(
            horizontal: 20.sp,
            vertical: 12.sp,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF6CD95),
                Color(0xFFFFF5F5),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: ColorConstants.primary.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.text, style: widget.style),
            ],
          ),
        ),
      ),
    );
  }
}

/* ------------------ Test Screen ------------------ */

class TestBlinkingTextPage extends StatelessWidget {
  const TestBlinkingTextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blinking Text Test"),
      ),
      body: Center(
        child: BlinkingText(
          text: "Enter end time",
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:sizer/sizer.dart';
// import '../../../api/models/DAOGetGatePass.dart';
// import '../../../api/services/add_gate_pass_service.dart';
// import '../../../bloc/GatePass/delete_gate_pass_bloc.dart';
// import '../../../bloc/GatePass/delete_gate_pass_project_bloc.dart';
// import '../../../bloc/GatePass/delete_gate_pass_warehouse_bloc.dart';
// import '../../../bloc/GatePass/gate_pass_bloc.dart';
// import '../../Utils/utils.dart';
// import '../../Widgets/Bottom_Sheet.dart';
// import '../../Widgets/Custom_Date_Time_Picker.dart';
// import '../../Widgets/Custom_Dropdown.dart';
// import '../../Widgets/Custom_appbar.dart';
// import '../../Widgets/Date_Formate.dart';
// import '../../Widgets/TextWidgets.dart';
// import '../../Utils/colors_constants.dart';
// import 'Add_Gate_Pass.dart';
// import 'Gate_Pass_Detail.dart';
//
// class GatePass extends StatefulWidget {
//   const GatePass({super.key});
//
//   @override
//   State<GatePass> createState() => _GatePassState();
// }
//
// class _GatePassState extends State<GatePass> {
//   final TextEditingController searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   DateTime? _selectedFromDate;
//   DateTime? _selectedToDate;
//   final transferType = ['Warehouse Type', 'Project Type'];
//   String selectedTransfer = "";
//   // paging
//   static const int _pageSize = 10;
//   bool _isLoadingMore = false;
//   bool _hasMore = true;
//   bool _isInitialLoading = false;
//   String? _error;
//
//   // data
//   final List<GatePassData> _allItems = []; // master list accumulated from pages
//   final List<GatePassData> _visibleItems = []; // filtered by search
//
//   late final GatePassBloc _GatePassBloc;
//
//   Timer? _debounce;
//
//   // filters (server-side)
//   String gatePass = "";
//   String itemSelected = "";
//   String transferSelected = "";
//   String dateFrom = "";
//   String dateTo = "";
//
//   // delete blocs (page-level)
//   late final DeleteGatePassBloc _deleteGatePassBloc;
//   late final DeleteGatePassProjectBloc _deleteGatePassProjectBloc;
//   late final DeleteGatePassWarehouseBloc _deleteGatePassWarehouseBloc;
//
//   // optimistic rollback storage
//   GatePassData? _lastRemovedItem;
//   int? _lastRemovedIndex;
//
//   // pending deletes tracker — will contain keys like "gatepass","project","warehouse"
//   final Set<String> _pendingDeletes = {};
//
//   @override
//   void initState() {
//     super.initState();
//     final service = GatePassService();
//     _GatePassBloc = GatePassBloc(service: service);
//
//     // create delete blocs
//     _deleteGatePassBloc = DeleteGatePassBloc();
//     _deleteGatePassProjectBloc = DeleteGatePassProjectBloc();
//     _deleteGatePassWarehouseBloc = DeleteGatePassWarehouseBloc();
//
//     // search debounce
//     searchController.addListener(() {
//       if (_debounce?.isActive ?? false) _debounce!.cancel();
//       _debounce = Timer(const Duration(milliseconds: 300), () {
//         _applyLocalSearch();
//       });
//     });
//
//     _loadPage(start: 0);
//     _scrollController.addListener(_onScroll);
//   }
//
//   void _applyLocalSearch() {
//     final q = searchController.text.trim().toLowerCase();
//     setState(() {
//       if (q.isEmpty) {
//         _visibleItems
//           ..clear()
//           ..addAll(_allItems);
//       } else {
//         _visibleItems
//           ..clear()
//           ..addAll(_allItems.where((p) {
//             final gate = (p.gate_pass ?? '').toString().toLowerCase();
//             final material = (p.issued_material ?? '').toString().toLowerCase();
//             final fromWh =
//             (p.from_warehouse_name ?? '').toString().toLowerCase();
//             final toWh = (p.to_warehouse_name ?? '').toString().toLowerCase();
//             final proj = (p.to_project_name ?? '').toString().toLowerCase();
//             final transfer = (p.transfer_type ?? '').toString().toLowerCase();
//             final outTime = (p.out_time ?? '').toString().toLowerCase();
//
//             return gate.contains(q) ||
//                 material.contains(q) ||
//                 fromWh.contains(q) ||
//                 toWh.contains(q) ||
//                 proj.contains(q) ||
//                 transfer.contains(q) ||
//                 outTime.contains(q);
//           }));
//       }
//     });
//   }
//
//   void _onScroll() {
//     if (!_scrollController.hasClients || _isLoadingMore || !_hasMore) return;
//     final maxScroll = _scrollController.position.maxScrollExtent;
//     final current = _scrollController.position.pixels;
//     if (current >= (maxScroll - 300)) {
//       _loadPage(start: _allItems.length);
//     }
//   }
//
//   Future<void> _loadPage({required int start}) async {
//     // defensive: avoid duplicate loads
//     if ((start == 0 && _isInitialLoading) || (start > 0 && _isLoadingMore)) {
//       return;
//     }
//
//     if (start == 0) {
//       if (!mounted) return;
//       setState(() {
//         _isInitialLoading = true;
//         _error = null;
//       });
//     } else {
//       if (!mounted) return;
//       setState(() {
//         _isLoadingMore = true;
//       });
//     }
//
//     _GatePassBloc.add(FetchGatePasssEvent(
//       start: start,
//       length: _pageSize,
//       from: dateFrom,
//       to: dateTo,
//       gate_pass_number: gatePass,
//       transferType: transferSelected,
//       item: itemSelected,
//     ));
//   }
//
//   Future<void> _onRefresh() async {
//     dateFrom = "";
//     dateTo = "";
//     _selectedFromDate = null;
//     _selectedToDate = null;
//     selectedTransfer = "";
//     transferSelected = "";
//     _hasMore = true;
//     _allItems.clear();
//     _visibleItems.clear();
//     searchController.text = "";
//     setState(() {});
//     _loadPage(start: 0);
//
//     // wait until initial load finished
//     while (_isInitialLoading) {
//       await Future.delayed(const Duration(milliseconds: 50));
//     }
//   }
//
//   @override
//   void dispose() {
//     _debounce?.cancel();
//     searchController.dispose();
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     _GatePassBloc.close();
//     _deleteGatePassBloc.close();
//     _deleteGatePassProjectBloc.close();
//     _deleteGatePassWarehouseBloc.close();
//     super.dispose();
//   }
//
//   void _clearPendingDeletes() {
//     _pendingDeletes.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Provide GatePassBloc + delete blocs to subtree
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<GatePassBloc>.value(value: _GatePassBloc),
//         BlocProvider<DeleteGatePassBloc>.value(value: _deleteGatePassBloc),
//         BlocProvider<DeleteGatePassProjectBloc>.value(
//             value: _deleteGatePassProjectBloc),
//         BlocProvider<DeleteGatePassWarehouseBloc>.value(
//             value: _deleteGatePassWarehouseBloc),
//       ],
//       child: Scaffold(
//         backgroundColor: ColorConstants.background,
//         body: SafeArea(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomAppbar(context,
//                     title: "Gate Pass", subTitle: "View and manage all gate passes"),
//                 Expanded(
//                   child: MultiBlocListener(
//                     listeners: [
//                       BlocListener<GatePassBloc, GatePassState>(
//                         listener: (context, state) {
//                           if (state is GatePassLoadSuccess) {
//                             final newItems = state.GatePass ?? [];
//                             setState(() {
//                               // append new items (avoid duplicates)
//                               for (var ni in newItems) {
//                                 final exists = _allItems.any(
//                                         (e) => e.gatepass_id == ni.gatepass_id);
//                                 if (!exists) _allItems.add(ni);
//                               }
//
//                               // update visible list using local search box
//                               final q =
//                               searchController.text.trim().toLowerCase();
//                               if (q.isEmpty) {
//                                 _visibleItems
//                                   ..clear()
//                                   ..addAll(_allItems);
//                               } else {
//                                 _visibleItems
//                                   ..clear()
//                                   ..addAll(_allItems.where((p) {
//                                     final gate = (p.gate_pass ?? '')
//                                         .toString()
//                                         .toLowerCase();
//                                     final material = (p.issued_material ?? '')
//                                         .toString()
//                                         .toLowerCase();
//                                     final fromWh = (p.from_warehouse_name ?? '')
//                                         .toString()
//                                         .toLowerCase();
//                                     final toWh = (p.to_warehouse_name ?? '')
//                                         .toString()
//                                         .toLowerCase();
//                                     final proj = (p.to_project_name ?? '')
//                                         .toString()
//                                         .toLowerCase();
//                                     final transfer = (p.transfer_type ?? '')
//                                         .toString()
//                                         .toLowerCase();
//                                     final outTime = (p.out_time ?? '')
//                                         .toString()
//                                         .toLowerCase();
//
//                                     return gate.contains(q) ||
//                                         material.contains(q) ||
//                                         fromWh.contains(q) ||
//                                         toWh.contains(q) ||
//                                         proj.contains(q) ||
//                                         transfer.contains(q) ||
//                                         outTime.contains(q);
//                                   }));
//                               }
//
//                               // clear loading flags
//                               _isInitialLoading = false;
//                               _isLoadingMore = false;
//
//                               // pagination
//                               if (newItems.length < _pageSize) {
//                                 _hasMore = false;
//                               } else {
//                                 _hasMore = true;
//                               }
//                             });
//                           } else if (state is GatePassLoadFailure) {
//                             setState(() {
//                               _isInitialLoading = false;
//                               _isLoadingMore = false;
//                               _error = state.message;
//                             });
//                           }
//                         },
//                       ),
//                       BlocListener<DeleteGatePassBloc, DeleteGatePassState>(
//                         listener: (context, state) {
//                           if (state is DeleteGatePassSuccess) {
//                             // Remove 'gatepass' from pending. If no more pending, refresh.
//                             _pendingDeletes.remove('gatepass');
//                             if (_pendingDeletes.isEmpty) {
//                               // all deletes done -> refresh
//                               _lastRemovedItem = null;
//                               _lastRemovedIndex = null;
//                               _onRefresh();
//                             }
//                           } else if (state is DeleteGatePassFailed) {
//                             // rollback optimistic removal if present
//                             if (_lastRemovedItem != null) {
//                               setState(() {
//                                 final idx = _lastRemovedIndex ?? 0;
//                                 final insertIndex = (idx <= _allItems.length)
//                                     ? idx
//                                     : _allItems.length;
//                                 _allItems.insert(
//                                     insertIndex, _lastRemovedItem!);
//                                 // reapply visible filter
//                                 _applyLocalSearch();
//                               });
//                               _lastRemovedItem = null;
//                               _lastRemovedIndex = null;
//                             }
//                             _clearPendingDeletes();
//                           }
//                         },
//                       ),
//                       BlocListener<DeleteGatePassProjectBloc,
//                           DeleteGatePassProjectState>(
//                         listener: (context, state) {
//                           if (state is DeleteGatePassProjectSuccess) {
//                             _pendingDeletes.remove('project');
//                             if (_pendingDeletes.isEmpty) {
//                               _lastRemovedItem = null;
//                               _lastRemovedIndex = null;
//                               _onRefresh();
//                             }
//                           } else if (state is DeleteGatePassProjectFailed) {
//                             // rollback
//                             if (_lastRemovedItem != null) {
//                               setState(() {
//                                 final idx = _lastRemovedIndex ?? 0;
//                                 final insertIndex = (idx <= _allItems.length)
//                                     ? idx
//                                     : _allItems.length;
//                                 _allItems.insert(
//                                     insertIndex, _lastRemovedItem!);
//                                 _applyLocalSearch();
//                               });
//                               _lastRemovedItem = null;
//                               _lastRemovedIndex = null;
//                             }
//                             _clearPendingDeletes();
//                           }
//                         },
//                       ),
//                       BlocListener<DeleteGatePassWarehouseBloc,
//                           DeleteGatePassWarehouseState>(
//                         listener: (context, state) {
//                           if (state is DeleteGatePassWarehouseSuccess) {
//                             _pendingDeletes.remove('warehouse');
//                             if (_pendingDeletes.isEmpty) {
//                               _lastRemovedItem = null;
//                               _lastRemovedIndex = null;
//                               _onRefresh();
//                             }
//                           } else if (state is DeleteGatePassWarehouseFailed) {
//                             if (_lastRemovedItem != null) {
//                               setState(() {
//                                 final idx = _lastRemovedIndex ?? 0;
//                                 final insertIndex = (idx <= _allItems.length)
//                                     ? idx
//                                     : _allItems.length;
//                                 _allItems.insert(
//                                     insertIndex, _lastRemovedItem!);
//                                 _applyLocalSearch();
//                               });
//                               _lastRemovedItem = null;
//                               _lastRemovedIndex = null;
//                             }
//                             _clearPendingDeletes();
//                           }
//                         },
//                       ),
//                     ],
//                     child: RefreshIndicator(
//                       color: ColorConstants.primary,
//                       backgroundColor: Colors.white,
//                       onRefresh: _onRefresh,
//                       child: _buildBody(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBody() {
//     final header = Container(
//       padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 20),
//       margin: const EdgeInsets.only(top: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: InkWell(
//                   splashColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   onTap: () {},
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
//                     decoration: ShapeDecoration(
//                       shape: ContinuousRectangleBorder(
//                           side: BorderSide(color: Colors.grey.withOpacity(.2)),
//                           borderRadius: BorderRadius.circular(30)),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                             child: Icon(FeatherIcons.search,
//                                 color: ColorConstants.primary, size: 15)),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: TextField(
//                             controller: searchController,
//                             cursorColor: ColorConstants.primary,
//                             decoration: const InputDecoration(
//                               hintText: "Search by item and gate pass",
//                               hintStyle: TextStyle(
//                                   fontSize: 13
//                               ),
//                               border: InputBorder.none,
//                             ),
//                             onChanged: (v) {
//                               final q = v.trim().toLowerCase();
//                               setState(() {
//                                 _visibleItems
//                                   ..clear()
//                                   ..addAll(_allItems.where((p) {
//                                     final gate = (p.gate_pass ?? '')
//                                         .toString()
//                                         .toLowerCase();
//                                     final material = (p.issued_material ?? '')
//                                         .toString()
//                                         .toLowerCase();
//                                     final fromWh = (p.from_warehouse_name ?? '')
//                                         .toString()
//                                         .toLowerCase();
//                                     final toWh = (p.to_warehouse_name ?? '')
//                                         .toString()
//                                         .toLowerCase();
//                                     final proj = (p.to_project_name ?? '')
//                                         .toString()
//                                         .toLowerCase();
//                                     final transfer = (p.transfer_type ?? '')
//                                         .toString()
//                                         .toLowerCase();
//                                     final outTime = (p.out_time ?? '')
//                                         .toString()
//                                         .toLowerCase();
//
//                                     return gate.contains(q) ||
//                                         material.contains(q) ||
//                                         fromWh.contains(q) ||
//                                         toWh.contains(q) ||
//                                         proj.contains(q) ||
//                                         transfer.contains(q) ||
//                                         outTime.contains(q);
//                                   }));
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               InkWell(
//                 onTap: () async {
//                   final result = await Utils.navigateTo(
//                     context,
//                     AddGatePassPage(id: ""),
//                   );
//                   if (result == "true") {
//                     _onRefresh();
//                   }
//                 },
//                 child: Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   decoration: ShapeDecoration(
//                       shape: ContinuousRectangleBorder(
//                           side: BorderSide(color: Colors.grey.withOpacity(.2)),
//                           borderRadius: BorderRadius.circular(30)),
//                       color: ColorConstants.primary),
//                   child: const Icon(Icons.add, size: 18, color: Colors.white),
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: CustomDateTimeTextField(
//                   onTap: _pickFromDate,
//                   hint: _selectedFromDate == null
//                       ? '-- From Date --'
//                       : DateFormat("d MMMM y").format(_selectedFromDate!),
//                   icon: Icons.calendar_month,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: CustomDateTimeTextField(
//                   onTap: _pickToDate,
//                   hint: _selectedToDate == null
//                       ? '-- To Date --'
//                       : DateFormat("d MMMM y").format(_selectedToDate!),
//                   icon: Icons.calendar_month,
//                 ),
//               ),
//             ],
//           ),
//           TransferDropdown<String>(
//             title: "Transfer Type",
//             hint: 'Select Transfer Type',
//             selectedVal: selectedTransfer,
//             data: transferType,
//             displayText: (t) => t,
//             onChanged: (val) {
//               selectedTransfer = val;
//               _applyFiltersAndReload();
//             },
//           ),
//         ],
//       ),
//     );
//
//     // If still initial loading, show header + spinner
//     if (_isInitialLoading && _allItems.isEmpty) {
//       return ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: [
//           header,
//           const SizedBox(height: 30),
//           const Center(
//               child: CircularProgressIndicator(color: ColorConstants.primary)),
//         ],
//       );
//     }
//
//     if (_error != null && _allItems.isEmpty) {
//       return ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: [
//           header,
//           const SizedBox(height: 30),
//           Center(
//             child: Column(
//               children: [
//                 Text('Error: $_error'),
//                 const SizedBox(height: 12),
//                 InkWell(
//                   onTap: () {
//                     _loadPage(start: 0);
//                   },
//                   child: Container(
//                     width: 40.w,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 10),
//                     decoration: BoxDecoration(
//                       border:
//                       Border.all(width: 1, color: ColorConstants.primary),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Center(
//                         child: cText("Retry", color: ColorConstants.primary)),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       );
//     }
//
//     final bool filtersApplied = (searchController.text.trim().isNotEmpty) ||
//         selectedTransfer != null ||
//         _selectedFromDate != null ||
//         _selectedToDate != null;
//
//     if (!_isInitialLoading && _visibleItems.isEmpty) {
//       if (filtersApplied) {
//         return ListView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           children: [
//             header,
//             const SizedBox(height: 30),
//             Center(
//               child: Column(
//                 children: [
//                   Container(
//                       padding:
//                       EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           color: ColorConstants.primary.withOpacity(.07)),
//                       child: const Icon(Icons.search_off,
//                           size: 20, color: ColorConstants.primary)),
//                   const SizedBox(height: 12),
//                   Text('No records found for search result',
//                       style: GoogleFonts.poppins(
//                           color: ColorConstants.primary.withOpacity(.6))),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           _onRefresh();
//                         },
//                         child: Container(
//                           width: 40.w,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 10),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 width: 1, color: ColorConstants.primary),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Center(
//                               child: cText("Clear filters",
//                                   color: ColorConstants.primary)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         );
//       }
//       return ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: [
//           header,
//           const SizedBox(height: 30),
//           Center(
//             child: Column(
//               children: [
//                 const Icon(Icons.inbox, size: 48, color: Colors.grey),
//                 const SizedBox(height: 12),
//                 Text('No gate pass records found',
//                     style: GoogleFonts.poppins(color: Colors.black54)),
//                 const SizedBox(height: 8),
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       _hasMore = true;
//                       _isInitialLoading = true;
//                       _allItems.clear();
//                       _visibleItems.clear();
//                     });
//                     _loadPage(start: 0);
//                   },
//                   child: Container(
//                     width: 40.w,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 10),
//                     decoration: BoxDecoration(
//                       border:
//                       Border.all(width: 1, color: ColorConstants.primary),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Center(
//                         child: cText("Reload", color: ColorConstants.primary)),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       );
//     }
//
//     final int extra =
//         2 + (_hasMore ? 1 : 0); // header + spacer + optional load-more
//     final int totalCount = _visibleItems.length + extra;
//
//     return ListView.separated(
//         controller: _scrollController,
//         itemCount: totalCount,
//         separatorBuilder: (_, __) => const SizedBox(height: 8),
//         itemBuilder: (context, index) {
//           if (index == 0) {
//             return header;
//           }
//           if (index == 1) {
//             return const SizedBox(height: 10);
//           }
//           final dataIndex = index - 2;
//           if (dataIndex < _visibleItems.length && dataIndex >= 0) {
//             final i = _visibleItems[dataIndex];
//             return _buildProjectCard(i);
//           }
//           if (_hasMore && dataIndex == _visibleItems.length) {
//             if (!_isLoadingMore) {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 if (!mounted) return;
//                 if (!_isLoadingMore) _loadPage(start: _allItems.length);
//               });
//             }
//             return const Padding(
//               padding: EdgeInsets.symmetric(vertical: 16),
//               child: Center(
//                   child:
//                   CircularProgressIndicator(color: ColorConstants.primary)),
//             );
//           }
//           return const SizedBox.shrink();
//         });
//   }
//
//   Widget _buildProjectCard(GatePassData i) {
//
//     bool allEmpty =
//         (i.gate_pass == null || i.gate_pass.toString().trim().isEmpty) &&
//             ((i.to_project_name ?? '').toString().trim().isEmpty) &&
//             ((i.from_warehouse_name ?? '').toString().trim().isEmpty) &&
//             ((i.to_warehouse_name ?? '').toString().trim().isEmpty) &&
//             ((i.out_time ?? '').toString().trim().isEmpty) &&
//             ((i.quantity ?? '').toString()=="0") &&
//             ((i.issued_material ?? '').toString()=="0") &&
//             ((i.transfer_type ?? '').toString().trim().isEmpty);
//
//     if (allEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     return InkWell(
//       highlightColor: Colors.transparent,
//       splashColor: Colors.transparent,
//       onTap: () async {
//         final result = await Utils.navigateTo(context, GatePassDetail(data: i));
//         if (result == "true") {
//           _onRefresh();
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: Colors.white.withOpacity(0.8),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 if ((i.date ?? '').toString().isNotEmpty)
//                   ...[Text(
//                     "Added on: ",
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       color: ColorConstants.primary,
//                     ),
//                   ),
//                     Text(
//                       formatEntryDate(i.date ?? DateTime.now().toString()),
//                       style: GoogleFonts.poppins(
//                         fontSize: 12,
//                         color: Colors.black.withOpacity(.6),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),],
//                 Expanded(child: Text("")),
//                 if ((i.gate_pass ?? '').toString().trim().isNotEmpty) ...[
//                   Container(
//                     width: 120,
//                     child: Text(
//                       " Gno. ${i.gate_pass} ",
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.end,
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         color: ColorConstants.primary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ]
//               ],
//             ),
//             Divider(
//               color: Colors.grey.withOpacity(.2),
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if(i.from_warehouse_name.toString().isNotEmpty)
//                   ...[ Column(
//                     children: [
//                       Text(
//                         "From Warehouse ",
//                         style: GoogleFonts.poppins(
//                           fontSize: 10,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Container(
//                         width: 120,
//                         child: Text(
//                           "${i.from_warehouse_name ?? "-"}",
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: Colors.black.withOpacity(.8),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                     Expanded(child: Text("")),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       child: Icon(
//                         Icons.arrow_forward,
//                         color: Colors.grey,
//                         size: 12,
//                       ),
//                     ),
//                     Expanded(child: Text("")),],
//                 Column(
//                   children: [
//                     Text(
//                       (i.transfer_type == "project_type" ||
//                           i.transfer_type == "Project Type")
//                           ? "Project"
//                           : " To Warehouse",
//                       style: GoogleFonts.poppins(
//                         fontSize: 10,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Container(
//                       width: 120,
//                       child: Text(
//                         (i.transfer_type == "project_type" ||
//                             i.transfer_type == "Project Type")
//                             ? " ${i.to_project_name ?? "-"}"
//                             : "${i.to_warehouse_name ?? "-"}",
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: Colors.black.withOpacity(.8),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 if ((i.issued_material ?? '').toString().trim().isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Material: ",
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           color: Colors.black.withOpacity(.8),
//                         ),
//                       ),
//                       Container(
//                         width: 40.w,
//                         child: Text(
//                           "${i.issued_material}",
//                           style: GoogleFonts.poppins(
//                             height: 1,
//                             fontSize: 14,
//                             color: ColorConstants.primary,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 const Expanded(child: SizedBox()),
//                 if ((i.out_time ?? '').toString().trim().isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Out time",
//                         style: GoogleFonts.poppins(
//                           fontSize: 10,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text(
//                         "${i.out_time}",
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 const SizedBox(width: 10),
//                 Container(
//                   height: 35,
//                   width: 5,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     gradient: LinearGradient(
//                       colors: [
//                         ColorConstants.primary,
//                         ColorConstants.secondary,
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Builder(builder: (_) {
//                   final quantityStr = (i.quantity ?? '').toString().trim();
//                   if (quantityStr.isNotEmpty)
//                     return values("Issued Quantity", quantityStr);
//                   return const SizedBox.shrink();
//                 }),
//                 const Expanded(child: SizedBox()),
//                 const Icon(Icons.visibility, color: Colors.grey, size: 15),
//                 const SizedBox(width: 10),
//                 Container(
//                   height: 10,
//                   width: 1,
//                   color: Colors.grey.withOpacity(.6),
//                 ),
//                 const SizedBox(width: 10),
//                 InkWell(
//                     onTap: () {
//                       final parentContext = context;
//                       showModalBottomSheet(
//                         context: parentContext,
//                         isScrollControlled: true,
//                         backgroundColor: Colors.transparent,
//                         barrierColor: Colors.black.withOpacity(0.6),
//                         builder: (sheetContext) {
//                           return BlocProvider.value(
//                             // pass existing gatepass delete bloc into the sheet subtree
//                             value: parentContext.read<DeleteGatePassBloc>(),
//                             child: OnDelete(
//                               title1: 'Delete Gate Pass',
//                               title2:
//                               'Are you sure you want to delete this gate pass?',
//                               onCancel: () {
//                                 Navigator.of(sheetContext).pop();
//                               },
//                               onConfirm: () {
//                                 // Save last removed item + index for rollback
//                                 _lastRemovedIndex = _allItems.indexWhere(
//                                         (e) => e.gatepass_id == i.gatepass_id);
//                                 if (_lastRemovedIndex == -1)
//                                   _lastRemovedIndex = null;
//                                 _lastRemovedItem = i;
//
//                                 // Optimistic local remove (so UI is snappy)
//                                 setState(() {
//                                   _allItems.removeWhere((element) =>
//                                   element.gatepass_id == i.gatepass_id);
//                                   _visibleItems.removeWhere((element) =>
//                                   element.gatepass_id == i.gatepass_id);
//                                 });
//
//                                 // Track pending deletes
//                                 _pendingDeletes.add('gatepass');
//                                 if (i.transfer_type == "warehouse_type") {
//                                   _pendingDeletes.add('warehouse');
//                                 } else {
//                                   _pendingDeletes.add('project');
//                                 }
//
//                                 // Dispatch delete events to provided blocs (they are provided at page level)
//                                 parentContext.read<DeleteGatePassBloc>().add(
//                                     SubmitDeleteGatePassEvent(
//                                         gatepass_id: i.gatepass_id ?? ""));
//                                 if (i.transfer_type == "warehouse_type") {
//                                   print(i.transfer_type);
//                                   print('''
//                                     from_warehouse_id: ${i.from_warehouse_id},
//                                     to_warehouse_id: ${i.to_warehouse_id},
//                                     issued_material: ${i.issued_material},
//                                     quantity: ${i.quantity},
//                                     ''');
//                                   parentContext
//                                       .read<DeleteGatePassWarehouseBloc>()
//                                       .add(
//                                     SubmitDeleteGatePassWarehouseEvent(
//                                       from_warehouse_id: i.from_warehouse_id,
//                                       to_warehouse_id: i.to_warehouse_id,
//                                       issued_material: i.issued_material,
//                                       quantity: i.quantity,
//                                     ),
//                                   );
//                                 } else {
//                                   print(i.transfer_type);
//                                   print('''
//                                   gate_pass: ${i.gate_pass},
//                                   from_warehouse_id: ${i.from_warehouse_id},
//                                   to_project_id: ${i.to_project_id},
//                                   issued_material: ${i.issued_material},
//                                   quantity: ${i.quantity},
//                                   out_time: ${i.out_time},
//                                   consumed: ${i.consumed},
//                                   date: ${i.date},
//                                     ''');
//                                   parentContext
//                                       .read<DeleteGatePassProjectBloc>()
//                                       .add(
//                                     SubmitDeleteGatePassProjectEvent(
//                                         gate_pass: i.gate_pass,
//                                         from_warehouse_id: i.from_warehouse_id,
//                                         to_project_name: i.to_project_id,
//                                         issued_material: i.issued_material,
//                                         quantity: i.quantity,
//                                         out_time: i.out_time,
//                                         consumed: i.consumed,
//                                         date: i.date
//                                     ),
//                                   );
//                                 }
//                                 Navigator.of(sheetContext).pop();
//                               },
//                             ),
//                           );
//                         },
//                       );
//                     },
//                     child: const Icon(Icons.close, color: Colors.grey, size: 15)
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget values(String title, String val) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         children: [
//           Text(
//             title,
//             style: GoogleFonts.poppins(
//               fontSize: 10,
//               color: Colors.black.withOpacity(.6),
//             ),
//           ),
//           Text(
//             val,
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               color: Colors.black.withOpacity(.6),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _applyDateFilterAndReload() {
//     dateFrom = _selectedFromDate != null
//         ? DateFormat('yyyy-MM-dd').format(_selectedFromDate!)
//         : "";
//     dateTo = _selectedToDate != null
//         ? DateFormat('yyyy-MM-dd').format(_selectedToDate!)
//         : "";
//
//     _hasMore = true;
//     _allItems.clear();
//     _visibleItems.clear();
//     _error = null;
//
//     if (mounted) setState(() {});
//
//     _loadPage(start: 0);
//   }
//
//   void _applyFiltersAndReload() {
//     if (selectedTransfer == "Warehouse Type") {
//       transferSelected = "warehouse_type";
//     } else {
//       transferSelected = "project_type";
//     }
//     _hasMore = true;
//     _allItems.clear();
//     _visibleItems.clear();
//     _error = null;
//
//     if (mounted) setState(() {});
//     _loadPage(start: 0);
//   }
//
//   Future<void> _pickFromDate() async {
//     DateTime initial = _selectedFromDate ?? DateTime.now();
//     final date = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(DateTime.now().year + 5),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             dividerColor: Colors.grey.withOpacity(.6),
//             colorScheme: ColorScheme.light(
//               primary: ColorConstants.primary,
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//             textTheme: const TextTheme(
//               titleLarge: TextStyle(
//                 color: ColorConstants.primary,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             datePickerTheme: DatePickerThemeData(
//               dividerColor: Colors.grey.withOpacity(.6),
//               dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
//                 if (states.contains(MaterialState.selected)) {
//                   return ColorConstants.primary;
//                 }
//                 return null;
//               }),
//               dayForegroundColor: MaterialStateProperty.resolveWith((states) {
//                 if (states.contains(MaterialState.selected)) {
//                   return Colors.white;
//                 }
//                 return Colors.black;
//               }),
//               dayShape: MaterialStateProperty.resolveWith((states) {
//                 if (states.contains(MaterialState.selected)) {
//                   return RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     side: const BorderSide(color: Colors.white, width: 2),
//                   );
//                 }
//                 return RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 );
//               }),
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: ColorConstants.primary,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (date != null) {
//       setState(() {
//         _selectedFromDate = date;
//         if (_selectedToDate == null ||
//             _selectedToDate!.isBefore(_selectedFromDate!)) {
//           _selectedToDate = _selectedFromDate;
//         }
//       });
//
//       _applyDateFilterAndReload();
//     }
//   }
//
//   Future<void> _pickToDate() async {
//     DateTime initial = _selectedToDate ?? (_selectedFromDate ?? DateTime.now());
//     final date = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: _selectedFromDate ?? DateTime(2000),
//       lastDate: DateTime(DateTime.now().year + 5),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             dividerColor: Colors.grey.withOpacity(.6),
//             colorScheme: ColorScheme.light(
//               primary: ColorConstants.primary,
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//             textTheme: const TextTheme(
//               titleLarge: TextStyle(
//                 color: ColorConstants.primary,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             datePickerTheme: DatePickerThemeData(
//               dividerColor: Colors.grey.withOpacity(.6),
//               dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
//                 if (states.contains(MaterialState.selected)) {
//                   return ColorConstants.primary;
//                 }
//                 return null;
//               }),
//               dayForegroundColor: MaterialStateProperty.resolveWith((states) {
//                 if (states.contains(MaterialState.selected)) {
//                   return Colors.white;
//                 }
//                 return Colors.black;
//               }),
//               dayShape: MaterialStateProperty.resolveWith((states) {
//                 if (states.contains(MaterialState.selected)) {
//                   return RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     side: const BorderSide(color: Colors.white, width: 2),
//                   );
//                 }
//                 return RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 );
//               }),
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: ColorConstants.primary,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (date != null) {
//       setState(() {
//         _selectedToDate = date;
//         if (_selectedFromDate == null ||
//             _selectedFromDate!.isAfter(_selectedToDate!)) {
//           _selectedFromDate = _selectedToDate;
//         }
//       });
//
//       _applyDateFilterAndReload();
//     }
//   }
//
// }

