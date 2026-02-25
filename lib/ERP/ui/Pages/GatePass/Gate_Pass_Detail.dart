import 'package:erp_mr/ERP/UI/Widgets/Gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../api/models/DAOGetGatePass.dart';
import '../../../api/models/GetGatePassByID.dart';
import '../../../bloc/GatePass/gate_pass_by_id_bloc.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/TextWidgets.dart';
import '../../Utils/colors_constants.dart';

class GatePassDetail extends StatefulWidget {
  GatePassDetail({super.key, required this.data});
  GatePassData data;

  @override
  State<GatePassDetail> createState() => _GatePassDetailState();
}

class _GatePassDetailState extends State<GatePassDetail> {
  List<GatePassByID> data = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GatePassByIDBloc>(context).add(
        FetchGatePassByIDEvent(gate_pass: widget.data.gate_pass ?? "",date: widget.data.date));
    print("Gate pass id ${widget.data.gate_pass}");
    print("Gate pass date ${widget.data.date}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<String, String> formatDateTime() {
    try {
      // Parse original format
      final dateTime =
      DateFormat("MMMM, dd yyyy HH:mm:ss Z").parse(widget.data.date ?? "");
      // Convert to required formats
      final formattedDate = DateFormat("dd MMM yyyy").format(dateTime); // 11 May 2025
      final formattedTime = DateFormat("h:mm a").format(dateTime); // 1:40 PM
      return {
        "date": formattedDate,
        "time": formattedTime,
      };
    } catch (e) {
      print("Date parse error: $e");
      return {"date": "", "time": ""};
    }
  }

