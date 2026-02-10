import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../Utils/colors_constants.dart';
import 'Gradient.dart';

class TransferDropdown<T> extends StatefulWidget {
  final String title;
  final String hint;
  final String selectedVal;
  final List<T> data;
  final String Function(T) displayText;
  final String Function(T)? subDisplayText; // <- nullable now
  final void Function(T)? onChanged;
  final bool isEditable;

  const TransferDropdown({
    super.key,
    required this.title,
    required this.hint,
    required this.selectedVal,
    required this.data,
    required this.displayText,
    this.subDisplayText,
    this.onChanged,
    this.isEditable=true
  });

  @override
  State<TransferDropdown<T>> createState() => _TransferDropdownState<T>();
}

class _TransferDropdownState<T> extends State<TransferDropdown<T>> {
  late TextEditingController textController;
  FocusNode _focusNode = FocusNode();
  String? selectedValue;
  List<T> _filtered = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedVal.isEmpty ? null : widget.selectedVal;
    textController = TextEditingController(text: selectedValue ?? '');
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    textController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
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

  String _norm(String s) => s.trim().toLowerCase();

  void _updateFilter(String input) {
    final q = _norm(input);
    if (q.isEmpty) {
      setState(() {
        _filtered = [];
        _showSuggestions = false;
      });
      return;
    }

    final results = widget.data.where((item) {
      final title = _norm(widget.displayText(item));
      final sub = _norm(widget.subDisplayText?.call(item) ?? '');
      return title.contains(q) || (sub.isNotEmpty && sub.contains(q));
    }).toList();

    setState(() {
      _filtered = results;
      _showSuggestions = results.isNotEmpty;
    });
  }

  String _formatDisplayWithSub(T item) {
    final title = widget.displayText(item);
    final sub = widget.subDisplayText?.call(item) ?? '';
    if (sub.isNotEmpty) return '$title ($sub)';
    return title;
  }

  void _onTapSuggestion(T item) {
    final display = _formatDisplayWithSub(item);
    setState(() {
      selectedValue = display;
      textController.text = display;
      textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length),
      );
      _showSuggestions = false;
      _filtered = [];
    });
    _unfocus();
    if (widget.onChanged != null) widget.onChanged!(item);
  }

  void _unfocus() => FocusScope.of(context).unfocus();

  @override
  void didUpdateWidget(covariant TransferDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedVal != widget.selectedVal || oldWidget.data != widget.data) {
      selectedValue = widget.selectedVal.isEmpty ? null : widget.selectedVal;
      if (textController.text != (selectedValue ?? '')) {
        textController.text = selectedValue ?? '';
        textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const suggestionMaxHeight = 200.0;

    return Container(
      width: 100.w,
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top:20),
                  child: sideGradientBar()
              ),
              const SizedBox(width: 5),
              Container(
                width: 76.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                              enabled: widget.isEditable,
                              cursorColor: ColorConstants.primary,
                              onTap: () {

                                  if (textController.text
                                      .trim()
                                      .isNotEmpty) {
                                    _updateFilter(textController.text);
                                  }
                              },
                              onChanged: (v) {
                                  _updateFilter(v);
                              },
                              onSubmitted: (v) {
                                  if (_filtered.length == 1) {
                                    _onTapSuggestion(_filtered.first);
                                  } else {
                                    setState(() => _showSuggestions = false);
                                    _unfocus();
                                  }
                              },
                              decoration: InputDecoration(
                                hintText: widget.hint,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_down,color:  Colors.grey.withOpacity(.6),),
                            onPressed: () async {
                              _unfocus();
                              if(widget.isEditable)
                              {
                                final selectedItem = await showDialog<T>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        'Select ${widget.title}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: widget.data.map((item) {
                                            final displayValue = widget
                                                .displayText(item);
                                            final subDisplayValue = widget
                                                .subDisplayText?.call(item) ??
                                                '';

                                            final titleText = subDisplayValue
                                                .isNotEmpty
                                                ? "$displayValue (${subDisplayValue})"
                                                : displayValue;

                                            return ListTile(
                                              dense: true,
                                              minVerticalPadding: 0,
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(
                                                "${titleText}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.black
                                                      .withOpacity(.6),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop(item);
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                );

                                if (selectedItem != null) {
                                  _onTapSuggestion(selectedItem);
                                  if (widget.onChanged != null) widget
                                      .onChanged!(selectedItem);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.isEditable && _showSuggestions)
            Container(
              margin: const EdgeInsets.only(left: 10, top: 6),
              constraints: BoxConstraints(
                maxHeight: suggestionMaxHeight,
                minWidth: 80.w,
                maxWidth: 80.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.withOpacity(.2)),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.withOpacity(.2)),
                itemBuilder: (context, index) {
                  final item = _filtered[index];
                  final label = _formatDisplayWithSub(item);
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _onTapSuggestion(item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Text(
                          label,
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
