import 'package:flutter/material.dart';

class AdministrationSearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;
  final ValueChanged<int> reFresh;
  final ValueChanged<int> search;

  const AdministrationSearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
    required this.reFresh,
    required this.search,
  }) : super(key: key);

  @override
  _AdministrationSearchWidgetState createState() =>
      _AdministrationSearchWidgetState();
}

class _AdministrationSearchWidgetState
    extends State<AdministrationSearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const styleActive = TextStyle(color: Colors.black);
    const styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: 45,
      //margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: widget.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                    widget.reFresh(100);
                  },
                  icon: Icon(Icons.close, color: style.color),
                )
              : IconButton(
                  onPressed: () {
                    widget.search(100);
                  },
                  icon: Icon(Icons.search, color: style.color),
                ),
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}
