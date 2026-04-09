import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'ERP/UI/Utils/colors_constants.dart';
import 'ERP/UI/Utils/date_picker.dart';
import 'ERP/UI/Widgets/Cards.dart';
import 'ERP/UI/Widgets/Custom_Button.dart';
import 'ERP/UI/Widgets/Custom_Date_Time_Picker.dart';
import 'ERP/UI/Widgets/Custom_Dialog.dart';
import 'ERP/UI/Widgets/Custom_Dropdown.dart';
import 'ERP/UI/Widgets/Custom_appbar.dart';
import 'ERP/UI/Widgets/TextWidgets.dart';
import 'ERP/api/models/DAOGetGENDetail.dart';
import 'ERP/api/models/DAOGetGENumber.dart';
import 'ERP/bloc/DropDownValueBloc/gate_entry_number_bloc.dart';
import 'ERP/bloc/GoodsReceivedNotesBloc/add_goods_received_notes_bloc.dart';
import 'ERP/bloc/GoodsReceivedNotesBloc/goods_received_notes_by_id_bloc.dart';
import 'ERP/bloc/GoodsReceivedNotesBloc/grn_detail_by_id_bloc.dart';

enum EditSource { received, rejected, accepted }

class GRNItem {
  final String name;
  final String unit;
  final int orderedQty;
  final TextEditingController receivedQty = TextEditingController();
  final TextEditingController rejectedQty = TextEditingController();
  final TextEditingController acceptedQty = TextEditingController();
  final TextEditingController shortQty = TextEditingController();
  final TextEditingController excessQty = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController poBalanceQty = TextEditingController();
  final TextEditingController rate=TextEditingController();


  EditSource lastEdited = EditSource.received;

  GRNItem({
    required this.name,
    required this.unit,
    required this.orderedQty,
  });

  void calculate() {
    final received = int.tryParse(receivedQty.text) ?? 0;
    final acceptedInput = int.tryParse(acceptedQty.text) ?? 0;
    final rejectedInput = int.tryParse(rejectedQty.text) ?? 0;

    int accepted;
    int rejected;

    /// 🔹 Decide calculation path
    if (lastEdited == EditSource.accepted) {
      accepted = acceptedInput.clamp(0, received);
      rejected = (received - accepted).clamp(0, received);
      // rejectedQty.text = rejected.toString();
    } else {
      rejected = rejectedInput.clamp(0, received);
      accepted = (received - rejected).clamp(0, received);
      acceptedQty.text = accepted.toString();
    }

    /// 🔹 Short / Excess
    if (received < orderedQty) {
      shortQty.text = (orderedQty - received).toString();
      excessQty.text = '0';
    } else if (received > orderedQty) {
      excessQty.text = (received - orderedQty).toString();
      shortQty.text = '0';
    } else {
      shortQty.text = '0';
      excessQty.text = '0';
    }
    /// 🔹 PO Balance
    final poBalance = (orderedQty - accepted).clamp(0, orderedQty);
    poBalanceQty.text = poBalance.toString();
  }
}

class AddGoodsReceivedNotes extends StatefulWidget {
  AddGoodsReceivedNotes({super.key,required this.grn_id});
  String grn_id;

  @override
  State<AddGoodsReceivedNotes> createState() => _AddGoodsReceivedNotesState();
}

class _AddGoodsReceivedNotesState extends State<AddGoodsReceivedNotes> {
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  String? selectedEntryNumber;
  String? selectedEntryId;

