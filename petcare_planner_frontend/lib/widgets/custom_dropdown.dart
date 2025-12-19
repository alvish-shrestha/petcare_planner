import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  void _handleSelection(String? value) {
    setState(() {
      selectedValue = value;
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white, // This sets the popup background color
          elevation: 4, // Adjust elevation/shadow here
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: PopupMenuButton<String?>(
        onSelected: _handleSelection,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0x19000000),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  selectedValue ?? widget.hint,
                  style: TextStyle(
                    color: selectedValue == null
                        ? Color(0x40725E5E)
                        : Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),

        // --- The menu items to show ---
        itemBuilder: (context) {
          List<PopupMenuEntry<String?>> menuItems = [
            PopupMenuItem<String?>(
              value: null,
              child: const Text(
                'Select',
                style: TextStyle(color: Color(0x40725E5E)),
              ),
            ),
          ];

          menuItems.addAll(
            widget.items.map(
              (item) => PopupMenuItem<String?>(value: item, child: Text(item)),
            ),
          );

          return menuItems;
        },

        // You can customize the popup shape here (border radius, shadow)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),

        // Offset the popup if needed to appear just below the button
        offset: const Offset(0, 52),
      ),
    );
  }
}
