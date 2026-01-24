import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api/models/DAOGetGENumber.dart';
import '../../../api/models/DAOGetGRN.dart';
import '../../../api/services/add_goods_received_notes_service.dart';
import '../../../bloc/DropDownValueBloc/gate_entry_number_bloc.dart';
import '../../../bloc/GoodsReceivedNotesBloc/add_goods_received_notes_bloc.dart';
import '../../../bloc/GoodsReceivedNotesBloc/delete_grn_bloc.dart';
import '../../../bloc/GoodsReceivedNotesBloc/goods_received_notes_bloc.dart';
import '../../../bloc/GoodsReceivedNotesBloc/grn_download.dart';
import '../../Utils/date_picker.dart';
import '../../Utils/utils.dart';
import '../../Widgets/Bottom_Sheet.dart';
import '../../Widgets/Custom_Date_Time_Picker.dart';
import '../../Widgets/Custom_Dropdown.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/Date_Formate.dart';
import '../../Widgets/TextWidgets.dart';
import '../../Utils/colors_constants.dart';
import 'AddGoodsReceivedNotes.dart';

class GoodsReceivedNotesPage extends StatefulWidget {
  const GoodsReceivedNotesPage({super.key});

  @override
  State<GoodsReceivedNotesPage> createState() => _GoodsReceivedNotesPageState();
}

class _GoodsReceivedNotesPageState extends State<GoodsReceivedNotesPage> {
  final ScrollController _scrollController = ScrollController();

  static const int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _isInitialLoading = false;
  bool _hasMore = true;
  String? _errorMessage;
  final List<GRNData> _items = [];
  final List<GRNData> _visibleItems = [];
  late final GoodsReceivedNotesBloc _GoodsReceivedNotesPageBloc;
  TextEditingController searchController = TextEditingController();
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  String? selectedEntryId;
  String dateFrom = "";
  String dateTo = "";

