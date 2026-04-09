import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../api/models/DAOMaterialConsumptionList.dart';
import '../../../api/services/add_material_consumption.dart';
import '../../../bloc/DailyReporting/delete_material_consumption_bloc.dart';
import '../../../bloc/DailyReporting/get_material_consumption.dart';
import '../../../data/local/AppUtils.dart';
import '../../Utils/utils.dart';
import '../../Widgets/Bottom_Sheet.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/Date_Formate.dart';
import '../../Widgets/TextWidgets.dart';
import '../../Utils/colors_constants.dart';
import 'Add_Material_Consumption.dart';

class MaterialConsumption extends StatefulWidget {
  const MaterialConsumption({super.key});

  @override
  State<MaterialConsumption> createState() => _MaterialConsumptionState();
}

class _MaterialConsumptionState extends State<MaterialConsumption> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // paging
  static const int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _isInitialLoading = false;
  String? _error;

  // data
  final List<MaterialConsumptionList> _allItems = []; // master list accumulated from pages
  final List<MaterialConsumptionList> _visibleItems = []; // filtered by search

  late final MaterialConsumptionBloc _MaterialConsumptionBloc;
  late final DeleteMaterialConsumptionBloc _deleteBloc;

  Timer? _debounce;

  // store last optimistically removed item to re-insert on failure
  MaterialConsumptionList? _lastRemovedItem;
  String? loggedUserId;

  @override
  void initState() {
    super.initState();

    // create service + blocs (or obtain from parent provider)
    final service = MaterialConsumptionService();
    _MaterialConsumptionBloc = MaterialConsumptionBloc(service: service);
    _deleteBloc = DeleteMaterialConsumptionBloc();

    // load first page
    _loadPage(start: 0);
    // infinite scroll listener
    _scrollController.addListener(_onScroll);
    _loadLoggedUserId();
  }

  Future<void> _loadLoggedUserId() async {
    final id = await AppUtils().getUserID();
    setState(() {
      loggedUserId = id.toString();
    });
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
      setState(() { _isInitialLoading = true; _error = null; });
    } else {
      if (!mounted) return;
      setState(() { _isLoadingMore = true; });
    }
    _MaterialConsumptionBloc.add(FetchMaterialConsumptionsEvent(start: start, length: _pageSize));
  }

  Future<void> _onRefresh() async {
    _hasMore = true;
    _allItems.clear();
    _visibleItems.clear();
    setState(() {});
    _loadPage(start: 0);

    // wait until initial load finished
    while (_isInitialLoading) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _MaterialConsumptionBloc.close();
    _deleteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide both blocs to subtree so listeners can use them
    return MultiBlocProvider(
      providers: [
        BlocProvider<MaterialConsumptionBloc>.value(value: _MaterialConsumptionBloc),
        BlocProvider<DeleteMaterialConsumptionBloc>.value(value: _deleteBloc),
      ],
      child: Scaffold(
        backgroundColor: ColorConstants.background,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppbar(context, title: "Material Consumption", subTitle: "Material Sourcing and Utilization"),

                // Listen for material list results
                Expanded(
                  child: BlocListener<MaterialConsumptionBloc, MaterialConsumptionState>(
                    listener: (context, state) {
                      if (state is MaterialConsumptionLoadSuccess) {
                        // Append new items
                        final newItems = state.MaterialConsumption;
                        setState(() {
                          if (_allItems.isEmpty) {
                            _allItems.addAll(newItems);
                          } else {
                            _allItems.addAll(newItems);
                          }
                          final q = searchController.text.trim().toLowerCase();
                          if (q.isEmpty) {
                            _visibleItems
                              ..clear()
                              ..addAll(_allItems);
                          } else {
                            _visibleItems
                              ..clear()
                              ..addAll(_allItems.where((p) {
                                final name = (p.item ?? '').toLowerCase();
                                final cust = (p.item ?? '').toLowerCase();
                                final type = (p.item ?? '').toLowerCase();
                                return name.contains(q) || cust.contains(q) || type.contains(q);
                              }));
                          }

                          _isInitialLoading = false;
                          _isLoadingMore = false;
                          if (newItems.length < _pageSize) _hasMore = false;
                        });
                      } else if (state is MaterialConsumptionLoadFailure) {
                        setState(() {
                          _isInitialLoading = false;
                          _isLoadingMore = false;
                          _error = state.message;
                        });
                      }
                    },
                    child: BlocListener<DeleteMaterialConsumptionBloc, DeleteMaterialConsumptionState>(
                      listener: (context, state) {
                        debugPrint('DeleteMaterialConsumptionBloc -> ${state.runtimeType}');
                        if (state is DeleteMaterialConsumptionSuccess) {
                          _lastRemovedItem = null;
                          _onRefresh();
                        }
                      },

                      child: RefreshIndicator(
                        color: ColorConstants.primary,
                        backgroundColor: Colors.white,
                        onRefresh: _onRefresh,
                        child: _buildBody(),
                      ),
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () async {
                  final result = await Utils.navigateTo(
                    context,
                    AddMaterialConsumptionPage(id: '',),
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
                        "Add Material Consumption",
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

    final int extra = 2 + (_hasMore ? 1 : 0); // header + spacer + optional load-more
    final int totalCount = _visibleItems.length + extra;

    return ListView.separated(
      controller: _scrollController,
      itemCount: totalCount,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return header;
        }

        // data items start at index 2 -> map to _visibleItems[ index - 2 ]
        final dataIndex = index - 2;

        if (dataIndex < _visibleItems.length && dataIndex >= 0) {
          final i = _visibleItems[dataIndex];
          return _buildProjectCard(i);
        }

        if (_hasMore && dataIndex == _visibleItems.length) {
          if (!_isLoadingMore) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (!_isLoadingMore) _loadPage(start: _allItems.length);
            });
          }
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(color: ColorConstants.primary)),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProjectCard(MaterialConsumptionList i) {

    if(i.project_id==null || i.project_id.toString().trim().isEmpty){
      return const SizedBox.shrink();
    }
    // Check if all important fields are empty
    bool allEmpty = (i.gatePass == null || i.gatePass.toString().trim().isEmpty) &&
        ((i.item ?? '').trim().isEmpty) &&
        ((i.scrap ?? '').trim().isEmpty) &&
        ((i.used_quantity ?? '').trim().isEmpty) &&
        ((i.scrap ?? '').trim().isEmpty) &&
        ((i.total_amount?? '').trim().isEmpty);
    ((i.balance_quantity?? '').trim().isEmpty);
    ((i.rate?? '').trim().isEmpty);

    if (allEmpty) {
      return const SizedBox.shrink();
    }

    final String itemUserId = i.user_id?.toString() ?? '';
    final bool isOwner = loggedUserId != null && loggedUserId == itemUserId;

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () async {
        final result = await Utils.navigateTo(
          context,
          AddMaterialConsumption(id:i.consumption_id,isEditable:isOwner,),
        );
        if (result == "true") {
          _onRefresh();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(i.project_name.toString().isNotEmpty)
              Text(
                i.project_name??"",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color:Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        if (i.date.toString().isNotEmpty)
                          Text(
                            formatEntryDate(i.date ?? DateTime.now().toString()),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black.withOpacity(.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    if ((i.gatePass ?? '').trim().isNotEmpty)
                      Row(
                        children: [
                          Text(
                            "Gate Pass: ",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color:ColorConstants.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${i.gatePass}",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color:Colors.black.withOpacity(.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    if ((i.item ?? '').trim().isNotEmpty)
                      Container(
                        width: 55.w,
                        child: Text(
                          i.item,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black.withOpacity(.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Amount",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color:Colors.black,
                      ),
                    ),
                    Text(
                      "${i.total_amount}",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color:Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Container(
                  height: 35,
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
              ],
            ),
            Divider(
              color: Colors.grey.withOpacity(.2),
            ),
            Row(
              children: [
                if ((i.used_quantity ?? '').trim().isNotEmpty)
                  values("Quantity used",i.used_quantity),
                if ((i.scrap ?? '').trim().isNotEmpty)
                  values("Scarp",i.scrap),
                if ((i.balance_quantity ?? '').trim().isNotEmpty)
                  values("Balance Quantity",i.balance_quantity),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(isOwner?Icons.edit:Icons.visibility, color: Colors.grey, size: 15),
                const SizedBox(width: 10),
                Container(
                  height: 10,
                  width: 1,
                  color: Colors.grey.withOpacity(.6),
                ),
                const SizedBox(width: 10),
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
                            value: parentContext.read<DeleteMaterialConsumptionBloc>(),
                            child: OnDelete(
                              title1: 'Delete Material Consumption',
                              title2: 'Are you sure you want to delete this material consumption?',
                              onCancel: (){
                                Navigator.of(sheetContext).pop();
                              },
                              onConfirm: () {
                                // Save last removed item for rollback
                                _lastRemovedItem = i;

                                // Optimistic local remove so UI updates instantly
                                setState(() {
                                  _allItems.removeWhere((element) => element.consumption_id == i.consumption_id);
                                  _visibleItems.removeWhere((element) => element.consumption_id == i.consumption_id);
                                });

                                // Dispatch delete; DO NOT call _onRefresh() here.
                                parentContext
                                    .read<DeleteMaterialConsumptionBloc>()
                                    .add(SubmitDeleteMaterialConsumptionEvent(consumption_id: i.consumption_id??""));

                                Navigator.of(sheetContext).pop();
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.close, color: Colors.grey, size: 15)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget values(String title,String val)
  {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.black.withOpacity(.6),
            ),
          ),
          Text(
            val,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black.withOpacity(.6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

}