  GENData _grnData = GENData();
  List<GRNItem> grnItems = [];
  bool isEditMode =false;
  String? errDate;
  String? errEntryNumber;
  Map<int, String> grnItemErrors = {};
  TextEditingController remark=TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<GateEntryNumberBloc>().add(FetchGateEntryNumbersEvent());
    BlocProvider.of<GRNDetailByIDBloc>(context).add(FetchGRNDetailByIDEvent(grn_id: widget.grn_id));
    print("GRN ID: ${widget.grn_id}");
    isEditMode = widget.grn_id.isNotEmpty;
  }

  void initItem(GRNItem item) {
    item.receivedQty.addListener(() {
      item.lastEdited = EditSource.received;
      item.calculate();
    });

    item.rejectedQty.addListener(() {
      item.lastEdited = EditSource.rejected;
      item.calculate();
    });

    item.acceptedQty.addListener(() {
      item.lastEdited = EditSource.accepted;
      item.calculate();
    });
  }

  List<GRNItem> _buildItems(GENData data) {
    final names = (data.item_name ?? '').split(',');
    final quantities = (data.quantity ?? '').split(',');
    final units = (data.unit ?? '').split(',');
    final rates = (data.rate ?? '').split(',');

    final length = [
      names.length,
      quantities.length,
      units.length,
      rates.length
    ].reduce((a, b) => a < b ? a : b);

    return List.generate(length, (i) {
      final item = GRNItem(
        name: names[i].trim(),
        orderedQty: int.tryParse(quantities[i].trim()) ?? 0,
        unit: units[i].trim(),
        // rate: rates[i]
      );
      initItem(item);

      return item;
    });
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final date = await showAppDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
        errDate=null;
      });
    }
  }

  bool validateForm() {
    bool valid = true;

    errDate = null;
    errEntryNumber = null;
    grnItemErrors.clear();

    if (_selectedDate == null) {
      errDate = "Please Select Date*";
      valid = false;
    }

    if (selectedEntryId == null) {
      errEntryNumber = "Please Select Gate Entry Number*";
      valid = false;
    }

    for (int i = 0; i < grnItems.length; i++) {
      final item = grnItems[i];

      final received = double.tryParse(item.receivedQty.text.trim());
      final rejected = double.tryParse(item.rejectedQty.text.trim());
      final accepted = double.tryParse(item.acceptedQty.text.trim());


      if (received == null || received <= 0) {
        grnItemErrors[i] = "Please enter valid Received Qty for ${item.name}*";
        valid = false;
        continue;
      }

      if (rejected == null || rejected < 0) {
        grnItemErrors[i] = "Please enter valid Rejected Qty for ${item.name}*";
        valid = false;
        continue;
      }

      if (accepted == null || accepted < 0) {
        grnItemErrors[i] = "Please enter valid Accepted Qty for ${item.name}*";
        valid = false;
        continue;
      }

      if (rejected > received) {
        grnItemErrors[i] = "Rejected Qty cannot be greater than Received Qty for ${item.name}";
        valid = false;
        continue;
      }

      if ((accepted + rejected) != received) {
        grnItemErrors[i] = "Accepted + Rejected must equal Received Qty for ${item.name}";
        valid = false;
      }
    }

    setState(() {});
    return valid;
  }

  void _onSavePressed() {
    // setState(() { _isSubmitting = true; });
    if (!validateForm()) {
      showErrorDialog(context, "Failed", "Please fill required fields");
      return;
    }
    // final validationError = _validateForm();
    // if (validationError != null) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => Dialog(
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(20),
    //       ),
    //       backgroundColor: Colors.transparent,
    //       child: UploadErrorCard(
    //         title: 'Failed',
    //         subtitle: validationError,
    //         onRetry: () {
    //           Navigator.pop(context);
    //           setState(() { _isSubmitting = false; });
    //         },
    //       ),
    //     ),
    //   );
    //   return;
    // }
    final itemNames = grnItems.map((e) => e.name).join(',');
    final quantities = grnItems.map((e) => e.orderedQty.toString()).join(',');
    final receivedQty = grnItems.map((e) => e.receivedQty.text).join(',');
    final shortQty = grnItems.map((e) => e.shortQty.text).join(',');
    final excessQty = grnItems.map((e) => e.excessQty.text).join(',');
    final rejectedQty = grnItems.map((e) => e.rejectedQty.text.isNotEmpty ? e.rejectedQty.text : '0').join(',');
    final acceptedQty = grnItems.map((e) => e.acceptedQty.text).join(',');
    final poBalance = grnItems.map((e) => e.poBalanceQty.text).join(',');
    final units = grnItems.map((e) => e.unit).join(',');
    final amount = grnItems.map((e) => '0').join(',');
    final itemId = (_grnData.item_id ?? '');
    final groupId = (_grnData.group_id ?? '');
    final subGroupId = (_grnData.sub_group_id ?? '');
    final discount = grnItems.map((e) => '0').join(',');
    final rate = grnItems.map((e) => e.rate.text.isNotEmpty? e.rate.text:'0').join(',');
    print(
        '''
      Grand total ${_grnData.grand_total} 
      rate ${rate}
      '''
    );
    final grand_total = (_grnData.grand_total ?? '');
    print(
       '''
       grn_date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}
       gen_no: ${selectedEntryId},
       bill_no: ${_grnData.bill_no},
       challan_no: ${_grnData.challan_no},
       vehcile_no: ${_grnData.vehicle_no},
       po_no: ${_grnData.selected_po},
       from_vendor: ${_grnData.from_vendor},
       company_name: ${_grnData.company_name},
       to_warehouse: ${_grnData.to_warehouse},
       to_warehouse_id: ${_grnData.to_warehouse_id}
       requested_by: ${_grnData.ordered_by},
       contact: ${_grnData.contact},
       item_names: ${itemNames},
       quantities: ${quantities},
       received_qty: ${receivedQty},
       short_qty: ${shortQty},
       excess_qty: ${excessQty},
       rejected_qty: ${rejectedQty},
       accepted_qty: ${acceptedQty},
       po_balance: ${poBalance},
       item_id: ${itemId},
       group_id: ${groupId},
       sub_group_id: ${subGroupId},
       unit: ${units}
       discount: ${discount},
       amount: ${amount},
       rate: ${rate},
       grand_total: ${grand_total},
       remarks:${remark.text}
      '''
    );
    // context.read<AddGoodsReceivedNotesBloc>().add(
    //   SubmitAddGoodsReceivedNotesEvent(
    //       grn_date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
    //       gen_no: selectedEntryId??"",
    //       bill_no: _grnData.bill_no,
    //       challan_no: _grnData.challan_no,
    //       vehcile_no: _grnData.vehicle_no,
    //       po_no: _grnData.selected_po,
    //       from_vendor: _grnData.from_vendor,
    //       company_name: _grnData.company_name,
    //       to_warehouse: _grnData.to_warehouse,
    //       to_warehouse_id: _grnData.to_warehouse_id,
    //       requested_by: _grnData.ordered_by,
    //       contact: _grnData.contact,
    //       item_names: itemNames,
    //       quantities: quantities,
    //       received_qty: receivedQty,
    //       short_qty: shortQty,
    //       excess_qty: excessQty,
    //       rejected_qty: rejectedQty,
    //       accepted_qty: acceptedQty,
    //       po_balance: poBalance,
    //       rate: rate,
    //       discount: discount,
    //       amount: amount,
    //       item_id: itemId,
    //       group_id: groupId,
    //       sub_group_id: subGroupId,
    //       unit: units,
    //       grand_total: grand_total,
    //       remarks: remark.text
    //   ),
    // );
  }

  void getDate(String inputDate) {
    if (inputDate.isEmpty) return;
    DateFormat inputFormat = DateFormat("MMMM, dd yyyy HH:mm:ss Z");
    try {
      DateTime parsedDate = inputFormat.parse(inputDate);
      DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
      String formattedDate = outputFormat.format(parsedDate);
      print(formattedDate);
      _selectedDate = parsedDate;
    } catch (e) {
      print('Error parsing date: $e');
    }
  }

  @override
  void dispose() {
    for (final item in grnItems) {
      item.receivedQty.dispose();
      item.rejectedQty.dispose();
      item.acceptedQty.dispose();
    }
    remark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AddGoodsReceivedNotesBloc, AddGoodsReceivedNotesState>(
            listener: (context, state) {
              if (state is AddGoodsReceivedNotesSuccess) {
                setState(() {
                  _isSubmitting = false;
                });

                showConfirmDialog(
                  context: context,
                  title: "Success",
                  message: "GRN saved successfully!",
                  content: state.grn_no,
                  confirmText: "Ok",
                  callback: () {
                    Navigator.of(context).pop(); // closes dialog
                    Navigator.of(context).pop(true); // pops screen ✅
                  },
                );
                Fluttertoast.showToast(msg: state.message);
              }

              else if (state is AddGoodsReceivedNotesFailed) {
                setState(() {
                  _isSubmitting = false;
                });

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.transparent,
                    child: UploadErrorCard(
                      title: "Failed to Add Goods Received Notes",
                      subtitle: state.message,
                      onRetry: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<GoodsReceivedNotesByIDBloc, GoodsReceivedNotesByIDState>(
            listener: (context, state) {
              if (state is GoodsReceivedNotesByIDLoadSuccess) {
                setState(() {
                  _grnData = state.goodsReceivedNotesByID.first;
                  grnItems = _buildItems(_grnData);
                });
              }
            },
          ),
          BlocListener<GRNDetailByIDBloc, GRNDetailByIDState>(
            listener: (context, state) {
              if (state is GRNDetailByIDLoadSuccess &&
                  widget.grn_id.isNotEmpty &&
                  state.GRNDetailByID.isNotEmpty) {

                final detail = state.GRNDetailByID.first;

                setState(() {
                  getDate(detail.grn_date ?? "");
                  selectedEntryId = detail.gen_id;
                  selectedEntryNumber = detail.gen_no;
                  remark.text = detail.remarks??"";

                  _grnData = GENData(
                    bill_no: detail.bill_no,
                    challan_no: detail.challan_no,
                    vehicle_no: detail.vehicle_no,
                    selected_po: detail.po_no,
                    from_vendor: detail.from_vendor,
                    to_warehouse: detail.to_warehouse,
                    ordered_by: detail.requested_by,
                    contact: detail.contact,
                  );

                  grnItems.clear();
                  final itemNames = (detail.item_name ?? '').split(',');
                  final quantities = (detail.quantity ?? '').split(',');
                  final receivedQty = (detail.received_qty ?? '').split(',');
                  final acceptedQty = (detail.accepted_qty ?? '').split(',');
                  final rejectedQty = (detail.rejected_qty ?? '').split(',');
                  final shortQty = (detail.short_qty ?? '').split(',');
                  final excessQty = (detail.excess_qty ?? '').split(',');
                  final poBalanceQty = (detail.po_balance ?? '').split(',');
                  final rate = (detail.rate ?? "").split(',');

                  for (int i = 0; i < itemNames.length; i++) {
                    final item = GRNItem(
                      name: itemNames[i].trim(),
                      orderedQty: int.tryParse(quantities[i]) ?? 0,
                      unit: '',
                      // rate: itemNames[i].trim()
                    );

                    initItem(item);

                    // 🔒 disable calculations
                    // item.isInitializing = true;

                    item.receivedQty.text = receivedQty[i];
                    item.acceptedQty.text = acceptedQty[i];
                    item.rejectedQty.text = rejectedQty[i];
                    item.shortQty.text = shortQty[i];
                    item.excessQty.text = excessQty[i];
                    item.poBalanceQty.text = poBalanceQty[i];
                    item.rate.text = rate[i];
                    item.lastEdited = EditSource.accepted;
                    // item.isInitializing = false;
                    grnItems.add(item);
                  }
                });
              }
            },
          ),
        ],
        child: BlocBuilder<AddGoodsReceivedNotesBloc, AddGoodsReceivedNotesState>(
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    CustomAppbar(
                      context, title: "Add Goods Received Notes",
                      subTitle: "Record received goods efficiently",
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                CustomDateTimeTextField(
                                  onTap: _pickDate,
                                  hint: _selectedDate == null
                                      ? '-- Date: --'
                                      : DateFormat("d MMMM y")
                                      .format(_selectedDate!),
                                  icon: Icons.calendar_month,
                                ),
                              ],
                            ),
                            if (errDate != null)errorText(errDate),
                            const SizedBox(height: 10),
                            BlocBuilder<GateEntryNumberBloc, GateEntryNumberState>(
                              builder: (context, state) {
                                if (state is GateEntryNumberLoadSuccess) {
                                  final selectedGEN = state.gateEntryNumbers.firstWhere(
                                        (element) => element.gen_id == selectedEntryId,
                                    orElse: () => GENumberData(gen_no: "", gen_id: ""),
                                  );

                                  final bool isDisabled = widget.grn_id.isNotEmpty;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      subTitle(
                                        "Mention Gate Entry Number",
                                        leftMargin: 10.0,
                                        bottomMargin: 5,
                                      ),
                                      /// Optional: visually indicate disabled state
                                      Opacity(
                                        opacity: isDisabled ? 0.6 : 1.0,
                                        child: IgnorePointer(
                                          ignoring: isDisabled,
                                          child: TransferDropdown<GENumberData>(
                                            title: 'GE Number',
                                            hint: 'Select GE Number',
                                            selectedVal: selectedGEN.gen_no?.isNotEmpty == true
                                                ? selectedGEN.gen_no!
                                                : "",
                                            data: state.gateEntryNumbers,
                                            displayText: (data) => data.gen_no ?? '',
                                            onChanged: isDisabled
                                                ? null
                                                : (val) {
                                              setState(() {
                                                selectedEntryId = val.gen_id;
                                                selectedEntryNumber = val.gen_no;
                                                errEntryNumber=null;
                                                grnItems.clear();
                                              });
                                              print("selectedEntryId ${selectedEntryId}");

                                              context
                                                  .read<GoodsReceivedNotesByIDBloc>()
                                                  .add(
                                                FetchGoodsReceivedNotesByIDEvent(
                                                  gen_id: selectedEntryId ?? "",
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                            if (errEntryNumber != null)errorText(errEntryNumber),
                            const SizedBox(height: 5),
                            txtFiled(context,remark, "Add remark here...", "Remark", maxLines: 3),
                            const SizedBox(height: 15),
                            subTitle(
                                "Mention Bill, Challan, Vehicle, PO, Vendor detail"),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: card(
                                    "Bill Number",
                                    _grnData.bill_no ?? "--",
                                    Icons.scoreboard,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: card(
                                    "Challan Number",
                                    _grnData.challan_no ?? "--",
                                    Icons.looks_3,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: card(
                                    "Vehicle Number",
                                    _grnData.vehicle_no ?? "--",
                                    Icons.time_to_leave,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: card(
                                    "PO Number",
                                    _grnData.selected_po ?? "--",
                                    Icons.beenhere,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: card(
                                    "From Vendor",
                                    _grnData.from_vendor ?? "--",
                                    Icons.diversity_2,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: card(
                                    "To Warehouse",
                                    _grnData.to_warehouse ?? "--",
                                    Icons.apartment,
                                  ),
                                ),
                              ],
                            ),

                            card(
                              "Ordered by",
                              _grnData.ordered_by ?? "--",
                              Icons.bookmark_added,
                            ),

                            const SizedBox(height: 20),

                            /// ITEM CARDS
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: grnItems.length,
                              itemBuilder: (context, index) {
                                final item = grnItems[index];
                                return buildItemCard(item,index);
                              },
                            ),

                            const SizedBox(height: 40),
                            if(widget.grn_id.isEmpty)
                              PrimaryButton(
                                title:
                                _isSubmitting ? "Saving..." : "Save",
                                onAction:
                                _isSubmitting ? () {} : _onSavePressed,
                              ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildItemCard(GRNItem item, int index) {
    var receivedQtyEmpty = item.receivedQty.text.trim().isEmpty;
    final rejectedQtyEmpty = item.rejectedQty.text.trim().isEmpty;
    String? errorMessage;
    if (receivedQtyEmpty) {
      errorMessage = "Received Qty is required*";
    } else if (rejectedQtyEmpty) {
      errorMessage = "Rejected Qty is required*";
    }

    final hasError = errorMessage != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorConstants.primary.withOpacity(.2),
        ),
      ),
      child: Column(
        children: [
          /// HEADER
          Container(
            width: 90.w,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorConstants.primary,
                  ColorConstants.primary,
                  ColorConstants.primary,
                  ColorConstants.secondary,
                ],
              ),
            ),
            child: Text(
              item.name ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                row(
                  readOnlyField(
                    item.orderedQty.toString(),
                    "Ordered Quantity",
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputField(
                          item.receivedQty,
                          "Received Quantity",
                          enabled: !isEditMode,
                          bottomMargin: 2,
                          onChange: (){
                            receivedQtyEmpty=false;
                            setState(() {});
                          }
                      ),

                      /// ❌ ERROR BELOW RECEIVED QTY
                      if (hasError && receivedQtyEmpty)
                        errorText(errorMessage!, leftPadding: 0),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                row(
                  readOnlyField(
                    item.shortQty.text,
                    "Short Quantity",
                    controller: item.shortQty,
                  ),
                  readOnlyField(
                    item.excessQty.text,
                    "Excess Quantity",
                    controller: item.excessQty,
                  ),
                ),

                row(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputField(
                        item.rejectedQty,
                        "Rejected Quantity",
                        enabled: !isEditMode,
                        bottomMargin: 2,
                      ),
                      if (hasError && !receivedQtyEmpty && rejectedQtyEmpty)
                        errorText(errorMessage!, leftPadding: 0),
                      const SizedBox(height: 10),
                    ],
                  ),
                  inputField(
                    item.acceptedQty,
                    "Accepted Quantity",
                    enabled: !isEditMode,
                  ),
                ),

                row(
                  inputField(item.rate,"Rate"),
                  readOnlyField(
                    item.amount.text,
                    "Amount",
                    controller: item.amount,
                  ),
                ),
                readOnlyField(
                  item.poBalanceQty.text,
                  "PO Balance",
                  controller: item.poBalanceQty,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget inputField(TextEditingController controller,
      String title,{bool enabled = true,double bottomMargin=15.0,final onChange}) {
    return txt(controller, title, enabled: enabled,bottomMargin: bottomMargin,onChanged: onChange);
  }

  Widget readOnlyField(String value, String title,
      {TextEditingController? controller}) {
    return field(
      controller ?? TextEditingController(text: value),
      title,
      enabled: false,
    );
  }

  Widget field(TextEditingController controller, String title,
      {required bool enabled}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget txt(dynamic controller, String title,
      {bool enabled = true,double bottomMargin=15.0,final onChanged}) {
    return Container(
      margin:  EdgeInsets.only(bottom: bottomMargin),
      // height: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: Colors.grey.withOpacity(.6)
                )
            ),
            child: TextField(
              controller: controller is String ? TextEditingController(text: controller) : controller,
              enabled: enabled,
              keyboardType: TextInputType.number,
              onChanged: (val){
                onChanged;
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true, contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

// Total experience - 4 years
// Experience as a Flutter Developer - 4 years
// Flutter Experience - 4 years
// Dart Experience - 4 years
// Bloc Experience - 2 years
//Experience with current company - 6 months
// Current CTC-4.25
// Expected CTC - 8
// Notice Period - 30 days
//Current Location - Bhilai, CG
// Native Location - Bhilai, CG
// Highest Qualification - Masters in Computer Application
// Current Company - Divyal Technologies, STPI, Bhilai
// Availability for interview - After 7 April any time
