import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../api/models/DAOGetGatePass.dart';
import '../../../api/services/add_gate_pass_service.dart';
import '../../../bloc/GatePass/delete_gate_pass_bloc.dart';
import '../../../bloc/GatePass/delete_gate_pass_project_bloc.dart';
import '../../../bloc/GatePass/delete_gate_pass_warehouse_bloc.dart';
import '../../../bloc/GatePass/gate_pass_bloc.dart';
import '../../Utils/utils.dart';
import '../../Widgets/Bottom_Sheet.dart';
import '../../Widgets/Custom_Date_Time_Picker.dart';
import '../../Widgets/Custom_Dropdown.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/Date_Formate.dart';
import '../../Widgets/Gradient.dart';
import '../../Widgets/TextWidgets.dart';
import '../../Utils/colors_constants.dart';
import 'Add_Gate_Pass.dart';
import 'Gate_Pass_Detail.dart';

class GatePass extends StatefulWidget {
  const GatePass({super.key});

  @override
  State<GatePass> createState() => _GatePassState();
}

class _GatePassState extends State<GatePass> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  final transferType = ['Warehouse Type', 'Project Type'];
  String selectedTransfer = "";
  // paging
  static const int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _isInitialLoading = false;
  String? _error;

  // data
  final List<GatePassData> _allItems = []; // master list accumulated from pages
  final List<GatePassData> _visibleItems = []; // filtered by search

  late final GatePassBloc _GatePassBloc;

  Timer? _debounce;

  // filters (server-side)
  String gatePass = "";
  String itemSelected = "";
  String transferSelected = "";
  String dateFrom = "";
  String dateTo = "";

  // delete blocs (page-level)
  late final DeleteGatePassBloc _deleteGatePassBloc;
  late final DeleteGatePassProjectBloc _deleteGatePassProjectBloc;
  late final DeleteGatePassWarehouseBloc _deleteGatePassWarehouseBloc;

  // optimistic rollback storage
  GatePassData? _lastRemovedItem;
  int? _lastRemovedIndex;

  // pending deletes tracker — will contain keys like "gatepass","project","warehouse"
  final Set<String> _pendingDeletes = {};
  bool _isEmpty(String? val) => val == null || val.trim().isEmpty;

  @override
  void initState() {
    super.initState();
    final service = GatePassService();
    _GatePassBloc = GatePassBloc(service: service);

    // create delete blocs
    _deleteGatePassBloc = DeleteGatePassBloc();
    _deleteGatePassProjectBloc = DeleteGatePassProjectBloc();
    _deleteGatePassWarehouseBloc = DeleteGatePassWarehouseBloc();

    // search debounce
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _applyLocalSearch();
      });
    });

    _loadPage(start: 0);
    _scrollController.addListener(_onScroll);
  }

  void _applyLocalSearch() {
    final q = searchController.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _visibleItems
          ..clear()
          ..addAll(_allItems);
      } else {
        _visibleItems
          ..clear()
          ..addAll(
            _allItems.where((p) {
              final gate = (p.gate_pass ?? '').toString().toLowerCase();
              final material =
                  (p.issued_material ?? '').toString().toLowerCase();
              final fromWh =
                  (p.from_warehouse_name ?? '').toString().toLowerCase();
              final toWh = (p.to_warehouse_name ?? '').toString().toLowerCase();
              final proj = (p.to_project_name ?? '').toString().toLowerCase();
              final transfer = (p.transfer_type ?? '').toString().toLowerCase();
              final outTime = (p.out_time ?? '').toString().toLowerCase();

              return gate.contains(q) ||
                  material.contains(q) ||
                  fromWh.contains(q) ||
                  toWh.contains(q) ||
                  proj.contains(q) ||
                  transfer.contains(q) ||
                  outTime.contains(q);
            }),
          );
      }
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
    // defensive: avoid duplicate loads
    if ((start == 0 && _isInitialLoading) || (start > 0 && _isLoadingMore)) {
      return;
    }

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

    _GatePassBloc.add(
      FetchGatePasssEvent(
        start: start,
        length: _pageSize,
        from: dateFrom,
        to: dateTo,
        gate_pass_number: gatePass,
        transferType: transferSelected,
        item: itemSelected,
      ),
    );
  }

  Future<void> _onRefresh() async {
    dateFrom = "";
    dateTo = "";
    _selectedFromDate = null;
    _selectedToDate = null;
    selectedTransfer = "";
    transferSelected = "";
    _hasMore = true;
    _allItems.clear();
    _visibleItems.clear();
    searchController.text = "";
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
    _GatePassBloc.close();
    _deleteGatePassBloc.close();
    _deleteGatePassProjectBloc.close();
    _deleteGatePassWarehouseBloc.close();
    super.dispose();
  }

  void _clearPendingDeletes() {
    _pendingDeletes.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Provide GatePassBloc + delete blocs to subtree
    return MultiBlocProvider(
      providers: [
        BlocProvider<GatePassBloc>.value(value: _GatePassBloc),
        BlocProvider<DeleteGatePassBloc>.value(value: _deleteGatePassBloc),
        BlocProvider<DeleteGatePassProjectBloc>.value(
          value: _deleteGatePassProjectBloc,
        ),
        BlocProvider<DeleteGatePassWarehouseBloc>.value(
          value: _deleteGatePassWarehouseBloc,
        ),
      ],
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
                  title: "Gate Pass",
                  subTitle: "View and manage all gate passes",
                ),
                Expanded(
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<GatePassBloc, GatePassState>(
                        listener: (context, state) {
                          if (state is GatePassLoadSuccess) {
                            final newItems = state.GatePass ?? [];
                            setState(() {
                              // append new items (avoid duplicates)
                              for (var ni in newItems) {
                                final exists = _allItems.any(
                                  (e) => e.gatepass_id == ni.gatepass_id,
                                );
                                if (!exists) _allItems.add(ni);
                              }

                              // update visible list using local search box
                              final q =
                                  searchController.text.trim().toLowerCase();
                              if (q.isEmpty) {
                                _visibleItems
                                  ..clear()
                                  ..addAll(_allItems);
                              } else {
                                _visibleItems
                                  ..clear()
                                  ..addAll(
                                    _allItems.where((p) {
                                      final gate =
                                          (p.gate_pass ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final material =
                                          (p.issued_material ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final fromWh =
                                          (p.from_warehouse_name ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final toWh =
                                          (p.to_warehouse_name ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final proj =
                                          (p.to_project_name ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final transfer =
                                          (p.transfer_type ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final outTime =
                                          (p.out_time ?? '')
                                              .toString()
                                              .toLowerCase();

                                      return gate.contains(q) ||
                                          material.contains(q) ||
                                          fromWh.contains(q) ||
                                          toWh.contains(q) ||
                                          proj.contains(q) ||
                                          transfer.contains(q) ||
                                          outTime.contains(q);
                                    }),
                                  );
                              }

                              // clear loading flags
                              _isInitialLoading = false;
                              _isLoadingMore = false;

                              // pagination
                              if (newItems.length < _pageSize) {
                                _hasMore = false;
                              } else {
                                _hasMore = true;
                              }
                            });
                          } else if (state is GatePassLoadFailure) {
                            setState(() {
                              _isInitialLoading = false;
                              _isLoadingMore = false;
                              _error = state.message;
                            });
                          }
                        },
                      ),
                      BlocListener<DeleteGatePassBloc, DeleteGatePassState>(
                        listener: (context, state) {
                          if (state is DeleteGatePassSuccess) {
                            // Remove 'gatepass' from pending. If no more pending, refresh.
                            _pendingDeletes.remove('gatepass');
                            if (_pendingDeletes.isEmpty) {
                              // all deletes done -> refresh
                              _lastRemovedItem = null;
                              _lastRemovedIndex = null;
                              _onRefresh();
                            }
                          } else if (state is DeleteGatePassFailed) {
                            // rollback optimistic removal if present
                            if (_lastRemovedItem != null) {
                              setState(() {
                                final idx = _lastRemovedIndex ?? 0;
                                final insertIndex =
                                    (idx <= _allItems.length)
                                        ? idx
                                        : _allItems.length;
                                _allItems.insert(
                                  insertIndex,
                                  _lastRemovedItem!,
                                );
                                // reapply visible filter
                                _applyLocalSearch();
                              });
                              _lastRemovedItem = null;
                              _lastRemovedIndex = null;
                            }
                            _clearPendingDeletes();
                          }
                        },
                      ),
                      BlocListener<
                        DeleteGatePassProjectBloc,
                        DeleteGatePassProjectState
                      >(
                        listener: (context, state) {
                          if (state is DeleteGatePassProjectSuccess) {
                            _pendingDeletes.remove('project');
                            if (_pendingDeletes.isEmpty) {
                              _lastRemovedItem = null;
                              _lastRemovedIndex = null;
                              _onRefresh();
                            }
                          } else if (state is DeleteGatePassProjectFailed) {
                            // rollback
                            if (_lastRemovedItem != null) {
                              setState(() {
                                final idx = _lastRemovedIndex ?? 0;
                                final insertIndex =
                                    (idx <= _allItems.length)
                                        ? idx
                                        : _allItems.length;
                                _allItems.insert(
                                  insertIndex,
                                  _lastRemovedItem!,
                                );
                                _applyLocalSearch();
                              });
                              _lastRemovedItem = null;
                              _lastRemovedIndex = null;
                            }
                            _clearPendingDeletes();
                          }
                        },
                      ),
                      BlocListener<
                        DeleteGatePassWarehouseBloc,
                        DeleteGatePassWarehouseState
                      >(
                        listener: (context, state) {
                          if (state is DeleteGatePassWarehouseSuccess) {
                            _pendingDeletes.remove('warehouse');
                            if (_pendingDeletes.isEmpty) {
                              _lastRemovedItem = null;
                              _lastRemovedIndex = null;
                              _onRefresh();
                            }
                          } else if (state is DeleteGatePassWarehouseFailed) {
                            if (_lastRemovedItem != null) {
                              setState(() {
                                final idx = _lastRemovedIndex ?? 0;
                                final insertIndex =
                                    (idx <= _allItems.length)
                                        ? idx
                                        : _allItems.length;
                                _allItems.insert(
                                  insertIndex,
                                  _lastRemovedItem!,
                                );
                                _applyLocalSearch();
                              });
                              _lastRemovedItem = null;
                              _lastRemovedIndex = null;
                            }
                            _clearPendingDeletes();
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
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 20),
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
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
                        side: BorderSide(color: Colors.grey.withOpacity(.2)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
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
                              hintText: "Search by item and gate pass",
                              hintStyle: TextStyle(fontSize: 13),
                              border: InputBorder.none,
                            ),
                            onChanged: (v) {
                              final q = v.trim().toLowerCase();
                              setState(() {
                                _visibleItems
                                  ..clear()
                                  ..addAll(
                                    _allItems.where((p) {
                                      final gate =
                                          (p.gate_pass ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final material =
                                          (p.issued_material ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final fromWh =
                                          (p.from_warehouse_name ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final toWh =
                                          (p.to_warehouse_name ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final proj =
                                          (p.to_project_name ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final transfer =
                                          (p.transfer_type ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final outTime =
                                          (p.out_time ?? '')
                                              .toString()
                                              .toLowerCase();

                                      return gate.contains(q) ||
                                          material.contains(q) ||
                                          fromWh.contains(q) ||
                                          toWh.contains(q) ||
                                          proj.contains(q) ||
                                          transfer.contains(q) ||
                                          outTime.contains(q);
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
              const SizedBox(width: 10),
              InkWell(
                onTap: () async {
                  final result = await Utils.navigateTo(
                    context,
                    AddGatePassPage(id: ""),
                  );
                  if (result == "true") {
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
                      side: BorderSide(color: Colors.grey.withOpacity(.2)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: ColorConstants.primary,
                  ),
                  child: const Icon(Icons.add, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomDateTimeTextField(
                  onTap: _pickFromDate,
                  hint:
                      _selectedFromDate == null
                          ? '-- From Date --'
                          : DateFormat("d MMMM y").format(_selectedFromDate!),
                  icon: Icons.calendar_month,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomDateTimeTextField(
                  onTap: _pickToDate,
                  hint:
                      _selectedToDate == null
                          ? '-- To Date --'
                          : DateFormat("d MMMM y").format(_selectedToDate!),
                  icon: Icons.calendar_month,
                ),
              ),
            ],
          ),
          TransferDropdown<String>(
            title: "Transfer Type",
            hint: 'Select Transfer Type',
            selectedVal: selectedTransfer,
            data: transferType,
            displayText: (t) => t,
            onChanged: (val) {
              selectedTransfer = val;
              _applyFiltersAndReload();
            },
          ),
        ],
      ),
    );

    // If still initial loading, show header + spinner
    if (_isInitialLoading && _allItems.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          header,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
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
        ],
      );
    }

    final bool filtersApplied =
        (searchController.text.trim().isNotEmpty) ||
        selectedTransfer != null ||
        _selectedFromDate != null ||
        _selectedToDate != null;

    if (!_isInitialLoading && _visibleItems.isEmpty) {
      if (filtersApplied) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            header,
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: ColorConstants.primary.withOpacity(.07),
                    ),
                    child: const Icon(
                      Icons.search_off,
                      size: 20,
                      color: ColorConstants.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No records found for search result',
                    style: GoogleFonts.poppins(
                      color: ColorConstants.primary.withOpacity(.6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _onRefresh();
                        },
                        child: Container(
                          width: 40.w,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: ColorConstants.primary,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: cText(
                              "Clear filters",
                              color: ColorConstants.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          header,
          const SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                const Icon(Icons.inbox, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  'No gate pass records found',
                  style: GoogleFonts.poppins(color: Colors.black54),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    setState(() {
                      _hasMore = true;
                      _isInitialLoading = true;
                      _allItems.clear();
                      _visibleItems.clear();
                    });
                    _loadPage(start: 0);
                  },
                  child: Container(
                    width: 40.w,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: ColorConstants.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: cText("Reload", color: ColorConstants.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final int extra =
        2 + (_hasMore ? 1 : 0); // header + spacer + optional load-more
    final int totalCount = _visibleItems.length + extra;

    return ListView.separated(
      controller: _scrollController,
      itemCount: totalCount,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return header;
        }
        if (index == 1) {
          return const SizedBox(height: 10);
        }
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
            child: Center(
              child: CircularProgressIndicator(color: ColorConstants.primary),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProjectCard(GatePassData i) {
    final bool allEmpty =
        _isEmpty(i.gate_pass) &&
        _isEmpty(i.to_project_name) &&
        _isEmpty(i.from_warehouse_name) &&
        _isEmpty(i.to_warehouse_name) &&
        _isEmpty(i.out_time) &&
        (i.quantity?.toString() == "0") &&
        (i.issued_material?.toString() == "0") &&
        _isEmpty(i.transfer_type);

    if (allEmpty) return const SizedBox.shrink();

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () async {
        final result = await Utils.navigateTo(context, GatePassDetail(data: i));
        if (result == "true") _onRefresh();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Gate Pass Number
            if (!_isEmpty(i.gate_pass))
              Text(
                "Gno. ${i.gate_pass}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 5),

            /// Material + Quantity + Out Time
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _materialInfo(i)),
                if (!_isEmpty(i.out_time)) ...[
                  const SizedBox(width: 8),
                  Flexible(fit: FlexFit.tight, child: _outTime(i)),
                ],

                const SizedBox(width: 8),
                sideGradientBar(),
              ],
            ),
            Divider(color: Colors.grey.withOpacity(.2)),
            _fromToSection(i),
            const SizedBox(height: 10),
            _footerActions(i),
          ],
        ),
      ),
    );
  }

  Widget _materialInfo(GatePassData i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_isEmpty(i.issued_material))
          Text(
            "${i.issued_material}",
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1,
              color: ColorConstants.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (i.group_names.toString().isNotEmpty)
          Text(
            i.group_names!,
            maxLines: 1,
            // overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (i.subgroup_names.toString().isNotEmpty)
          Text(
            "${i.subgroup_names}",
            maxLines: 1,
            // overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (!_isEmpty(i.quantity?.toString()))
          values("Issued Quantity", i.quantity.toString()),
      ],
    );
  }

  Widget _outTime(GatePassData i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Out time",
          style: GoogleFonts.poppins(fontSize: 10),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          i.out_time ?? "",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _fromToSection(GatePassData i) {
    final bool isProject =
        i.transfer_type == "project_type" || i.transfer_type == "Project Type";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_isEmpty(i.from_warehouse_name))
          _locationBlock("From Warehouse", i.from_warehouse_name),

        const Spacer(),

        Icon(Icons.arrow_forward, size: 14, color: Colors.grey),

        const Spacer(),

        _locationBlock(
          isProject ? "Project" : "To Warehouse",
          isProject ? i.to_project_name : i.to_warehouse_name,
        ),
      ],
    );
  }

  Widget _locationBlock(String title, String? value) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 120,
          child: Text(
            value ?? "-",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _footerActions(GatePassData i) {
    return Row(
      children: [
        if (!_isEmpty(i.date))
          Text(
            "Added on: ${formatEntryDate(i.date!)}",
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

        const Spacer(),
        const Icon(Icons.visibility, size: 15, color: Colors.grey),
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
                  // pass existing gatepass delete bloc into the sheet subtree
                  value: parentContext.read<DeleteGatePassBloc>(),
                  child: OnDelete(
                    title1: 'Delete Gate Pass',
                    title2: 'Are you sure you want to delete this gate pass?',
                    onCancel: () {
                      Navigator.of(sheetContext).pop();
                    },
                    onConfirm: () {
                      // Save last removed item + index for rollback
                      _lastRemovedIndex = _allItems.indexWhere(
                        (e) => e.gatepass_id == i.gatepass_id,
                      );
                      if (_lastRemovedIndex == -1) _lastRemovedIndex = null;
                      _lastRemovedItem = i;

                      // Optimistic local remove (so UI is snappy)
                      setState(() {
                        _allItems.removeWhere(
                          (element) => element.gatepass_id == i.gatepass_id,
                        );
                        _visibleItems.removeWhere(
                          (element) => element.gatepass_id == i.gatepass_id,
                        );
                      });

                      // Track pending deletes
                      _pendingDeletes.add('gatepass');
                      if (i.transfer_type == "warehouse_type") {
                        _pendingDeletes.add('warehouse');
                      } else {
                        _pendingDeletes.add('project');
                      }

                      // Dispatch delete events to provided blocs (they are provided at page level)
                      parentContext.read<DeleteGatePassBloc>().add(
                        SubmitDeleteGatePassEvent(
                          gatepass_id: i.gatepass_id ?? "",
                        ),
                      );
                      if (i.transfer_type == "warehouse_type") {
                        print(i.transfer_type);
                        print('''
                                    from_warehouse_id: ${i.from_warehouse_id},
                                    to_warehouse_id: ${i.to_warehouse_id},
                                    issued_material: ${i.issued_material},
                                    quantity: ${i.quantity},
                                    ''');
                        parentContext.read<DeleteGatePassWarehouseBloc>().add(
                          SubmitDeleteGatePassWarehouseEvent(
                            from_warehouse_id: i.from_warehouse_id,
                            to_warehouse_id: i.to_warehouse_id,
                            issued_material: i.issued_material,
                            quantity: i.quantity,
                          ),
                        );
                      } else {
                        print(i.transfer_type);
                        print('''
                                  gate_pass: ${i.gate_pass},
                                  from_warehouse_id: ${i.from_warehouse_id},
                                  to_project_id: ${i.to_project_id},
                                  issued_material: ${i.issued_material},
                                  quantity: ${i.quantity},
                                  out_time: ${i.out_time},
                                  consumed: ${i.consumed},
                                  date: ${i.date},
                                    ''');
                        parentContext.read<DeleteGatePassProjectBloc>().add(
                          SubmitDeleteGatePassProjectEvent(
                            gate_pass: i.gate_pass,
                            from_warehouse_id: i.from_warehouse_id,
                            to_project_name: i.to_project_id,
                            issued_material: i.issued_material,
                            quantity: i.quantity,
                            out_time: i.out_time,
                            consumed: i.consumed,
                            date: i.date,
                          ),
                        );
                      }
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: const Icon(Icons.close, color: Colors.grey, size: 15),
          ),
        ),
      ],
    );
  }

  Widget values(String title, String val) {
    return Container(
      child: Row(
        children: [
          Text(
            val,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black.withOpacity(.6),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " material issused",
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.black.withOpacity(.6),
            ),
          ),
        ],
      ),
    );
  }

  void _applyDateFilterAndReload() {
    dateFrom =
        _selectedFromDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedFromDate!)
            : "";
    dateTo =
        _selectedToDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedToDate!)
            : "";

    _hasMore = true;
    _allItems.clear();
    _visibleItems.clear();
    _error = null;

    if (mounted) setState(() {});

    _loadPage(start: 0);
  }

  void _applyFiltersAndReload() {
    if (selectedTransfer == "Warehouse Type") {
      transferSelected = "warehouse_type";
    } else {
      transferSelected = "project_type";
    }
    _hasMore = true;
    _allItems.clear();
    _visibleItems.clear();
    _error = null;

    if (mounted) setState(() {});
    _loadPage(start: 0);
  }

  Future<void> _pickFromDate() async {
    DateTime initial = _selectedFromDate ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.grey.withOpacity(.6),
            colorScheme: ColorScheme.light(
              primary: ColorConstants.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                color: ColorConstants.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              dividerColor: Colors.grey.withOpacity(.6),
              dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return ColorConstants.primary;
                }
                return null;
              }),
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return Colors.black;
              }),
              dayShape: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white, width: 2),
                  );
                }
                return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                );
              }),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorConstants.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedFromDate = date;
        if (_selectedToDate == null ||
            _selectedToDate!.isBefore(_selectedFromDate!)) {
          _selectedToDate = _selectedFromDate;
        }
      });

      _applyDateFilterAndReload();
    }
  }

  Future<void> _pickToDate() async {
    DateTime initial = _selectedToDate ?? (_selectedFromDate ?? DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _selectedFromDate ?? DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.grey.withOpacity(.6),
            colorScheme: ColorScheme.light(
              primary: ColorConstants.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                color: ColorConstants.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              dividerColor: Colors.grey.withOpacity(.6),
              dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return ColorConstants.primary;
                }
                return null;
              }),
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return Colors.black;
              }),
              dayShape: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white, width: 2),
                  );
                }
                return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                );
              }),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorConstants.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedToDate = date;
        if (_selectedFromDate == null ||
            _selectedFromDate!.isAfter(_selectedToDate!)) {
          _selectedFromDate = _selectedToDate;
        }
      });

      _applyDateFilterAndReload();
    }
  }
}
