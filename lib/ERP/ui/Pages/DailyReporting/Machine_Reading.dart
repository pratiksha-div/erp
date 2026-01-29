import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../api/models/DAOGetMachineReading.dart';
import '../../../api/services/add_machine_reading_service.dart';
import '../../../bloc/DailyReporting/delete_machine_reading_bloc.dart';
import '../../../bloc/DailyReporting/get_machine_reading.dart';
import '../../Utils/utils.dart';
import '../../Widgets/Bottom_Sheet.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/Date_Formate.dart';
import '../../Widgets/Gradient.dart';
import '../../Widgets/TextWidgets.dart';
import '../../Utils/colors_constants.dart';
import 'Add_Machine_Reading.dart';

class MachineReading extends StatefulWidget {
  const MachineReading({super.key});

  @override
  State<MachineReading> createState() => _MachineReadingState();
}

class _MachineReadingState extends State<MachineReading>  with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _isInitialLoading = false;
  String? _error;

  final List<MachineReadingData> _allItems = []; // master list accumulated from pages
  final List<MachineReadingData> _visibleItems = []; // filtered by search

  late final MachineReadingBloc _machineReadingBloc;
  late final DeleteMachineReadingBloc _deleteBloc;

  Timer? _debounce;
  MachineReadingData? _lastRemovedItem;
  int? _lastRemovedIndex;

  // late AnimationController _controller;
  // late Animation<double> _opacity;
  // late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    final service = MachineReadingService();
    _machineReadingBloc = MachineReadingBloc(service: service);
    _deleteBloc = DeleteMachineReadingBloc();

    _loadPage(start: 0);
    _scrollController.addListener(_onScroll);

    // _controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 900),
    // )..repeat(reverse: true);
    //
    // _opacity = Tween<double>(begin: 0.4, end: 5).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    // );
    //
    // _scale = Tween<double>(begin: 0.97, end: 1.00).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    // );
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isLoadingMore || !_hasMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= (maxScroll - 300)) {
      _loadPage(start: _allItems.length);
    }
  }

  Future<void> _loadPage({required int start}) async {
    if ((start == 0 && _isInitialLoading) || (start > 0 && _isLoadingMore)) return;
    if (start == 0) {
      if (!mounted) return;
      setState(() {
        _isInitialLoading = true;
        _error = null;
      });
    } else {
      if (!mounted) return;
      setState(() {
        _isLoadingMore = true;
      });
    }
    _machineReadingBloc.add(FetchMachineReadingsEvent(start: start, length: _pageSize));
  }

  Future<void> _onRefresh() async {
    _hasMore = true;
    _allItems.clear();
    _visibleItems.clear();
    setState(() {});
    _loadPage(start: 0);
    // wait until initial load finished
    // while (_isInitialLoading) {
    //   await Future.delayed(const Duration(milliseconds: 50));
    // }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    // _controller.dispose();
    searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _machineReadingBloc.close();
    _deleteBloc.close();
    super.dispose();
  }

  String timeFormat(String input) {
    // keep your original format parsing — guard against parse errors
    try {
      DateTime dateTime = DateFormat("MMMM, dd yyyy HH:mm:ss Z").parse(input);
      String formattedTime = DateFormat('h:mm').format(dateTime);
      return formattedTime;
    } catch (e) {
      // fallback: return input or a truncated version
      return input;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provide both blocs at the page level so all children and listeners share same instances
    return MultiBlocProvider(
      providers: [
        BlocProvider<MachineReadingBloc>.value(value: _machineReadingBloc),
        BlocProvider<DeleteMachineReadingBloc>.value(value: _deleteBloc),
      ],
      child: Scaffold(
        backgroundColor: ColorConstants.background,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppbar(context,
                    title: "Machine Reading", subTitle: "Log and monitor machine readings efficiently"),
                Expanded(
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<MachineReadingBloc, MachineReadingState>(
                        listener: (context, state) {
                          if (state is MachineReadingLoadSuccess) {
                            // Append new items
                            final newItems = state.MachineReading;
                            setState(() {
                              // If we were doing an initial load or refresh, clear previous data first
                              if (_isInitialLoading) {
                                _allItems.clear();
                                _visibleItems.clear();
                              }

                              // Add fetched items (avoid exact duplicates if server returns same id twice)
                              for (var ni in newItems) {
                                final exists = _allItems.any((e) => e.readingid == ni.readingid);
                                if (!exists) _allItems.add(ni);
                              }

                              // update visible list depending on search query
                              final q = searchController.text.trim().toLowerCase();
                              if (q.isEmpty) {
                                _visibleItems
                                  ..clear()
                                  ..addAll(_allItems);
                              } else {
                                _visibleItems
                                  ..clear()
                                  ..addAll(_allItems.where((p) {
                                    final name = (p.vehiclename ?? '').toLowerCase();
                                    final vendor = (p.vendorname ?? '').toLowerCase();
                                    final vehNo = (p.vehicleno ?? '').toLowerCase();
                                    return name.contains(q) || vendor.contains(q) || vehNo.contains(q);
                                  }));
                              }

                              _isInitialLoading = false;
                              _isLoadingMore = false;

                              // if less than page size returned, no more pages
                              if (newItems.length < _pageSize) _hasMore = false;
                            });
                          } else if (state is MachineReadingLoadFailure) {
                            setState(() {
                              _isInitialLoading = false;
                              _isLoadingMore = false;
                              _error = state.message;
                            });
                          }
                        },
                      ),
                      BlocListener<DeleteMachineReadingBloc, DeleteMachineReadingState>(
                        listener: (context, state) {
                          if (state is DeleteMachineReadingSuccess) {
                            // Server confirmed delete. Clear optimistic storage and refresh list from server
                            _lastRemovedItem = null;
                            _lastRemovedIndex = null;
                            Fluttertoast.showToast(msg:'Reading Deleted');
                            // It's safe to refresh to re-sync with server
                            _onRefresh();
                          } else if (state is DeleteMachineReadingFailed) {
                            // Delete failed: rollback optimistic removal if any
                            if (_lastRemovedItem != null && _lastRemovedIndex != null) {
                              setState(() {
                                final insertIndex = _lastRemovedIndex!;
                                // ensure index bounds
                                final idx = insertIndex <= _allItems.length ? insertIndex : _allItems.length;
                                _allItems.insert(idx, _lastRemovedItem!);

                                // update visible list too (honoring search filter)
                                final q = searchController.text.trim().toLowerCase();
                                if (q.isEmpty) {
                                  _visibleItems
                                    ..clear()
                                    ..addAll(_allItems);
                                } else {
                                  _visibleItems
                                    ..clear()
                                    ..addAll(_allItems.where((p) {
                                      final name = (p.vehiclename ?? '').toLowerCase();
                                      final vendor = (p.vendorname ?? '').toLowerCase();
                                      final vehNo = (p.vehicleno ?? '').toLowerCase();
                                      return name.contains(q) || vendor.contains(q) || vehNo.contains(q);
                                    }));
                                }
                              });

                              _lastRemovedItem = null;
                              _lastRemovedIndex = null;
                            }

                            Fluttertoast.showToast(
                              msg:'Failed to delete: ${state.message}',
                            );
                          }
                        },
                      ),
                    ],
                    child: RefreshIndicator(
                      color: ColorConstants.primary,
                      backgroundColor: Colors.white,
                      onRefresh: _onRefresh,
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
    final header = Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  final result = await Utils.navigateTo(
                      context,
                      AddMachineReading(id:"")
                  );
                  if(result == "true")
                  {
                    print('Project added successfully');
                    _onRefresh();
                  }
                },
                child: Container(
                  width: 80.w,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: ShapeDecoration(
                    shape: ContinuousRectangleBorder(
                        side: BorderSide(
                            color:  ColorConstants.primary
                        ),
                        borderRadius: BorderRadius.circular(30)),
                    gradient: LinearGradient(
                      colors: [
                        ColorConstants.primary,
                        ColorConstants.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add Machine Reading",
                        style: txt_bold(color: Colors.black, textSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );

    if (_isInitialLoading && _allItems.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 30),
          const Center(
            child: CircularProgressIndicator(color: ColorConstants.primary),
          ),
        ],
      );
    }

    if (_error != null && _allItems.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          header,
          const SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                Text('Error: $_error'),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    _loadPage(start: 0);
                  },
                  child: Container(
                    width: 40.w,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: ColorConstants.primary),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: cText("Retry", color: ColorConstants.primary)),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }

    // total items in list view:
    final int extra = 2 + (_hasMore ? 1 : 0); // header + spacer + optional load-more
    final int totalCount = _visibleItems.length + extra;
    return ListView.builder(
      controller: _scrollController,
      itemCount: totalCount,
      itemBuilder: (context, index) {
        /// HEADER
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: header,
          );
        }

        /// DATA STARTS FROM INDEX 2
        final dataIndex = index - 2;

        /// LIST ITEM
        if (dataIndex >= 0 && dataIndex < _visibleItems.length) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildProjectCard(_visibleItems[dataIndex]),
          );
        }

        /// LOAD MORE INDICATOR
        if (_hasMore && dataIndex == _visibleItems.length) {
          if (!_isLoadingMore) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (!_isLoadingMore) {
                _loadPage(start: _allItems.length);
              }
            });
          }

          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(
                color: ColorConstants.primary,
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );

  }

  Widget _buildProjectCard(MachineReadingData i) {
    /// Hide card if all meaningful data is empty
    final bool allEmpty =
        i.readingDt == null &&
            (i.vehiclename ?? '').trim().isEmpty &&
            (i.vendorname ?? '').trim().isEmpty &&
            (i.expendedtime ?? '').trim().isEmpty &&
            (i.vehicleno ?? '').trim().isEmpty &&
            (i.notes ?? '').trim().isEmpty;

    if (allEmpty) return const SizedBox.shrink();

    /// 🔔 BLINK CARD IF ANY END VALUE IS MISSING
    final bool isEndTimeMissing =
        i.timeend == null || i.timeend!.isEmpty;

    final bool isStopReadingMissing =
        i.readingend == null ||
            i.readingend!.toString().trim().isEmpty;

    final bool shouldAnimate = isEndTimeMissing || isStopReadingMissing;

    Widget cardContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: shouldAnimate?ColorConstants.primary:Colors.white.withOpacity(0.8),
        border: shouldAnimate?Border.all(
          color: ColorConstants.primary.withOpacity(.6),
        ):null,
        gradient: shouldAnimate?  LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ColorConstants.primary.withOpacity(.9), ColorConstants.secondary.withOpacity(.1)],
        ):null,
        // boxShadow: shouldAnimate?[
        //   BoxShadow(
        //     color: ColorConstants.primary.withOpacity(0.25),
        //     blurRadius: 12,
        //     offset: const Offset(0, 6),
        //   ),
        // ]:null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Date
                  if ((i.readingDt ?? '').isNotEmpty)
                    Row(
                      children: [
                        Text("Date : ", style: GoogleFonts.poppins(fontSize: 10)),
                        Text(
                          formatMachineDate(i.readingDt),
                          style: GoogleFonts.poppins(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  /// Gate Pass
                  if ((i.gate_pass_no ?? '').trim().isNotEmpty)
                    Row(
                      children: [
                        Text("Gate pass number : ",
                            style: GoogleFonts.poppins(fontSize: 10)),
                        Text(
                          i.gate_pass_no!,
                          style: GoogleFonts.poppins(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                ],
              )
            ],
          ),
          /// Project + Amount
          Row(
            children: [
              if ((i.project_name ?? '').trim().isNotEmpty)
                Container(
                  width: 220,
                  child: Text(
                      "${i.project_name!}",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 1.2,
                          color: shouldAnimate?Colors.black:ColorConstants.primary,
                          fontWeight: FontWeight.bold),
                    ),
                ),
              if (i.amount.toString().isNotEmpty) ...[
                Expanded(child: Text("")),
                Column(
                  children: [
                    Text(
                      "${i.amount}",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold,height:1,color:shouldAnimate?Colors.black:ColorConstants.primary),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "(Amount)",
                      style: GoogleFonts.poppins(
                          fontSize: 10, color: shouldAnimate?Colors.black:ColorConstants.primary),
                    ),
                  ],
                )

              ],
            ],
          ),
          /// Vehicle Number
          if ((i.vehicleno ?? '').trim().isNotEmpty)
          Row(
            children: [
              Text(
                "Vehicle Number: ",
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.black.withOpacity(.6)),
              ),
              Expanded(
                child: Text(
                  i.vehicleno!,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          Row(
            children: [
              if(!shouldAnimate)
                ...[
                  sideGradientBar(ht: 30),
                  SizedBox(
                    width: 10,
                  ),],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    i.vendorname,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black.withOpacity(.6)),
                  ),
                  Text(
                    i.vehiclename!,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if(i.expendedtime.toString().isNotEmpty)
              ...[Expanded(child: Container()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Time spent",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color:Colors.black,
                    ),
                  ),
                  Text(
                    "${i.expendedtime}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )]
            ],
          ),
          Divider(color: Colors.grey.withOpacity(.1)),
          /// Time & Readings
          Row(
            children: [
              Expanded(
                child: _infoColumn(
                  "Start Time",
                  timeFormat(i.timestart),
                ),
              ),
              _verticalDivider(show: shouldAnimate),
              Expanded(
                child: _infoColumn(
                  "End Time",
                  isEndTimeMissing ? null : timeFormat(i.timeend),
                  placeholder: "Enter end time",
                ),
              ),
              _verticalDivider(show: shouldAnimate),
              Expanded(
                child: _infoColumn(
                  "Start Reading",
                  i.readingstart?.toString(),
                ),
              ),
              _verticalDivider(show: shouldAnimate),
              Expanded(
                child: _infoColumn(
                  "Stop Reading",
                  isStopReadingMissing ? null : i.readingend?.toString(),
                  placeholder: "Enter stop reading",
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              if (i.total_run.toString().isNotEmpty)
              ...[
                  Text(
                    "Total run : ",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color:Colors.black,
                    ),
                  ),
                  Text(
                    i.total_run ?? "",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
              Expanded(child: Text("")),
              Icon(Icons.edit, color: shouldAnimate?Colors.black:Colors.grey, size: 15),
              const SizedBox(width: 10),
              Container(
                height: 10,
                width: 1,
                color: shouldAnimate?Colors.black:Colors.grey.withOpacity(.6),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: (){
                  final parentContext = context;
                  showModalBottomSheet(
                    context: parentContext,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.black.withOpacity(0.6),
                    builder: (sheetContext) {
                      return BlocProvider.value(
                        value: parentContext.read<DeleteMachineReadingBloc>(),
                        child: OnDelete(
                          title1: 'Delete Machine Reading',
                          title2: 'Are you sure you want to delete this machine reading?',
                          onCancel: (){
                            Navigator.of(sheetContext).pop();
                          },
                          onConfirm: () {
                            _lastRemovedItem = i;
                            setState(() {
                              _allItems.removeWhere((element) => element.readingid == i.readingid);
                              _visibleItems.removeWhere((element) => element.readingid == i.readingid);
                            });
                            parentContext
                                .read<DeleteMachineReadingBloc>()
                                .add(SubmitDeleteMachineReadingEvent(readingid: i.readingid));
                            Navigator.of(sheetContext).pop();
                            // _onRefresh();
                          },
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.close,color: shouldAnimate?Colors.black:Colors.grey, size: 15),
                ),
              )

            ],
          )
        ],
      ),
    );

    /// 🔥 APPLY BLINK ANIMATION TO WHOLE CARD
    // if (shouldAnimate) {
    //   cardContent = FadeTransition(
    //     opacity: _opacity,
    //     child: ScaleTransition(
    //       scale: _scale,
    //       child: cardContent,
    //     ),
    //   );
    // }
    if (shouldAnimate) {
      cardContent = BlinkingCard(child: cardContent);
    }
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () async {
        final result = await Utils.navigateTo(
          context,
          AddMachineReading(id: i.readingid ?? ""),
        );
        if (result == "true") _onRefresh();
      },
      child: cardContent,
    );
  }

  Widget _infoColumn(String title, String? value, {String? placeholder}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 10)),
        const SizedBox(height: 2),
        value != null && value.isNotEmpty
            ?Text(
             value,
             maxLines: 1,
             overflow: TextOverflow.ellipsis,
             style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
         ):BlinkingText(
            text: placeholder ?? "",
            style: GoogleFonts.poppins(
            fontSize: 12,
            height: 1,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider({bool show=false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(height: 20, width: 1, child: ColoredBox(color: show?Colors.black:Colors.grey)),
      );

}

class BlinkingText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const BlinkingText({super.key, required this.text, this.style});

  @override
  State<BlinkingText> createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 1.0, end: 0.2).animate(_controller);
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
      child: Container(
        width: 100,
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: widget.style,
        ),
      ),
    );
  }
}

class BlinkingCard extends StatefulWidget {
  final Widget child;

  const BlinkingCard({super.key, required this.child});

  @override
  State<BlinkingCard> createState() => _BlinkingCardState();
}

class _BlinkingCardState extends State<BlinkingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scale = Tween<double>(begin: 0.97, end: 1.0).animate(
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
        child: widget.child,
      ),
    );
  }
}

