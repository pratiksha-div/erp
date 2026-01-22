
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../api/models/DAOGetNewEntries.dart';
import '../../../api/services/add_new_entry.dart';
import '../../../bloc/DailyReporting/delete_new_entry_bloc.dart';
import '../../../bloc/DailyReporting/get_new_entry_bloc.dart';
import '../../Utils/utils.dart';
import '../../Widgets/Bottom_Sheet.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/Date_Formate.dart';
import '../../Widgets/TextWidgets.dart';
import '../../Utils/colors_constants.dart';
import 'Add_New_Entry.dart';

class NewEntry extends StatefulWidget {
  const NewEntry({super.key});

  @override
  State<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  final ScrollController _scrollController = ScrollController();

  static const int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _isInitialLoading = false;
  bool _hasMore = true;
  String? _errorMessage;
  final List<NewEntryData> _items = [];
  late final NewEntryBloc _newEntryBloc;
  late final DeleteNewEntryBloc _deleteNewEntryBloc;
  NewEntryData? _lastRemovedItem;

  @override
  void initState() {
    super.initState();
    _newEntryBloc = NewEntryBloc(service: NewEntryService());
    _deleteNewEntryBloc = DeleteNewEntryBloc();
    _loadInitialPage();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadMoreData();
      }
    });
  }

  void _loadInitialPage() {
    setState(() {
      _isInitialLoading = true;
      _errorMessage = null;
    });
    _newEntryBloc.add(FetchNewEntrysEvent(start: 0, length: _pageSize));
  }

  void _loadMoreData() {
    setState(() => _isLoadingMore = true);
    _newEntryBloc.add(FetchNewEntrysEvent(start: _items.length, length: _pageSize));
  }

  Future<void> _onRefresh() async {
    setState(() {
      _items.clear();
      _hasMore = true;
      _isInitialLoading = true; // show loader during refresh
      _errorMessage = null;
    });
    _newEntryBloc.add(FetchNewEntrysEvent(start: 0, length: _pageSize));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _deleteNewEntryBloc.close();
    _newEntryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide both bloc instances here so listeners below can hear them.
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewEntryBloc>.value(value: _newEntryBloc),
        BlocProvider<DeleteNewEntryBloc>.value(value: _deleteNewEntryBloc),
      ],
      child: Scaffold(
        backgroundColor: ColorConstants.background,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: MultiBlocListener(
              listeners: [
                // LISTENER: NewEntry loads
                BlocListener<NewEntryBloc, NewEntryState>(
                  listener: (context, state) {
                    debugPrint('NewEntryBloc -> ${state.runtimeType}');
                    if (state is NewEntryLoadSuccess) {
                      final fetched = state.newEntry;

                      setState(() {
                        // If we're in initial loading state (refresh or first load),
                        // replace the list to avoid duplicates; otherwise append for pagination.
                        if (_isInitialLoading) {
                          _items.clear();
                        }
                        _items.addAll(fetched);

                        if (fetched.length < _pageSize) _hasMore = false;
                        _isInitialLoading = false;
                        _isLoadingMore = false;
                      });
                    } else if (state is NewEntryLoadFailure) {
                      setState(() {
                        _isInitialLoading = false;
                        _isLoadingMore = false;
                        _errorMessage = state.message;
                      });
                    }
                  },
                ),
                // LISTENER: DeleteNewEntry
                BlocListener<DeleteNewEntryBloc, DeleteNewEntryState>(
                  listener: (context, state) {
                    debugPrint('DeleteNewEntryBloc -> ${state.runtimeType}');
                    if (state is DeleteNewEntrySuccess) {
                      Fluttertoast.showToast(
                        msg:'Entry Deleted',
                      );
                      _lastRemovedItem = null;
                      _onRefresh();
                    }
                    else if (state is DeleteNewEntryFailed) {
                      if (_lastRemovedItem != null) {
                        setState(() {
                          _items.insert(0, _lastRemovedItem!);
                        });
                      }
                      Fluttertoast.showToast(msg: state.message);
                    }

                  },
                ),
              ],
              // UI body
              child: Column(
                children: [
                  CustomAppbar(
                    context,
                    title: "New Entry List",
                    subTitle: "Smart, fast, and secure gate entry",
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: ColorConstants.primary,
                      backgroundColor: Colors.white,
                      child: _buildBody(), // your ListView builder
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [

        _buildHeader(),

        if (_isInitialLoading)
          const SizedBox(height: 200),
        if (_isInitialLoading)
          const Center(
            child: CircularProgressIndicator(color: ColorConstants.primary),
          ),

        if (_errorMessage != null && _items.isEmpty)
          Center(
            child: Column(
              children: [
                Text("Error: $_errorMessage"),
                TextButton(
                  onPressed: _loadInitialPage,
                  child: const Text("Retry"),
                )
              ],
            ),
          ),

        ..._items.map((item) => _buildItemCard(item)).toList(),

        if (_isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(color: ColorConstants.primary),
            ),
          ),

        if (!_isInitialLoading &&
            _errorMessage == null &&
            _items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Column(
                children: [
                  // Container(
                  //   padding:EdgeInsets.all(20),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(50),
                  //     color: ColorConstants.primary.withOpacity(.1)
                  //   ),
                  //     child: Icon(Icons.close,size: 18,color: ColorConstants.primary.withOpacity(.6),)
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Text(
                    'No records found\nPlease add new entry',
                     textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: ColorConstants.primary.withOpacity(.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              final result = await Utils.navigateTo(context, AddNewEntry(id: ""));
              if (result == "true") _onRefresh();
            },
            child: Container(
              width: 80.w,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: ShapeDecoration(
                shape: ContinuousRectangleBorder(
                    side: BorderSide(color: ColorConstants.primary),
                    borderRadius: BorderRadius.circular(30)),
                gradient: LinearGradient(
                  colors: [ColorConstants.primary, ColorConstants.secondary],
                ),
              ),
              child: Center(
                child: Text(
                  "Add New Entry",
                  style: txt_bold(color: Colors.black, textSize: 12),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemCard(NewEntryData i) {
    Color bg = ColorConstants.primary.withOpacity(.2);
    Color fg = ColorConstants.primary;

    final type = (i.lookupvalue ?? '').toLowerCase();

    if (type == "permanent employee") {
      bg =ColorConstants.green.withOpacity(.2);
      fg = ColorConstants.green;
    } else if (type == "contractor") {
      bg = ColorConstants.lightBlueColor.withOpacity(.2);
      fg = ColorConstants.lightBlueColor;
    }

    return InkWell(
      onTap: () async {
        final result = await Utils.navigateTo(
          context,
          AddNewEntry(id: i.work_detail_id ?? ""),
        );
        if (result == "true") _onRefresh();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(.9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((i.lookupvalue ?? '').isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: bg),
                    ),
                    child: Text(
                      i.lookupvalue ?? "",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: fg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  height: 30,
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        ColorConstants.primary,
                        ColorConstants.secondary,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (i.lookupvalue=="Permanent Employee" && (i.employeename ?? '').isNotEmpty)
                      Text(
                        i.employeename ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (i.lookupvalue=="Contractor" &&(i.empName ?? '').isNotEmpty)
                      Text(
                        i.empName ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if ((i.projectname ?? '').isNotEmpty)
                      SizedBox(
                        width: 200,
                        child: Text(
                          i.projectname ?? "",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black.withOpacity(.6),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            if ((i.notes ?? '').isNotEmpty)
              ...[
                cText(i.notes,color: Colors.black54),
              ],
            Row(
              children: [
                if(i.entryDate.toString().isNotEmpty)
                  ...[
                    Text("Entry Date: ",
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.black.withOpacity(.6))),
                    Text(
                      formatEntryDate(i.entryDate ?? ""),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: ColorConstants.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),],
                Expanded(child: Container()),
                const Icon(Icons.edit, size: 15, color: Colors.grey),
                const SizedBox(width: 20),
                Container(height: 10, width: 1, color: Colors.grey),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    final parentContext = context;
                    showModalBottomSheet(
                      context: parentContext,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.black.withOpacity(0.6),
                      builder: (sheetContext) {
                        return OnDelete(
                          title1: 'Delete Gate Entry',
                          title2: 'Are you sure you want to delete this entry?',
                          onCancel: () {
                            Navigator.of(sheetContext).pop();
                          },
                          onConfirm: () {
                            _lastRemovedItem = i;
                            setState(() {
                              _items.removeWhere((element) => element.work_detail_id == (i.work_detail_id ?? ""));
                            });
                            parentContext.read<DeleteNewEntryBloc>().add(
                              SubmitDeleteNewEntryEvent(work_detail_id: i.work_detail_id ?? ""),
                            );
                            Navigator.of(sheetContext).pop();
                          },
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.close,
                      size: 15, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