  String valueOrDash(String? value) {
    return (value?.isNotEmpty ?? false) ? value! : "-";
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

              /// ✅ AppBar always visible
              CustomAppbar(
                context,
                title: "View Gate Pass",
                subTitle: "Detail and log gate passes for materials",
              ),
              SizedBox(
                height:10
              ),

              /// ✅ Body changes based on Bloc state
              Expanded(
                child: BlocBuilder<GatePassByIDBloc, GatePassByIDState>(
                  builder: (context, state) {

                    /// 🔄 Loading BELOW app bar
                    if (state is GatePassByIDLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.primary,
                        ),
                      );
                    }

                    /// ❌ Error state
                    if (state is GatePassByIDFailure) {
                      return Center(
                        child: Text(
                          "Failed to load gate pass details",
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    }

                    /// ✅ Success
                    if (state is GatePassByIDLoadSuccess) {
                      data = state.gatePassByID;
                      final result = formatDateTime();
                      final formattedDate = result["date"] ?? "";
                      final formattedTime = result["time"] ?? "";

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(height: 15),
                            // subTitle("Overview of gate pass activity"),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            if (data.isNotEmpty)
                              Column(
                                children: List.generate(
                                  data.length,
                                      (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildGatePassCard(data[index],
                                        formattedDate, formattedTime),
                                  ),
                                ),
                              ),
                            // if (data.isNotEmpty)
                            //   _buildGatePassCard(formattedDate,formattedTime), // extract your big UI here
                          ],
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildGatePassCard(GatePassByID data,String formattedDate,String formattedTime)
  {
    return Container(
      width: 90.w,
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(data.gate_pass!.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  "Gate no. ${data.gate_pass}",
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                    height: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if(data.issued_material!.isNotEmpty)
          Text(
              "${data.issued_material}",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.black.withOpacity(0.95),
                fontSize: 14,
                height: 1,
                fontWeight: FontWeight.bold,
              ),
            ),
          Row(
            children: [
              Text(
                "${data.group_names}",
                style: GoogleFonts.poppins(
                    color: Colors.grey
                        .withOpacity(0.95),
                    fontSize: 10,
                    height: 1,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                ", ${data.subgroup_names}",
                style: GoogleFonts.poppins(
                    color: Colors.grey
                        .withOpacity(0.95),
                    fontSize: 10,
                    fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
          Divider(
            color: ColorConstants.primary.withOpacity(.1),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              sideGradientBar(ht: 35),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Issued to - Issued by ",
                    style: GoogleFonts.poppins(
                      color: Colors.grey
                          .withOpacity(0.95),
                      height: 1,
                      fontSize: 10,
                    ),
                  ),
                  Container(
                    width: 75.w,
                    child: Text(
                      "${valueOrDash(widget.data.issued_to.toString().toLowerCase())} "
                          "- ${valueOrDash(widget.data.issued_by.toString().toLowerCase())}" ,
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.95),
                        fontSize: 14,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    formattedDate + ", " +formattedTime,
                    style: GoogleFonts.poppins(
                        color: Colors.grey
                            .withOpacity(0.95),
                        fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                "${data.from_warehouse_name}",
                style: GoogleFonts.poppins(
                    color: ColorConstants.primary,
                    fontSize: 13,
                    height: 1,
                    fontWeight: FontWeight.w700
                ),
              ),
              Expanded(child: Text("")),
              Icon(Icons.arrow_forward, size: 14, color: ColorConstants.primary),
              Expanded(child: Text("")),
              Text(
                " ${(widget.data.transfer_type=="project_type"
                    || widget.data.transfer_type=="Project Type"
                )? widget.data.to_project_name :widget.data.to_warehouse_name}",
                style: GoogleFonts.poppins(
                    color: ColorConstants.primary,
                    fontSize: 13,
                    height: 1,
                    fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
          Divider(
            color: ColorConstants.primary.withOpacity(.1),
          ),
          itemDetail(),
          SizedBox(height: 10),
          Row(
            // mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Text(
                    valueOrDash(widget.data.vehicle_name),
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.black
                          .withOpacity(0.95),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    valueOrDash(widget.data.vehicle_no),
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.black
                          .withOpacity(0.95),
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              Expanded(child: Text("")),
              if (data.out_time
                  .toString()
                  .isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: ColorConstants.primary
                        .withOpacity(.04),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Out Time",
                        // textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black
                              .withOpacity(0.95),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        valueOrDash(data.out_time),
                        // textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black
                              .withOpacity(0.95),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
            ],
          )
        ],
      ),
    );
  }

  Widget itemDetail() {
    // small helper to build the left label Text with consistent style
    Widget label(String txt) => Text(
      txt,
      style: GoogleFonts.poppins(
        color: Colors.grey.withOpacity(0.95),
        fontSize: 12,
      ),
    );

    // small helper to build the right value Text with consistent style
    Widget value(String txt, {int maxLines = 2}) => Text(
      valueOrDash(txt),
      style: GoogleFonts.poppins(
        color: Colors.black.withOpacity(0.95),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );

    final isProject = (widget.data.transfer_type == "Project Type" || widget.data.transfer_type=="project_type");

    return Container(
      width: 80.w,
      child: Column(
        children: [
          Row(
            children: [
              label("Transfer type"),
              Expanded(child: Text("")),

              value(widget.data.transfer_type=="project_type"? "Project Type" : "Warehouse Type"),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              label("Current Balance"),
              Expanded(child: Text("")),

              value(data.first.current_balance??""),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              label("Quantity"),
              Expanded(child: Text("")),
              value(data.first.quantity??""),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              label("Unit"),
              Expanded(child: Text("")),
              value(data.first.unit??""),
            ],
          ),
          if (isProject) ...[
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                label("Used Quantity"),
                Expanded(child: Text("")),
                value(data.first.used_quantity??""),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                label("Scrap"),
                Expanded(child: Text("")),

                value(data.first.scrap??""),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                label("Rate"),
                Expanded(child: Text("")),

                value(data.first.rate??""),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                label("Amount"),
                Expanded(child: Text("")),

                value(data.first.amount??""),
              ],
            ),
          ]
        ],
      ),
    );
  }

}
