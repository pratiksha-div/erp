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
        FetchGatePassByIDEvent(gatepass_id: widget.data.gatepass_id ?? ""));
    print("Gate pass id ${widget.data.gatepass_id}");
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

                            const SizedBox(height: 5),

                            if (data.isNotEmpty)
                              _buildGatePassCard(formattedDate,formattedTime), // extract your big UI here
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


  Widget _buildGatePassCard(String formattedDate,String formattedTime)
  {
    return Container(
      width: 90.w,
      padding: EdgeInsets.symmetric(
          vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subTitle("Overview of gate pass activity"),
          SizedBox(
            height: 10,
          ),
          if(data.first.gate_pass!.isNotEmpty)
            Text(
              "Gate no. ${data.first.gate_pass}",
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: ColorConstants.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          if(data.first.issued_material!.isNotEmpty)
            Text(
              "${data.first.issued_material}",
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color:
                Colors.black.withOpacity(0.95),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          Row(
            children: [
              Text(
                "${data.first.group_names}",
                style: GoogleFonts.poppins(
                    color: Colors.grey
                        .withOpacity(0.95),
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                " , ",
                style: GoogleFonts.poppins(
                  color: Colors.grey
                      .withOpacity(0.95),
                  fontSize: 10,
                ),
              ),
              Text(
                "${data.first.subgroup_names}",
                style: GoogleFonts.poppins(
                    color: Colors.grey
                        .withOpacity(0.95),
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
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
                      color: ColorConstants.primary
                          .withOpacity(0.95),
                      fontSize: 10,
                    ),
                  ),
                  Container(
                    width: 75.w,
                    child: Text(
                      "${valueOrDash(widget.data.issued_to.toString().toLowerCase())} "
                          "- ${valueOrDash(widget.data.issued_by.toString().toLowerCase())}" ,
                      style: GoogleFonts.poppins(
                        color: Colors.black
                            .withOpacity(0.95),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Date: ",
                        style: GoogleFonts.poppins(
                          color: ColorConstants.primary
                              .withOpacity(0.95),
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: GoogleFonts.poppins(
                            color: ColorConstants.primary
                                .withOpacity(0.95),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Time: ",
                        style: GoogleFonts.poppins(
                          color: ColorConstants.primary
                              .withOpacity(0.95),
                          height: 1,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        formattedTime,
                        style: GoogleFonts.poppins(
                            color: ColorConstants.primary
                                .withOpacity(0.95),
                            height: 1,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20
            ),
            decoration:BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorConstants.primary
                  .withOpacity(.05),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                        const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstants.primary
                              .withOpacity(.05),
                        ),
                        child: Icon(Icons.apartment,
                            size: 15,
                            color:
                            ColorConstants.primary),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "From",
                        style: GoogleFonts.poppins(
                          color: ColorConstants.primary
                              .withOpacity(0.95),
                          height: 1,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // make this responsive instead of fixed width
                      ConstrainedBox(
                        constraints:
                        const BoxConstraints(
                            maxWidth: 120),
                        child: Text(
                          valueOrDash(data.first.from_warehouse_name),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.poppins(
                            height: 1,
                            color: Colors.black
                                .withOpacity(0.95),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // CENTER DOTS — responsive using LayoutBuilder
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top:20),
                    child: LayoutBuilder(
                        builder: (context, constraints) {
                          final available =
                              constraints.maxWidth;
                          const double dotSize = 8;
                          const double spacing =
                          10; // total horizontal spacing per dot (margin left+right)
                          // how many dots fit (at least 1)
                          final int maxDotsThatFit =
                          (available /
                              (dotSize + spacing))
                              .floor()
                              .clamp(1, 8);
                          // give a minimum visual of 3 if space permits (optional)
                          final int dotsToShow =
                              maxDotsThatFit;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                dotsToShow, (index) {
                              return Container(
                                height: dotSize,
                                width: dotSize,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorConstants
                                      .primary
                                      .withOpacity(.15),
                                ),
                              );
                            }),
                          );
                        }),
                  ),
                ),
                // RIGHT
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                        const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstants.primary
                              .withOpacity(.05),
                        ),
                        child: Icon(Icons.apartment,
                            size: 15,
                            color:
                            ColorConstants.primary),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "To",
                        style: GoogleFonts.poppins(
                          color: ColorConstants.primary
                              .withOpacity(0.95),
                          height: 1,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ConstrainedBox(
                        constraints:
                        const BoxConstraints(
                            maxWidth: 120),
                        child: Text(
                          (widget.data.transfer_type=="project_type"
                              || widget.data.transfer_type=="Project Type"
                          )? valueOrDash(widget.data.to_project_name):
                          valueOrDash(widget.data.to_warehouse_name),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.95),
                            fontSize: 12,
                            height: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
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
                      fontSize: 14,
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
                    ),
                  ),
                  Text(
                    "Vehicle Name ",
                    style: GoogleFonts.poppins(
                      color: ColorConstants.primary
                          .withOpacity(0.95),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Expanded(child: Text("")),

              if (data.first.out_time
                  .toString()
                  .isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 20, horizontal: 20),
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
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        valueOrDash(data.first.out_time),
                        // textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black
                              .withOpacity(0.95),
                          fontSize: 25,
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
        color: ColorConstants.primary.withOpacity(0.95),
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
