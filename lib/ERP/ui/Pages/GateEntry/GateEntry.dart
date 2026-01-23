import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../api/models/DAOGetEmployee.dart';
import '../../../api/models/DAOGetGateEntry.dart';
import '../../../api/models/DAOGetPurchaseOrderDetail.dart';
import '../../../api/models/DAOGetWarehouse.dart';
import '../../../api/models/DAOPurchaseOrderNumber.dart';
import '../../../api/services/gate_entry_service.dart';
import '../../../bloc/DropDownValueBloc/emplyee_list_bloc.dart';
import '../../../bloc/DropDownValueBloc/purchase_order_number_bloc.dart';
import '../../../bloc/DropDownValueBloc/warehouse_list_bloc.dart';
import '../../../bloc/GateEntry/add_purchase_detail_bloc.dart';
import '../../../bloc/GateEntry/delete_gate_entry_bloc.dart';
import '../../../bloc/GateEntry/gate_entry_bloc.dart';
import '../../../bloc/GateEntry/gate_entry_by_id_bloc.dart';
import '../../../bloc/GateEntry/purchase_order_detail_bloc.dart';
import '../../Utils/colors_constants.dart';
import '../../Utils/date_picker.dart';
import '../../Widgets/Bottom_Sheet.dart';
import '../../Widgets/Cards.dart';
import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_Date_Time_Picker.dart';
import '../../Widgets/Custom_Dialog.dart';
import '../../Widgets/Custom_Dropdown.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/TextWidgets.dart';

class GateEntry extends StatefulWidget {
  const GateEntry({super.key});

  @override
  State<GateEntry> createState() => _GateEntryState();
}

