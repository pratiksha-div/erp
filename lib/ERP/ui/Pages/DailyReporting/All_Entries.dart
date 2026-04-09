// import 'dart:async';
// import 'package:erp/ERP/UI/Widgets/Custom_appbar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sizer/sizer.dart';
// import '../../../api/models/DAOGetNewEntries.dart';
// import '../../../api/services/add_new_entry.dart';
// import '../../../bloc/DailyReporting/delete_new_entry_bloc.dart';
// import '../../../bloc/DailyReporting/get_new_entry_bloc.dart';
// import '../../Utils/utils.dart';
// import '../../Widgets/Bottom_Sheet.dart';
// import '../../Widgets/Date_Formate.dart';
// import '../../Widgets/TextWidgets.dart';
// import '../../Utils/colors_constants.dart';
// import 'Add_New_Report.dart';
//
// class AllEntries extends StatefulWidget {
//   const AllEntries({super.key});
//
//   @override
//   State<AllEntries> createState() => _AllEntriesState();
// }
//
// class _AllEntriesState extends State<AllEntries> {
//   final TextEditingController searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//
//   // paging
//   static const int _pageSize = 10;
//   bool _isLoadingMore = false;
//   bool _hasMore = true;
//   bool _isInitialLoading = false;
//   String? _error;
//
//   // data
//   final List<NewEntryData> _allItems = []; // master list accumulated from pages
//   final List<NewEntryData> _visibleItems = []; // filtered by search
//
//   late final NewEntryBloc _entryBloc;
//
//   Timer? _debounce;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // create service + bloc (or obtain from parent provider)
//     final service = NewEntryService();
//     _entryBloc = NewEntryBloc(service: service);
//     // load first page
//     _loadPage(start: 0);
//     // infinite scroll listener
//     _scrollController.addListener(_onScroll);
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
//     if ((start == 0 && _isInitialLoading) || (start > 0 && _isLoadingMore)) return;
//     if (start == 0) {
//       if (!mounted) return;
//       setState(() { _isInitialLoading = true; _error = null; });
//     } else {
//       if (!mounted) return;
//       setState(() { _isLoadingMore = true; });
//     }
//     _entryBloc.add(FetchNewEntrysEvent(start: start, length: _pageSize));
//   }
//
//   Future<void> _onRefresh() async {
//     _hasMore = true;
//     _allItems.clear();
//     _visibleItems.clear();
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
//     _entryBloc.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<NewEntryBloc>.value(
//       value: _entryBloc,
//       child: Scaffold(
//         backgroundColor: ColorConstants.background,
//         body: SafeArea(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomAppbar(context, title: "Material Consumption", subTitle: "Smart, fast, and secure gate entry"),
//                 Expanded(
//                   child: BlocListener<NewEntryBloc, NewEntryState>(
//                     listener: (context, state) {
//                       if (state is NewEntryLoadSuccess) {
//                         // Append new items
//                         final newItems = state.NewEntry;
//                         setState(() {
//                           if (_allItems.isEmpty) {
//                             _allItems.addAll(newItems);
//                           } else {
//                             _allItems.addAll(newItems);
//                           }
//
//                           // update visible list depending on search query
//                           final q = searchController.text.trim().toLowerCase();
//                           if (q.isEmpty) {
//                             _visibleItems
//                               ..clear()
//                               ..addAll(_allItems);
//                           } else {
//                             _visibleItems
//                               ..clear()
//                               ..addAll(_allItems.where((p) {
//                                 final name = (p.projectname ?? '').toLowerCase();
//                                 final cust = (p.employeename ?? '').toLowerCase();
//                                 final type = (p.lookupvalue ?? '').toLowerCase();
//                                 return name.contains(q) || cust.contains(q) || type.contains(q);
//                               }));
//                           }
//
//                           _isInitialLoading = false;
//                           _isLoadingMore = false;
//
//                           // if less than page size returned, no more pages
//                           if (newItems.length < _pageSize) _hasMore = false;
//                         });
//                       } else if (state is NewEntryLoadFailure) {
//                         setState(() {
//                           _isInitialLoading = false;
//                           _isLoadingMore = false;
//                           _error = state.message;
//                         });
//                       }
//                     },
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
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//       margin: const EdgeInsets.only(top: 10,),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(width: 1, color: Colors.grey.withOpacity(.3)),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Text(
//                 "TOTAL ENTRIES:",
//                 style: txt_bold(color: ColorConstants.primary, textSize: 14),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 "${_allItems.length}",
//                 style: txt_bold(color: Colors.black, textSize: 22),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 "available",
//                 style: txt_bold(color: Colors.grey, textSize: 12),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Row(
//             children: [
//               InkWell(
//                 onTap: () async {
//                   final result = await Utils.navigateTo(
//                     context,
//                     AddNewEntry(id:""),
//                   );
//                   if(result == "true")
//                   {
//                     print('Project added successfully');
//                     _onRefresh();
//                   }
//                 },
//                 child: Container(
//                   width: 80.w,
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   decoration: ShapeDecoration(
//                     shape: ContinuousRectangleBorder(
//                         side: BorderSide(
//                             color:  ColorConstants.primary
//                         ),
//                         borderRadius: BorderRadius.circular(30)
//                     ),
//                     // color: ColorConstants.primary,
//                     gradient: LinearGradient(
//                       colors: [
//                         ColorConstants.primary,
//                         ColorConstants.secondary,
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.topCenter,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Add New Entry",
//                         style: txt_bold(color: Colors.black, textSize: 12),
//                       ),
//                       // const Icon(Icons.add, size: 18, color: Colors.black),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//
//     if (_isInitialLoading && _allItems.isEmpty) {
//       return ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: [
//           const SizedBox(height: 30),
//           const Center(
//             child: CircularProgressIndicator(color: ColorConstants.primary),
//           ),
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
//                     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                     decoration: BoxDecoration(
//                       border: Border.all(width: 1, color: ColorConstants.primary),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Center(child: cText("Retry", color: ColorConstants.primary)),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       );
//     }
//
//     // total items in list view:
//     final int extra = 2 + (_hasMore ? 1 : 0); // header + spacer + optional load-more
//     final int totalCount = _visibleItems.length + extra;
//
//     return ListView.separated(
//       controller: _scrollController,
//       itemCount: totalCount,
//       separatorBuilder: (_, __) => const SizedBox(height: 8),
//       itemBuilder: (context, index) {
//         // HEADER (index 0)
//         if (index == 0) {
//           return header;
//         }
//         if (index == 1) {
//           return const SizedBox(height: 10);
//         }
//         if (index == 0) {
//           // Replace with your actual header widget (search bar / filters / etc.)
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 20,
//                 ),
//                 // example header
//                 Text(
//                   "Add new gate entry for project sites",
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 // add your search/filter widgets here if any
//               ],
//             ),
//           );
//         }
//
//         // data items start at index 2 -> map to _visibleItems[ index - 2 ]
//         final dataIndex = index - 2;
//
//         if (dataIndex < _visibleItems.length && dataIndex >= 0) {
//           final i = _visibleItems[dataIndex];
//           return _buildProjectCard(i);
//         }
//
//         // If we reach here, this must be the "load more" indicator (when _hasMore is true)
//         if (_hasMore && dataIndex == _visibleItems.length) {
//           if (!_isLoadingMore) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (!mounted) return;
//               if (!_isLoadingMore) _loadPage(start: _allItems.length);
//             });
//           }
//           return const Padding(
//             padding: EdgeInsets.symmetric(vertical: 16),
//             child: Center(child: CircularProgressIndicator(color: ColorConstants.primary)),
//           );
//         }
//
//         // fallback (shouldn't happen), return empty container
//         return const SizedBox.shrink();
//       },
//     );
//   }
//
//
//   Widget _buildProjectCard(NewEntryData i) {
//     // Check if all important fields are empty
//     bool allEmpty = (i.entryDate == null || i.entryDate.toString().trim().isEmpty) &&
//         ((i.lookupvalue ?? '').trim().isEmpty) &&
//         ((i.projectname ?? '').trim().isEmpty) &&
//         ((i.employeename ?? '').trim().isEmpty) &&
//         ((i.notes ?? '').trim().isEmpty);
//
//     // If everything is empty, return an empty SizedBox (hide the card)
//     if (allEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     final value = (i.lookupvalue ?? '').toLowerCase();
//     Color bg = ColorConstants.primary.withOpacity(.2);
//     Color fg = ColorConstants.primary;
//
//     if (value == 'permanent employee') {
//       bg = Colors.green.withOpacity(.2);
//       fg = Colors.green;
//     } else if (value == 'contractor') {
//       bg = ColorConstants.lightBlueColor.withOpacity(.2);
//       fg = ColorConstants.lightBlueColor;
//     }
//
//
//     return InkWell(
//       highlightColor: Colors.transparent,
//       splashColor: Colors.transparent,
//       onTap: () async {
//         final result = await Utils.navigateTo(
//           context,
//           AddNewEntry(id:i.work_detail_id??""),
//         );
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
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   height: 30,
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
//                 const SizedBox(width: 5),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if ((i.employeename ?? '').trim().isNotEmpty)
//                       Text(
//                         i.employeename.toString().toLowerCase() ?? '',
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     if ((i.projectname ?? '').trim().isNotEmpty)
//                       Container(
//                         width: 30.w,
//                         child: Text(
//                           i.projectname ?? '',
//                           style: GoogleFonts.poppins(
//                             fontSize: 13,
//                             height: 1,
//                             // color: ColorConstants.primary,
//                             color: Colors.black.withOpacity(.6),
//                             // fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 const Expanded(child: SizedBox()),
//                 if ((i.lookupvalue ?? '').trim().isNotEmpty)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       border: Border.all(width: 1, color: bg),
//                       color: bg,
//                     ),
//                     child: Text(
//                       i.lookupvalue,
//                       style: GoogleFonts.poppins(
//                         fontSize: 10,
//                         color: fg,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   )
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Row(
//               // mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 if (i.entryDate.toString().isNotEmpty)
//                   ...[  Text(
//                     "Entry Date: ",
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       color: Colors.black.withOpacity(.6),
//                     ),
//                   ),
//                     Text(
//                       formatEntryDate(i.entryDate ?? DateTime.now().toString()),
//                       style: GoogleFonts.poppins(
//                         fontSize: 12,
//                         color: ColorConstants.primary,
//                         // color: Colors.black.withOpacity(.6),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),],
//                 Expanded(child: Text("")),
//                 const Icon(Icons.edit, color: Colors.grey, size: 15),
//                 const SizedBox(width: 20),
//                 Container(
//                   height: 10,
//                   width: 1,
//                   color: Colors.grey.withOpacity(.6),
//                 ),
//                 const SizedBox(width: 20),
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
//                             // pass existing bloc instance into the sheet subtree
//                             value: parentContext.read<DeleteNewEntryBloc>(),
//                             child: OnDelete(
//                               title1: 'Delete Entry',
//                               title2: 'Are you sure you want to delete this entry?',
//                               onCancel: (){
//                                 Navigator.of(sheetContext).pop();
//                               },
//                               onConfirm: () {
//                                 // use parentContext (provider exists there). Close the sheet after dispatch.
//                                 parentContext
//                                     .read<DeleteNewEntryBloc>()
//                                     .add(SubmitDeleteNewEntryEvent(work_detail_id: i.work_detail_id??""));
//                                 // optionally close the bottom sheet immediately:
//                                 Navigator.of(sheetContext).pop();
//                                 _onRefresh();
//                               },
//                             ),
//                           );
//                         },
//                       );
//                     },
//                     child: const Icon(Icons.close, color: Colors.grey, size: 15)
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget values(String title,String val)
//   {
//     return  Container(
//       padding: EdgeInsets.symmetric(horizontal: 10),
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
// }
