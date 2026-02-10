import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../api/models/DAOGetProject.dart';
import '../../../api/services/get_project_service.dart';
import '../../../bloc/ProjectBloc/delete_project_bloc.dart';
import '../../../bloc/ProjectBloc/get_project_bloc.dart';
import '../../../data/local/AppUtils.dart';
import '../../Utils/utils.dart';
import '../../Widgets/Bottom_Sheet.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/Date_Formate.dart';
import '../../Widgets/TextWidgets.dart';
import '../../Utils/colors_constants.dart';
import 'Add_Project.dart';

class AllProjects extends StatefulWidget {
  const AllProjects({super.key});

  @override
  State<AllProjects> createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjects> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _isInitialLoading = false;
  String? _error;
  String? loggedUserId;
  final List<ProjectData> _allItems = []; // master list accumulated from pages
  final List<ProjectData> _visibleItems = []; // filtered by search
  late final ProjectBloc _projectBloc;
  int records_total=0;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final service = ProjectService();
    _projectBloc = ProjectBloc(service: service);
    _loadPage(start: 0);
    _scrollController.addListener(_onScroll);
    searchController.addListener(_onSearchChanged);
    _loadLoggedUserId();
  }

  void _onSearchChanged() {
    // debounce to avoid too many rebuilds
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final q = searchController.text.trim().toLowerCase();
      setState(() {
        if (q.isEmpty) {
          _visibleItems
            ..clear()
            ..addAll(_allItems);
        } else {
          _visibleItems
            ..clear()
            ..addAll(_allItems.where((p) {
              final name = (p.project_name ?? '').toLowerCase();
              final cust = (p.customerName ?? '').toLowerCase();
              final type = (p.project_type ?? '').toLowerCase();
              return name.contains(q) || cust.contains(q) || type.contains(q);
            }));
        }
      });
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
    _projectBloc.add(FetchProjectsEvent(start: start, length: _pageSize,project_name:""));
  }

  Future<void> _onRefresh() async {
    _hasMore = true;
    _allItems.clear();
    _visibleItems.clear();
    setState(() {});
    _loadPage(start: 0);
    // while (_isInitialLoading) {
    //   await Future.delayed(const Duration(milliseconds: 50));
    // }
  }

  Future<void> _loadLoggedUserId() async {
    final id = await AppUtils().getUserID();
    setState(() {
      loggedUserId = id.toString();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _projectBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProjectBloc>.value(value: _projectBloc,),
        BlocProvider<DeleteProjectBloc>(create: (_) => DeleteProjectBloc(),),
      ],
      child: Scaffold(
        backgroundColor: ColorConstants.background,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppbar(context,
                    title: "Projects", subTitle: "Manage your construction projects"),
                Expanded(
                  child: BlocListener<ProjectBloc, ProjectState>(
                    listener: (context, state) {
                      if (state is ProjectLoading) {
                        // handled by flags when we initiated fetch
                      } else if (state is ProjectLoadSuccess) {
                        // Append new items
                        final newItems = state.projects;
                        records_total=state.recordsTotal;
                        setState(() {
                          _allItems.addAll(newItems);
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
                                final name = (p.project_name ?? '').toLowerCase();
                                final cust = (p.customerName ?? '').toLowerCase();
                                final type = (p.project_type ?? '').toLowerCase();
                                return name.contains(q) || cust.contains(q) || type.contains(q);
                              }));
                          }
                          _isInitialLoading = false;
                          _isLoadingMore = false;
                          // if (newItems.length < _pageSize) _hasMore = false;
                          _hasMore = _allItems.length < records_total;

                        });
                      } else if (state is ProjectLoadFailure) {
                        setState(() {
                          _isInitialLoading = false;
                          _isLoadingMore = false;
                          _error = state.message;
                        });
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
      margin: const EdgeInsets.only(top: 10,),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey.withOpacity(.3)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "TOTAL PROJECTS:",
                style: txt_bold(color: ColorConstants.primary, textSize: 14),
              ),
              const SizedBox(width: 10),
              Text(
                // "${_allItems.length}",
                "${records_total}",
                style: txt_bold(color: Colors.black, textSize: 22),
              ),
              const SizedBox(width: 10),
              Text(
                "available",
                style: txt_bold(color: Colors.grey, textSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    decoration: ShapeDecoration(
                      shape: ContinuousRectangleBorder(
                          side: BorderSide(color: Colors.grey.withOpacity(.2)),
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(5),
                            child: Icon(FeatherIcons.search, color: ColorConstants.primary, size: 15)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            cursorColor: ColorConstants.primary,
                            onSubmitted: (val){
                              _onSearchChanged();
                            },
                            decoration: const InputDecoration(
                              hintText: "Search projects...",
                              border: InputBorder.none,
                            ),
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
                    AddProject(projectId: ""),
                  );
                  if(result == "true")
                  {
                    print('Project added successfully');
                    _onRefresh();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: ShapeDecoration(
                      shape: ContinuousRectangleBorder(
                          side: BorderSide(color: Colors.grey.withOpacity(.2)),
                          borderRadius: BorderRadius.circular(30)),
                      color: ColorConstants.primary),
                  child: const Icon(Icons.add, size: 18, color: Colors.white),
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
          header,
          const SizedBox(height: 30),
          const Center(child: CircularProgressIndicator(
            color: ColorConstants.primary,
          )),
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
                  onTap: (){
                    _loadPage(start: 0);
                  },
                  child: Container(
                    // height: 20,
                    width: 40.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: ColorConstants.primary
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: cText("Retry",color: ColorConstants.primary),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }
    return ListView.separated(
      controller: _scrollController,
      // padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _visibleItems.length + 2 + (_hasMore ? 1 : 0),
      // +2 for header and spacing, +1 for load-more indicator
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return header;
        }
        if (index == 1) {
          return const SizedBox(height: 1);
        }

        final dataIndex = index - 2;
        if (dataIndex < _visibleItems.length) {
          final i = _visibleItems[dataIndex];
          return _buildProjectCard(i);
        }

        // load more indicator
        if (_hasMore) {
          // if (!_isLoadingMore) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     if (!mounted) return;
          //     // extra guard so we don't schedule repeatedly
          //     if (!_isLoadingMore) _loadPage(start: _allItems.length);
          //   });
          // }
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(
              color: ColorConstants.primary,
            )),
          );
        }


        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProjectCard(ProjectData i) {
    final status = (i.status ?? '').toLowerCase();
    Color bg = ColorConstants.primary.withOpacity(.2);
    Color fg = ColorConstants.primary;

    if (status == 'enabled') {
      bg = Colors.green.withOpacity(.2);
      fg = Colors.green;
    } else if (status == 'disabled') {
      bg = ColorConstants.redColor.withOpacity(.2);
      fg = ColorConstants.redColor;
    }
    // Safely get description and check if it has visible content
    final desc = (i.project_dscription ?? '').trim();
    final hasDescription = desc.isNotEmpty;

    final String itemUserId = i.user_id?.toString() ?? '';
    final bool isOwner = loggedUserId != null && loggedUserId == itemUserId;

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () async {
        final result = await Utils.navigateTo(
          context, AddProject(projectId: i.project_id ?? ""),
        );
        if(result == "true")
        {
          print('Project added successfully, fetching the updated list...');
          _onRefresh();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header row
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
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(i.project_start_date!.isNotEmpty)
                    Text(
                      formatDate(i.project_start_date ?? DateTime.now().toString()),
                      style: GoogleFonts.poppins(
                        height: 1,
                        fontSize: 12,
                        color: Colors.black.withOpacity(.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if(i.project_manager!.isNotEmpty)
                    Text(
                      "${i.project_manager}",
                      style: GoogleFonts.poppins(
                        height: 1,
                        fontSize: 14,
                        color: ColorConstants.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if(status.isNotEmpty)
                ...[const Expanded(child: SizedBox()),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1, color: bg),
                    color: bg,
                  ),
                  child: Text(
                    status == 'enabled'? "Enabled" : "Disabled",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: fg,
                    ),
                  ),
                ),]
              ],
            ),
            const SizedBox(height: 5),
            if ((i.customerName ?? '').trim().isNotEmpty)...[
            Row(
                children: [
                  Text(
                    'customer : ',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${i.customerName}',
                      style: GoogleFonts.poppins(
                        height: 1,
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    i.project_name ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            // only show description section when it exists
            if (hasDescription) ...[
              Text(
                desc,
                style: GoogleFonts.poppins(
                  height: 1,
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // const SizedBox(height: 10),
               Divider(
                color: Colors.grey.withOpacity(.2),
              ),
              const SizedBox(height: 5),
            ],
            Row(
              children: [
                if(i.project_type!.isNotEmpty)
                ...[
                Text(
                  "Type : ",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  i.project_type??"",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: ColorConstants.primary,
                    fontWeight: FontWeight.w500,
                  ),
                 ),
                ],
                Expanded(child: Text("")),
                Icon(isOwner?Icons.edit:Icons.visibility, color: Colors.grey, size: 15),
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
                        return BlocProvider.value(
                          // pass existing bloc instance into the sheet subtree
                          value: parentContext.read<DeleteProjectBloc>(),
                          child: OnDelete(
                          title1: 'Delete Project',
                          title2: 'Are you sure you want to delete this project?',
                          onCancel: (){
                            Navigator.of(sheetContext).pop();
                          },
                          onConfirm: () {
                              // use parentContext (provider exists there). Close the sheet after dispatch.
                              parentContext
                                  .read<DeleteProjectBloc>()
                                  .add(SubmitDeleteProjectEvent(project_id: i.project_id ?? ""));
                              // optionally close the bottom sheet immediately:
                              Navigator.of(sheetContext).pop();
                              _onRefresh();
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                      child: const Icon(Icons.close, color: Colors.grey, size: 15)
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}