class _GateEntryState extends State<GateEntry> {
  final TextEditingController purchaseOrder = TextEditingController();
  String selectedPO = "Select Purchase Order";
  bool _isSheetOpen = false;
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _isInitialLoading = false;
  bool _hasMore = true;
  String? _errorMessage;
  final List<GateEntryData> _items = [];
  late final GateEntryBloc _entryBloc;
  TextEditingController searchcontroller=TextEditingController();
  final List<GateEntryData> _visibleItems = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<WarehouseBloc>(context).add(FetchWarehouseEvent());
    BlocProvider.of<EmployeeBloc>(context).add(FetchEmployeesEvent());
    BlocProvider.of<PurchaseOrderNumberBloc>(context).add(FetchPurchaseOrderNumbersEvent());
    _entryBloc = GateEntryBloc(service: GateEntryService());
    _loadInitialPage();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
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
    _entryBloc.add(FetchGateEntryEvent(
        start: 0,
        length: _pageSize,
        gateEntry: '',
        vehicleNo: '',
        toWarehouse: '',
        orderedBy: '')
    );
  }

  void _loadMoreData() {
    setState(() => _isLoadingMore = true);
    _entryBloc.add(
      FetchGateEntryEvent(
          start: _items.length,
          length: _pageSize,
          gateEntry: '',
          vehicleNo: '',
          toWarehouse: '',
          orderedBy: ''),
    );
  }

  Future<void> _onRefresh() async {
    _items.clear();
    _visibleItems.clear();
    // _hasMore = true;
    setState(() {});
    _loadInitialPage();
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    _entryBloc.close();
    purchaseOrder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _entryBloc,
      child: Scaffold(
        backgroundColor: ColorConstants.background,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppbar(
                  context,
                  title: "Gate Entry",
                  subTitle: "Record the arrival of materials at the gate",
                ),
                SizedBox(height: 10),
                Expanded(
                  child: BlocListener<GateEntryBloc, GateEntryState>(
                    listener: (context, state) {
                      if (state is GateEntryLoadSuccess) {
                        final fetched = state.gateEntry;

                        setState(() {
                          if (_items.isEmpty) {
                            _items.addAll(fetched);
                          } else {
                            _items.addAll(fetched);
                          }
                          if (fetched.length < _pageSize) {
                            _hasMore = false;
                          }
                          _isInitialLoading = false;
                          _isLoadingMore = false;
                        });
                      }

                      if (state is GateEntryLoadFailure) {
                        setState(() {
                          _isInitialLoading = false;
                          _isLoadingMore = false;
                          _errorMessage = state.message;
                        });
                      }
                    },
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: ColorConstants.primary,
                      backgroundColor: Colors.white,
                      child: _buildBody(),
                    ),
                  ),
                ),
              ],
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
        SizedBox(height: 10),
        if (_isInitialLoading) const SizedBox(height: 200),
        if (_isInitialLoading)
          const Center(
            child: CircularProgressIndicator(color: ColorConstants.primary),
          ),
        if (_errorMessage != null && _items.isEmpty)
          Center(
            child: Column(
              children: [
                Text("Error: $_errorMessage"),
                InkWell(
                  onTap: () {
                    _loadInitialPage();
                  },
                  child: Container(
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

        ..._items.map((item) => _buildItemCard(item)).toList(),

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
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey.withOpacity(.3)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
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
                            controller: searchcontroller,
                            cursorColor: ColorConstants.primary,
                            decoration: const InputDecoration(
                              hintText: "Search by gate entry no,vehicle no",
                              hintStyle: TextStyle(fontSize: 13),
                              border: InputBorder.none,
                            ),
                            onChanged: (v) {
                              final q = v.trim().toLowerCase();
                              setState(() {
                                _items
                                  ..clear()
                                  ..addAll(
                                    _items.where((p) {
                                      final grnNo =
                                      (p.gen_no ?? '')
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
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.black.withOpacity(0.6),
                    builder: (sheetContext) {
                      return DraggableScrollableSheet(
                        initialChildSize: 0.5,
                        minChildSize: 0.3,
                        maxChildSize: 0.5,
                        expand: false,
                        builder: (context, scrollController) {
                          return ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Container(
                              color: Colors.white,
                              child: ShowFilter(
                                scrollController: scrollController,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
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
                    Icons.tune,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          BlocBuilder<PurchaseOrderNumberBloc, PurchaseOrderNumberState>(
            builder: (context, state) {
              if (state is PurchaseOrderNumberLoadSuccess) {
                final selectedProject = state.purchaseOrderNumbers.firstWhere(
                      (data) => data.purchase_order_number == selectedPO,
                  orElse:
                      () => PurchaseOrderNumberData(purchase_order_number: ""),
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TransferDropdown<PurchaseOrderNumberData>(
                      title: 'Purchase Order Number',
                      hint: 'Select Purchase Order Number',
                      selectedVal: selectedProject.purchase_order_number ?? "",
                      data: state.purchaseOrderNumbers,
                      displayText: (data) => data.purchase_order_number ?? '',
                      onChanged: (val) async {
                        if (_isSheetOpen) {
                          debugPrint(
                            'PurchaseOrderDetail sheet already open. Ignoring.',
                          );
                          return;
                        }

                        setState(() {
                          selectedPO = val.purchase_order_number ?? "";
                        });

                        _isSheetOpen = true;
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: Colors.black.withOpacity(0.6),
                          builder: (sheetContext) {
                            return DraggableScrollableSheet(
                              initialChildSize: 0.5,
                              minChildSize: 0.3,
                              maxChildSize: 0.8,
                              expand: false,
                              builder: (context, scrollController) {
                                return ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  child: Container(
                                    color: Colors.white,
                                    child: ListView(
                                      controller: scrollController,
                                      padding: EdgeInsets.only(
                                        bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom +
                                            16,
                                      ),
                                      children: [
                                        PurchaseOrderDetail(
                                          purchaseOrderNo:
                                          val.purchase_order_number ?? "",
                                          save: true,
                                          id: "",
                                          callback: () {
                                            setState(() {
                                              selectedPO = "";
                                              Navigator.of(context).pop();
                                              _onRefresh();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                        _isSheetOpen = false;
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
    );
  }

  Widget _buildItemCard(GateEntryData i) {
    return InkWell(
      onTap: () async {
        // final result = await Utils.navigateTo(
        //   context,
        //   AddNewEntry(id: i.work_detail_id ?? ""),
        // );
        // if (result == "true") _onRefresh();
      },
      child: Container(
        width: 90.w,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (i.challan_no.toString().isNotEmpty) ...[
                  Text(
                    "Challan number ",
                    style: GoogleFonts.poppins(
                      color: Colors.grey.withOpacity(0.95),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    i.challan_no,
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.95),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                if (i.bill_no.toString().isNotEmpty) ...[
                  Expanded(child: Text("")),
                  Text(
                    "Bill no ",
                    style: GoogleFonts.poppins(
                      height: 1,
                      color: Colors.grey.withOpacity(0.95),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    i.bill_no,
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.95),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
            Divider(color: Colors.grey.withOpacity(.1)),
            Row(
              children: [
                if (i.item_name.toString().isNotEmpty) ...[
                  Container(
                    width: 58.w,
                    // color: Colors.pink,
                    child: Text(
                      "${i.item_name} ",
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.95),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
                Expanded(child: Text("")),
                Text(
                  i.gen_no,
                  style: GoogleFonts.poppins(
                    height: 1,
                    color: Colors.grey.withOpacity(0.95),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (i.vehicle_no.toString().isNotEmpty) ...[
                  Text(
                    "Vehicle number: ",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height:1,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${i.vehicle_no}",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      height: 1,
                      color: Colors.black.withOpacity(.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  height: 25,
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
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (i.to_warehouse.toString().isNotEmpty)
                      Row(
                        children: [
                          Container(
                            width: 180,
                            child: Text(
                              "${i.to_warehouse}",
                              style: GoogleFonts.poppins(
                                height: 1,
                                color: ColorConstants.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (i.from_vendor.toString().isNotEmpty)
                      Row(
                        children: [
                          // Text(
                          //   "Vendor : ",
                          //   style: GoogleFonts.poppins(
                          //     height: 1,
                          //     color: Colors.black.withOpacity(0.6),
                          //     fontSize: 10,
                          //   ),
                          // ),
                          Text(
                            i.from_vendor,
                            style: GoogleFonts.poppins(
                              height: 1,
                              color: Colors.grey,
                              fontSize: 13,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
               if( i.selected_po.toString().isNotEmpty)
               ...[
                Expanded(child: Text("")),
                Column(
                  children: [
                    Text(
                      i.selected_po,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: ColorConstants.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "(Order no)",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
               ]
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text(
                //   "Ordered by: ",
                //   style: GoogleFonts.poppins(
                //     fontSize: 10,
                //     color: Colors.grey,
                //   ),
                // ),
                Container(
                  // width: 100,
                  child: Text(
                  i.ordered_by,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1,
                    color: Colors.black.withOpacity(.6),
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
                Expanded(child: Text("")),
                InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.black.withOpacity(0.6),
                      builder: (sheetContext) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.5,
                          minChildSize: 0.3,
                          maxChildSize: 0.8,
                          expand: false,
                          builder: (context, scrollController) {
                            return ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Container(
                                color: Colors.white,
                                child: ListView(
                                  controller: scrollController,
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom +
                                        16,
                                  ),
                                  children: [
                                    PurchaseOrderDetail(
                                      purchaseOrderNo: i.selected_po,
                                      id: i.gate_entry_id,
                                      save: true,
                                      callback: () {
                                        setState(() {
                                          selectedPO = "";
                                          Navigator.of(context).pop();
                                          _onRefresh();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.edit, color: Colors.grey, size: 15),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 10,
                  width: 1,
                  color: Colors.grey.withOpacity(.6),
                ),
                const SizedBox(width: 10),
                BlocListener<DeleteGateEntryBloc, DeleteGateEntryState>(
                  listener: (context, state) {
                    if (state is DeleteGateEntrySuccess) {
                      _onRefresh();
                    }
                  },
                  child: InkWell(
                    onTap: () {
                      final parentContext = context;
                      showModalBottomSheet(
                        context: parentContext,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        barrierColor: Colors.black.withOpacity(0.6),
                        builder: (sheetContext) {
                          return BlocProvider.value(
                            // pass existing bloc instance into the sheet subtree
                            value: parentContext.read<DeleteGateEntryBloc>(),
                            child: OnDelete(
                              title1: 'Delete Gate Entry',
                              title2:
                                  'Are you sure you want to delete this gate entry?',
                              onCancel: () {
                                Navigator.of(sheetContext).pop();
                              },
                              onConfirm: () {
                                setState(() {
                                  _items.removeWhere(
                                    (e) => e.gate_entry_id == i.gate_entry_id,
                                  );
                                });
                                parentContext.read<DeleteGateEntryBloc>().add(
                                  SubmitDeleteGateEntryEvent(
                                    gate_entry_id: i.gate_entry_id ?? "",
                                  ),
                                );
                                Navigator.of(sheetContext).pop();
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(Icons.close, color: Colors.grey, size: 15),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 10,
                  width: 1,
                  color: Colors.grey.withOpacity(.6),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.black.withOpacity(0.6),
                      builder: (sheetContext) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.5,
                          minChildSize: 0.3,
                          maxChildSize: 0.8,
                          expand: false,
                          builder: (context, scrollController) {
                            return ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Container(
                                color: Colors.white,
                                child: ListView(
                                  controller: scrollController,
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom +
                                        16,
                                  ),
                                  children: [
                                    PurchaseOrderDetail(
                                      purchaseOrderNo: i.selected_po,
                                      id: i.gate_entry_id,
                                      callback: () {
                                        setState(() {
                                          selectedPO = "";
                                          Navigator.of(context).pop();
                                          _onRefresh();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.visibility,
                    color: Colors.grey,
                    size: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PurchaseOrderDetail extends StatefulWidget {
  const PurchaseOrderDetail({
    super.key,
    required this.callback,
    required this.purchaseOrderNo,
    this.save = false,
    required this.id,
  });

  final VoidCallback callback;
  final String purchaseOrderNo;
  final bool save;
  final String id;

  @override
  State<PurchaseOrderDetail> createState() => _PurchaseOrderDetailState();
}

class _PurchaseOrderDetailState extends State<PurchaseOrderDetail> {
  TextEditingController challan_number = TextEditingController();
  TextEditingController vehicle_number = TextEditingController();
  TextEditingController bill_number = TextEditingController();
  DateTime? _selectedGateEntryDate;
  DateTime? _selectedBillDate;

  @override
  void initState() {
    super.initState();
    if (widget.id.isNotEmpty) {
      print("gate_entry_id ${widget.id}");
      BlocProvider.of<GateEntryBYIDBloc>(
        context,
      ).add(FetchGateEntryBYIDEvent(gate_entry_id: widget.id));
    }
      BlocProvider.of<PurchaseOrderDetailBloc>(
        context,
      ).add(FetchPurchaseOrderDetailEvent(poValue: widget.purchaseOrderNo));
  }

  Future<void> _pickEntryDate() async {
    DateTime initial = _selectedGateEntryDate ?? DateTime.now();
    final date = await showAppDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (date != null) {
      setState(() {
        _selectedGateEntryDate = date;
      });
      print("_selectedGateEntryDate ${_selectedGateEntryDate}");
    }
  }

  Future<void> _pickBillDate() async {
    DateTime initial = _selectedBillDate ?? DateTime.now();
    final date = await showAppDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (date != null) {
      setState(() {
        _selectedBillDate = date;
      });
    }
  }

  void setGateEntryDate(String inputDate) {
    if (inputDate.isEmpty) return;
    DateFormat inputFormat = DateFormat("MMMM, dd yyyy HH:mm:ss Z");
    DateTime parsedDate = inputFormat.parse(inputDate);
    // DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    // String formattedDate = outputFormat.format(parsedDate);
    _selectedGateEntryDate = parsedDate;
  }

  void setBillingDate(String inputDate) {
    if (inputDate.isEmpty) return;
    DateFormat inputFormat = DateFormat("MMMM, dd yyyy HH:mm:ss Z");
    DateTime parsedDate = inputFormat.parse(inputDate);
    // DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    // String formattedDate = outputFormat.format(parsedDate);
    _selectedBillDate = parsedDate;

  }


  void getDate(String inputDate) {
    if (inputDate.isEmpty) return;

    // Define the input format (the format of the incoming date string)
    DateFormat inputFormat = DateFormat("MMMM, dd yyyy HH:mm:ss Z");
    try {
      DateTime parsedDate = inputFormat.parse(inputDate);
      DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
      String formattedDate = outputFormat.format(parsedDate);
      print(formattedDate);
      _selectedGateEntryDate = parsedDate;
      _selectedBillDate = parsedDate;
    } catch (e) {
      print('Error parsing date: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddPurchaseDetailBloc, AddPurchaseDetailState>(
          listener: (context, state) {
            if (state is AddPurchaseDetailSuccess) {
              final generatedNumber = state.gen_no;
              print("Gen number ${state.gen_no}");
              showConfirmDialog(
                context: context,
                title: "Success",
                message: state.message,
                content: generatedNumber,
                confirmText: "Ok",
                callback: () {
                  widget.callback();
                  Navigator.of(context).pop(true);
                },
              );
            }
          },
        ),
        BlocListener<GateEntryBYIDBloc, GateEntryBYIDState>(
          listener: (context, state) {
            if (state is GateEntryBYIDLoadSuccess) {
               if(widget.id.isNotEmpty){
                 final data = state.gateEntryBYID.isNotEmpty
                     ? state.gateEntryBYID.first
                     : null;
                 if(data!=null){
                   setState(() {
                     challan_number.text=data.challan_no;
                     bill_number.text=data.bill_no;
                     vehicle_number.text=data.vehicle_no;
                     setGateEntryDate(data.gate_entry_date ?? "");
                     setBillingDate(data.bill_date ?? "");
                   });
                 }
               }

            }
          },
        ),
      ],
      child: BlocBuilder<PurchaseOrderDetailBloc, PurchaseOrderDetailState>(
        builder: (context, state) {
          if (state is PurchaseOrderDetailLoading) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.0),
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: ColorConstants.primary,
                ),
              ),
            );
          }
          // Failure
          if (state is PurchaseOrderDetailFailure) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.0),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Failed to load details",
                    style: GoogleFonts.poppins(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    title: "Retry",
                    onAction: () {
                      BlocProvider.of<PurchaseOrderDetailBloc>(context).add(
                        FetchPurchaseOrderDetailEvent(
                          poValue: widget.purchaseOrderNo,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    title: "Close",
                    onAction: () {
                      widget.callback();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          }
          // Success
          if (state is PurchaseOrderDetailLoadSuccess) {
            final List<PurchaseDetail> details =
                state.purchaseOrderDetail ?? [];
            if (details.isEmpty) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.0),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "No items found for ${widget.purchaseOrderNo}",
                      style: GoogleFonts.poppins(),
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      title: "Close",
                      onAction: () {
                        widget.callback();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            }
            final PurchaseDetail first = details.first;
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24.0),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Purchase Order Number Detail",
                      style: GoogleFonts.lalezar(
                        height: 1,
                        fontSize: 20,
                        color: ColorConstants.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    cText(
                      "Arrival of material at the gate",
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                    const SizedBox(height: 20),
                    // header rows
                    Row(
                      children: [
                        Expanded(
                          child: txtFiledCustom(
                            "Challan no",
                            "",
                            Icons.looks_one,
                            challan_number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: txtFiledCustom(
                            "Bill number",
                            "",
                            Icons.looks_two,
                            bill_number,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: txtFiledCustom(
                            "Vehicle no",
                            "",
                            Icons.looks_3,
                            vehicle_number,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomDateTimeTextField(
                          onTap: _pickEntryDate,
                          showTitle: true,
                          title: "Gate Entry Date",
                          hint: _selectedGateEntryDate == null
                                  ? '-- Date: --'
                                  : DateFormat(
                                    "d MMMM y",
                                  ).format(_selectedGateEntryDate!),
                          icon: Icons.calendar_month,
                        ),
                        SizedBox(width: 20),
                        CustomDateTimeTextField(
                          onTap: _pickBillDate,
                          showTitle: true,
                          title: "Billing Date",
                          hint: _selectedBillDate == null
                                  ? '-- Date: --'
                                  : DateFormat(
                                    "d MMMM y",
                                  ).format(_selectedBillDate!),
                          icon: Icons.calendar_month,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(.1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  cText(
                                    "Purchase Order",
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  Text(
                                    widget.purchaseOrderNo,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(child: Text("")),
                              Column(
                                children: [
                                  cText(
                                    "Ordered by",
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  Text(
                                    first.ordered_by ?? "-",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Divider(color: Colors.grey.withOpacity(.1)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Column(
                                children: [
                                  cText(
                                    "Vendor",
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    first.vendor_name ?? "-",
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(child: Text("")),
                              Column(
                                children: [
                                  cText(
                                    "To Warehouse",
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    first.to_warehouse ?? "-",
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Arrived materials and its quantity",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ColorConstants.primary.withOpacity(.1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Items",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: ColorConstants.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Quantity",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: ColorConstants.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Divider(
                            color: ColorConstants.primary.withOpacity(.1),
                          ),
                          const SizedBox(height: 12),
                          for (var row in details)
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Builder(
                                builder: (_) {
                                  final itemList = (row.item_name ?? '')
                                      .split(',');
                                  final quantityList = (row.quantity ?? '')
                                      .split(',');
                                  final poBalanceRaw = row.po_balance ?? '';
                                  final poBalanceList = poBalanceRaw.split(
                                    ',',
                                  );

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// LEFT: Item Names
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                            itemList.length,
                                            (i) {
                                              final poVal =
                                                  (i < poBalanceList.length)
                                                      ? poBalanceList[i]
                                                          .trim()
                                                      : '';

                                              /// RULE 2: If po_balance is "0" → hide row
                                              if (poVal == '0')
                                                return const SizedBox.shrink();

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                      bottom: 4,
                                                    ),
                                                child: Text(
                                                  itemList[i].trim(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      /// RIGHT: Quantity / PO Balance
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: List.generate(
                                          itemList.length,
                                          (i) {
                                            final poVal =
                                                (i < poBalanceList.length)
                                                    ? poBalanceList[i].trim()
                                                    : '';
                                            final qtyVal =
                                                (i < quantityList.length)
                                                    ? quantityList[i].trim()
                                                    : '';

                                            /// RULE 2: If po_balance is "0" → hide row
                                            if (poVal == '0')
                                              return const SizedBox.shrink();

                                            /// RULE 1 & 3
                                            final displayValue =
                                                poVal.isEmpty
                                                    ? qtyVal
                                                    : poVal;

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 4,
                                              ),
                                              child: Text(
                                                displayValue,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (widget.save)
                    PrimaryButton(
                        title: "Save",
                        onAction: () async {
                          final List<PurchaseDetail> details =
                              state.purchaseOrderDetail ?? [];

                          if (details.isEmpty) {
                            Fluttertoast.showToast(msg: "No items to save.");
                            return;
                          }

                          // final gate_entry_id = details.first. ?? '';
                          final vendor = details.first.vendor_name ?? '';
                          final orderedBy = details.first.ordered_by ?? '';
                          final toWarehouse =
                              details.first.to_warehouse ?? '';
                          final itemNames = details
                              .map((d) => d.item_name ?? '-')
                              .join(',');
                          final itemQuantities = details
                              .map((d) => (d.quantity?.toString() ?? '-'))
                              .join(',');
                          final itemIds = details
                              .map((d) => (d.item_id?.toString() ?? '-'))
                              .join(',');
                          final groupIds = details
                              .map((d) => (d.group_id?.toString() ?? '-'))
                              .join(',');
                          final subGroupIds = details
                              .map((d) => (d.sub_group_id?.toString() ?? '-'))
                              .join(',');
                          final company_name = details
                              .map((d) => (d.company_name?.toString() ?? '-'))
                              .join(',');
                          final unit = details
                              .map((d) => (d.unit?.toString() ?? '-'))
                              .join(',');
                          final to_warehouse_id = details
                              .map(
                                (d) => (d.to_warehouse_id?.toString() ?? '-'),
                              )
                              .join(',');
                          final project_id = details
                              .map((d) => (d.project_id?.toString() ?? '-'))
                              .join(',');
                          final rate = details.map((d)=>(d.rate?.toString()??'-')).join(',');
                          final grand_total=details.map((d)=>d.grand_total?.toString()??'-').join('-');
                        //   log('''
                        // gate_entry_id: ${widget.id},
                        // poNumber: ${widget.purchaseOrderNo},
                        // vendor: $vendor,
                        // orderedBy: $orderedBy,
                        // toWarehouse: $toWarehouse,
                        // itemNames: $itemNames,
                        // itemQuantities: $itemQuantities,
                        // itemIds: $itemIds,
                        // groupIds: $groupIds,
                        // subGroupIds: $subGroupIds,
                        // company_name: $company_name,
                        // unit: $unit,
                        // to_warehouse_id: $to_warehouse_id,
                        // project_id: $project_id,
                        // gate_entry_date: ${DateFormat('yyyy-MM-dd').format(_selectedGateEntryDate!)},
                        // bill_date: ${DateFormat('yyyy-MM-dd').format(_selectedBillDate!)},
                        // project_id: $project_id,
                        // ''');
                          final addBloc =
                              context.read<AddPurchaseDetailBloc>();
                          addBloc.add(SubmitAddPurchaseDetailEvent(
                              gate_entry_id: widget.id,
                              challanNo: challan_number.text,
                              billNo: bill_number.text,
                              vehicleNo: vehicle_number.text,
                              poNumber: widget.purchaseOrderNo,
                              vendor: vendor,
                              orderedBy: orderedBy,
                              toWarehouse: toWarehouse,
                              itemNames: itemNames,
                              itemQuantities: itemQuantities,
                              itemIds: itemIds,
                              groupIds: groupIds,
                              subGroupIds: subGroupIds,
                              company_name: company_name,
                              unit: unit,
                              to_warehouse_id: to_warehouse_id,
                              gate_entry_date: _selectedGateEntryDate.toString(),
                              bill_date: _selectedBillDate.toString(),
                              project_id: project_id,
                              rate:rate,
                              grand_total: grand_total
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          }
          // default fallback (shouldn't reach)
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ShowFilter extends StatefulWidget {
  final ScrollController scrollController;

  const ShowFilter({
    super.key,
    required this.scrollController,
  });


  @override
  State<ShowFilter> createState() => _ShowFilterState();
}

class _ShowFilterState extends State<ShowFilter> {

  String? selectedToWarehouseID;
  String? selectedIssuedToID;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      // MultiBlocListener(
      // listeners: [
      //
      // ],
      // child: BlocBuilder<PurchaseOrderDetailBloc, PurchaseOrderDetailState>(
      //   builder: (context, state) {
      //     if (state is PurchaseOrderDetailLoading) {
      //       return Container(
      //         height: MediaQuery.of(context).size.height * 0.6,
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.vertical(
      //             top: Radius.circular(24.0),
      //           ),
      //         ),
      //         child: Center(
      //           child: CircularProgressIndicator(
      //             backgroundColor: ColorConstants.primary,
      //           ),
      //         ),
      //       );
      //     }
      //     if (state is PurchaseOrderDetailLoadSuccess) {
      //       final List<PurchaseDetail> details =
      //           state.purchaseOrderDetail ?? [];
      //       if (details.isEmpty) {
      //         return Container(
      //           decoration: BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: BorderRadius.vertical(
      //               top: Radius.circular(24.0),
      //             ),
      //           ),
      //           padding: const EdgeInsets.all(20),
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Text(
      //                 "No items found",
      //                 style: GoogleFonts.poppins(),
      //               ),
      //               const SizedBox(height: 12),
      //               PrimaryButton(
      //                 title: "Close",
      //                 onAction: () {
      //                   Navigator.pop(context);
      //                 },
      //               ),
      //             ],
      //           ),
      //         );
      //       }
      //       final PurchaseDetail first = details.first;
      //       return
        Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24.0),
                ),
              ),
              child: ListView(
                controller: widget.scrollController,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Search Gate Entries",
                            style: GoogleFonts.lalezar(
                              height: 1,
                              fontSize: 20,
                              color: ColorConstants.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          cText("Filter results using warehouse and ordered by",color: Colors.black54),
                          const SizedBox(height: 20),
                          BlocBuilder<WarehouseBloc, WarehouseState>(
                            builder: (context, state) {
                              if (state is WarehouseLoadSuccess) {
                                // find the coordinator whose id matches the selected id
                                final selectedToWarehouse =
                                state.warehouses.firstWhere(
                                      (coordinator) =>
                                  coordinator.godown_id ==
                                      selectedToWarehouseID,
                                  orElse: () => WarehouseData(
                                      godown_id: "", godown_name: ""),
                                );
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TransferDropdown<WarehouseData>(
                                      title: 'To Warehouse',
                                      hint: 'Select warehouse',
                                      selectedVal: selectedToWarehouse.godown_name ?? "",
                                      data: state.warehouses,
                                      displayText: (data) =>
                                      data.godown_name ?? '',
                                      onChanged: (val) {
                                        setState(() {
                                          selectedToWarehouseID = val.godown_id ?? "";
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          BlocBuilder<EmployeeBloc, EmployeeState>(
                            builder: (context, state) {
                              if (state is EmployeeLoadSuccess) {
                                // find the coordinator whose id matches the selected id
                                final issuedTo =
                                state.employees.firstWhere(
                                      (coordinator) =>
                                  coordinator.EmployeeId ==
                                      selectedIssuedToID,
                                  orElse: () => EmployeeData(
                                      EmployeeName: "", EmployeeId: ""),
                                );
                                return Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    TransferDropdown<EmployeeData>(
                                      title: 'Ordered by',
                                      hint: 'Select Person',
                                      selectedVal:
                                      issuedTo.EmployeeName ??
                                          "",
                                      data: state.employees,
                                      displayText: (data) =>
                                      data.EmployeeName ?? '',
                                      onChanged: (val) {
                                        setState(() {
                                          selectedIssuedToID = val.EmployeeId ?? "";
                                        });
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
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            title: "Search",
                            onAction: (){},
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 13,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.primary,
                                    ColorConstants.primary.withOpacity(.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(color: Colors.grey.withOpacity(.2)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
    //       }
    //       // default fallback (shouldn't reach)
    //       return const SizedBox.shrink();
    //     },
    //   ),
    // );
  }
}
