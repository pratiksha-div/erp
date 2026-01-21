import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../Utils/colors_constants.dart';
import 'TextWidgets.dart';

class MultiSelectDropdown<T> extends StatefulWidget {
  final String title;
  final String hint;
  final List<T> data;
  final List<T> selectedValues;
  final String Function(T) displayText;
  final void Function(List<T>)? onChanged;

  const MultiSelectDropdown({
    super.key,
    required this.title,
    required this.hint,
    required this.data,
    required this.displayText,
    this.selectedValues = const [],
    this.onChanged,
  });

  @override
  State<MultiSelectDropdown<T>> createState() => _MultiSelectDropdownState<T>();
}

class _MultiSelectDropdownState<T> extends State<MultiSelectDropdown<T>> {
  late TextEditingController textController;
  FocusNode _focusNode = FocusNode();
  List<T> _selected = [];
  List<T> _filtered = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.selectedValues);
    textController = TextEditingController(text: _selectedLabelText());
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant MultiSelectDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // update if parent changed selectedValues or data
    if (oldWidget.selectedValues != widget.selectedValues) {
      _selected = List<T>.from(widget.selectedValues);
      _updateTextFromSelected();
    }
    if (oldWidget.data != widget.data) {
      // potentially update filtered if typing
      if (textController.text.trim().isNotEmpty) _updateFilter(textController.text);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  String _norm(String s) => s.trim().toLowerCase();

  String _selectedLabelText() {
    if (_selected.isEmpty) return '';
    return _selected.map((e) => widget.displayText(e)).join(', ');
  }

  void _updateTextFromSelected() {
    final txt = _selectedLabelText();
    textController.text = txt;
    textController.selection = TextSelection.fromPosition(TextPosition(offset: txt.length));
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) setState(() => _showSuggestions = false);
      });
    } else {
      if (textController.text.trim().isNotEmpty) {
        _updateFilter(textController.text);
      }
    }
  }

  void _updateFilter(String input) {
    final q = _norm(input);
    if (q.isEmpty) {
      setState(() {
        _filtered = [];
        _showSuggestions = false;
      });
      return;
    }

    final results = widget.data.where((item) => _norm(widget.displayText(item)).contains(q)).toList();

    setState(() {
      _filtered = results;
      _showSuggestions = results.isNotEmpty;
    });
  }

  bool _isSelected(T item) {
    // compare by displayText for generic equality (works in most UIs)
    final key = widget.displayText(item);
    return _selected.any((s) => widget.displayText(s) == key);
  }

  void _toggleSelection(T item) {
    final already = _isSelected(item);
    setState(() {
      if (already) {
        _selected.removeWhere((s) => widget.displayText(s) == widget.displayText(item));
      } else {
        _selected.add(item);
      }
      _updateTextFromSelected();
    });
    if (widget.onChanged != null) widget.onChanged!(List<T>.from(_selected));
  }

  void _unfocus() => FocusScope.of(context).unfocus();

  Future<void> _openSelectionDialog() async {
    _unfocus();
    // show dialog with checkboxes and Done button
    final selectedCopy = List<T>.from(_selected);
    final picked = await showDialog<List<T>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          bool _isSelectedDialog(T item) => selectedCopy.any((s) => widget.displayText(s) == widget.displayText(item));
          void _toggleDialog(T item) {
            final already = _isSelectedDialog(item);
            setStateDialog(() {
              if (already) {
                selectedCopy.removeWhere((s) => widget.displayText(s) == widget.displayText(item));
              } else {
                selectedCopy.add(item);
              }
            });
          }

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Select ${widget.title}',
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  children: widget.data.map((item) {
                    final label = widget.displayText(item);
                    final checked = _isSelectedDialog(item);
                    return Theme(
                      data: Theme.of(context).copyWith(
                        checkboxTheme: CheckboxThemeData(
                          side:  BorderSide(
                            color: Colors.grey.withOpacity(.6), // <-- custom border color
                            width: 1,
                          ),
                          fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
                            if (states.contains(MaterialState.selected)) {
                              return ColorConstants.primary; // selected fill color
                            }
                            return Colors.white; // unselected fill background
                          }),
                          checkColor: MaterialStateProperty.all(Colors.white), // tick color
                        ),
                      ),
                      child: CheckboxListTile(
                        dense: true,
                        activeColor: ColorConstants.primary,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(label, style: GoogleFonts.poppins(fontSize: 13)),
                        value: checked,
                        onChanged: (_) => _toggleDialog(item),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop(null);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      child: Center(
                        child:cText("Cancel",color:ColorConstants.primary),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop(selectedCopy);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      child: Center(
                        child:cText("Done",color:ColorConstants.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );

    if (picked != null) {
      setState(() {
        _selected = List<T>.from(picked);
        _updateTextFromSelected();
      });
      if (widget.onChanged != null) widget.onChanged!(List<T>.from(_selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    const suggestionMaxHeight = 200.0;
    return Container(
      width: 100.w,
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 5,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [ColorConstants.primary, ColorConstants.secondary],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 80.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textController,
                              focusNode: _focusNode,
                              cursorColor: ColorConstants.primary,
                              onTap: () {
                                if (textController.text.trim().isNotEmpty) {
                                  _updateFilter(textController.text);
                                }
                              },
                              onChanged: (v) {
                                _updateFilter(v);
                              },
                              onSubmitted: (v) {
                                // If one match, toggle it; else hide suggestions
                                if (_filtered.length == 1) {
                                  _toggleSelection(_filtered.first);
                                } else {
                                  setState(() => _showSuggestions = false);
                                  _unfocus();
                                }
                              },
                              decoration: InputDecoration(
                                hintText: widget.hint,
                                border: InputBorder.none,
                              ),
                              readOnly:
                              false, // keep editable so user can type to filter. Selected items are shown as text.
                            ),
                          ),
                          // Dialog open button
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onPressed: _openSelectionDialog,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // if (_showSuggestions)
          // Container(
          //     margin: const EdgeInsets.only(left: 10, top: 6),
          //     constraints: const BoxConstraints(maxHeight: suggestionMaxHeight, minWidth: 0, maxWidth: double.infinity),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       border: Border.all(color: Colors.grey.withOpacity(.2)),
          //       borderRadius: BorderRadius.circular(8),
          //       boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 6, offset: const Offset(0, 2))],
          //     ),
          //     child: ListView.separated(
          //       padding: EdgeInsets.zero,
          //       shrinkWrap: true,
          //       itemCount: _filtered.length,
          //       separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.withOpacity(.2)),
          //       itemBuilder: (context, index) {
          //         final item = _filtered[index];
          //         final label = widget.displayText(item);
          //         final checked = _isSelected(item);
          //
          //         return Material(
          //           color: Colors.transparent,
          //           child: InkWell(
          //             onTap: () => _toggleSelection(item),
          //             child: Container(
          //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          //               child: Row(
          //                 children: [
          //                   Checkbox(activeColor: ColorConstants.primary,value: checked, onChanged: (_) => _toggleSelection(item)),
          //                   const SizedBox(width: 8),
          //                   Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 13))),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
        ],
      ),
    );
  }
}