  @override
  void initState() {
    super.initState();
    _GoodsReceivedNotesPageBloc = GoodsReceivedNotesBloc(
      service: GoodsReceivedNotesService(),
    );
    _loadInitialPage();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadMoreData();
      }
    });
    context.read<GateEntryNumberBloc>().add(FetchGateEntryNumbersEvent());
  }

  void _loadInitialPage() {
    setState(() {
      _isInitialLoading = true;
      _errorMessage = null;
    });
    _GoodsReceivedNotesPageBloc.add(
      FetchGoodsReceivedNotesEvent(
        start: 0,
        length: _pageSize,
        from: '',
        to: '',
        grn_no: '',
        gate_entry_no: '',
        vehicle_no: '',
      ),
    );
  }

  void _loadMoreData() {
    if (_isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);

    _GoodsReceivedNotesPageBloc.add(
      FetchGoodsReceivedNotesEvent(
        start: _items.length,
        length: _pageSize,
        from: dateFrom,
        to: dateTo,
        grn_no: searchController.text,
        gate_entry_no: selectedEntryId ?? "",
        vehicle_no: searchController.text,
      ),
    );
  }

  Future<void> _onRefresh() async {
    dateFrom = "";
    dateTo = "";
    _selectedFromDate = null;
    _selectedToDate = null;
    searchController.clear();
    selectedEntryId = "";

    _hasMore = true;
    _items.clear();
    _visibleItems.clear();

    if (mounted) {
      setState(() {
        _isInitialLoading = true;
        _errorMessage = null;
      });
    }

    _GoodsReceivedNotesPageBloc.add(
      FetchGoodsReceivedNotesEvent(
        start: 0,
        length: _pageSize,
        from: '',
        to: '',
        grn_no: '',
        gate_entry_no: '',
        vehicle_no: '',
      ),
    );
  }

  Future<void> _loadPage({required int start}) async {
    if ((start == 0 && _isInitialLoading) || (start > 0 && _isLoadingMore))
      return;
    if (start == 0) {
      if (!mounted) return;
      setState(() {
        _isInitialLoading = true;
        _errorMessage = null;
      });
    } else {
      if (!mounted) return;
      setState(() {
        _isLoadingMore = true;
      });
    }
    print("Loading...");
    _GoodsReceivedNotesPageBloc.add(
      FetchGoodsReceivedNotesEvent(
        start: 0,
        length: _pageSize,
        from: dateFrom,
        to: dateTo,
        grn_no: searchController.text,
        gate_entry_no: selectedEntryId ?? "",
        vehicle_no: searchController.text,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _GoodsReceivedNotesPageBloc.close();
    super.dispose();
  }

  Future<void> _pickFromDate() async {
    final date = await showAppDatePicker(
      context: context,
      initialDate: _selectedFromDate,
    );

    if (date != null) {
      setState(() {
        _selectedFromDate = date;

        if (_selectedToDate == null ||
            _selectedToDate!.isBefore(_selectedFromDate!)) {
          _selectedToDate = _selectedFromDate;
        }
      });

      _applyFiltersAndReload();
    }
  }

  Future<void> _pickToDate() async {
    DateTime initial = _selectedToDate ?? (_selectedFromDate ?? DateTime.now());
    final date = await showAppDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _selectedFromDate ?? DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (date != null) {
      setState(() {
        _selectedToDate = date;
        if (_selectedFromDate == null ||
            _selectedFromDate!.isAfter(_selectedToDate!)) {
          _selectedFromDate = _selectedToDate;
        }
      });
      _applyFiltersAndReload();
    }
  }

  void _applyFiltersAndReload() {
    dateFrom =
        _selectedFromDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedFromDate!)
            : "";
    dateTo =
        _selectedToDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedToDate!)
            : "";

    _hasMore = true;
    _items.clear();
    _visibleItems.clear();

    if (mounted) setState(() {});
    _loadPage(start: 0);
  }

  Future<void> downloadFile(String downloadUrl) async {
    final Uri url = Uri.parse(downloadUrl);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch browser');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provide both bloc instances here so listeners below can hear them.
    return MultiBlocProvider(
      providers: [
        BlocProvider<GoodsReceivedNotesBloc>.value(
          value: _GoodsReceivedNotesPageBloc,
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorConstants.background,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: MultiBlocListener(
              listeners: [
                BlocListener<GoodsReceivedNotesBloc, GoodsReceivedNotesState>(
                  listener: (context, state) {
                    debugPrint(
                      'GoodsReceivedNotesPageBloc -> ${state.runtimeType}',
                    );
                    if (state is GoodsReceivedNotesLoadSuccess) {
                      final fetched = state.GoodsReceivedNotes;
                      setState(() {
                        if (_isInitialLoading) {
                          _items.clear();
                        }
                        _items.addAll(fetched);
                        _visibleItems.addAll(fetched);
                        if (fetched.length < _pageSize) _hasMore = false;
                        _isInitialLoading = false;
                        _isLoadingMore = false;
                      });
                    } else if (state is GoodsReceivedNotesLoadFailure) {
                      setState(() {
                        _isInitialLoading = false;
                        _isLoadingMore = false;
                        _errorMessage = state.message;
                      });
                    }
                  },
                ),
              ],
              child: Column(
                children: [
                  CustomAppbar(
                    context,
                    title: "Goods Received Notes",
                    subTitle: "Verify all materials received at the site",
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
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: const Center(
              child: CircularProgressIndicator(color: ColorConstants.primary),
            ),
          ),

        if (_errorMessage != null && _items.isEmpty)
          Center(
            child: Column(
              children: [
                Text('Error: $_errorMessage'),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    _loadInitialPage();
                  },
                  child: Container(
                    // height: 20,
                    width: 40.w,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: ColorConstants.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: cText("Retry", color: ColorConstants.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // ..._items.map((item) => _buildItemCard(item)).toList(),
        ..._visibleItems.map((item) => _buildItemCard(item)).toList(),

        if (_isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(color: ColorConstants.primary),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 0,
                          ),
                          decoration: ShapeDecoration(
                            shape: ContinuousRectangleBorder(
                              side: BorderSide(
                                color: Colors.grey.withOpacity(.2),
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                // padding: const EdgeInsets.all(5),
                                child: Icon(
                                  FeatherIcons.search,
                                  color: ColorConstants.primary,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  cursorColor: ColorConstants.primary,
                                  decoration: const InputDecoration(
                                    hintText: "Search by grn number,vehicle no",
                                    hintStyle: TextStyle(fontSize: 13),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (v) {
                                    final q = v.trim().toLowerCase();
                                    setState(() {
                                      _visibleItems
                                        ..clear()
                                        ..addAll(
                                          _items.where((p) {
                                            final grnNo =
                                                (p.grn_no ?? '')
                                                    .toString()
                                                    .toLowerCase();
                                            final vehicleNo =
                                                (p.vehicle_no ?? '')
                                                    .toString()
                                                    .toLowerCase();
                                            return grnNo.contains(q) ||
                                                vehicleNo.contains(q);
                                          }),
                                        );
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () async {
                        final result = await Utils.navigateTo(
                          context,
                          AddGoodsReceivedNotes(grn_id: ''),
                        );
                        if (result == true) {
                          _onRefresh();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: ShapeDecoration(
                          shape: ContinuousRectangleBorder(
                            side: BorderSide(
                              color: Colors.grey.withOpacity(.2),
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: ColorConstants.primary,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "Select GRN Date Range",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black.withOpacity(.6),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomDateTimeTextField(
                        onTap: _pickFromDate,
                        showTitle: false,
                        hint:
                            _selectedFromDate == null
                                ? '-- From Date --'
                                : DateFormat(
                                  "d MMMM y",
                                ).format(_selectedFromDate!),
                        icon: Icons.calendar_month,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomDateTimeTextField(
                        onTap: _pickToDate,
                        showTitle: false,
                        hint:
                            _selectedToDate == null
                                ? '-- To Date --'
                                : DateFormat(
                                  "d MMMM y",
                                ).format(_selectedToDate!),
                        icon: Icons.calendar_month,
                      ),
                    ),
                  ],
                ),
                BlocBuilder<GateEntryNumberBloc, GateEntryNumberState>(
                  builder: (context, state) {
                    if (state is GateEntryNumberLoadSuccess) {
                      final selectedGEN = state.gateEntryNumbers.firstWhere(
                        (element) => element.gen_id == selectedEntryId,
                        orElse: () => GENumberData(gen_no: "", gen_id: ""),
                      );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TransferDropdown<GENumberData>(
                            title: 'Gate Entry Number',
                            hint: 'Select Gate Entry Number',
                            selectedVal:
                                selectedGEN.gen_no?.isNotEmpty == true
                                    ? selectedGEN.gen_no!
                                    : "",
                            data: state.gateEntryNumbers,
                            displayText: (data) => data.gen_no ?? '',
                            onChanged: (val) {
                              selectedEntryId = val.gen_id;
                              print("selectedEntryId ${selectedEntryId}");
                              _applyFiltersAndReload();
                            },
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(GRNData i) {
    Color bg = ColorConstants.primary.withOpacity(.2);
    Color fg = ColorConstants.primary;

    return InkWell(
      onTap: () async {
        final result = await Utils.navigateTo(
          context,
          AddGoodsReceivedNotes(grn_id: i.grn_id),
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
            Row(
              children: [
                Text(
                  "Requested by: ",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black.withOpacity(.6),
                  ),
                ),
                Text(
                  i.requested_by,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black.withOpacity(.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  i.grn_no ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: ColorConstants.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(child: Text("")),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1, color: bg),
                  ),
                  child: Text(
                    i.po_no ?? "",
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
            Container(
              width: 80.w,
              child: Row(
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
                      Text(
                        i.gen_no ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: 50.w,
                        child: Text(
                          (i.item_name ?? "").replaceAll(',', ', '),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Text("")),
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Icon(
                        Icons.remove_red_eye,
                        size: 15,
                        color: Colors.grey.withOpacity(.6),
                      ),
                      SizedBox(height: 5),
                      Container(height: 10, width: 1, color: Colors.grey),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          final parentContext = context;
                          showModalBottomSheet(
                            context: parentContext,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.black.withOpacity(0.6),
                            builder: (sheetContext) {
                              return BlocProvider.value(
                                value: parentContext.read<DeleteGRNBloc>(),
                                child: OnDelete(
                                  title1: 'Delete Goods Received Notes',
                                  title2:
                                      'Are you sure you want to delete this goods received notes?',
                                  onCancel: () {
                                    Navigator.of(sheetContext).pop();
                                  },
                                  onConfirm: () {
                                    // Dispatch delete; DO NOT call _onRefresh() here.
                                    parentContext.read<DeleteGRNBloc>().add(
                                      SubmitDeleteGRNEvent(
                                        grn_id: i.grn_id,
                                        accepted_qty: i.accepted_qty,
                                      ),
                                    );
                                    Navigator.of(sheetContext).pop();
                                    _onRefresh();
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(
                            Icons.close,
                            size: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Added on: ",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black.withOpacity(.6),
                          ),
                        ),
                        Text(
                          formatEntryDate(
                            i.grn_date ?? DateTime.now().toString(),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black.withOpacity(.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    BlocListener<GRNDownloadBloc, GRNDownloadState>(
                      listener: (context, state) async {
                        if (state is GRNDownloadSuccess) {
                          await downloadFile(state.downloadUrl);
                        }
                      },
                      child: InkWell(
                        onTap: () {
                          context.read<GRNDownloadBloc>().add(
                            SubmitGRNDownloadEvent(grn_id: i.grn_id),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            // color: ColorConstants.primary,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey.withOpacity(.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              cText(
                                "Download",
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.download_for_offline,
                                size: 15,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: Text("")),
                Column(
                  children: [
                    if (i.vehicle_no.isNotEmpty) ...[
                      Text(
                        i.vehicle_no ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "vehicle no",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black.withOpacity(.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
