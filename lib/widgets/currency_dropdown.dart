import 'package:flutter/material.dart';
import 'package:budget_planner/models/data/data.dart';

class CurrencyDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final EdgeInsetsGeometry? padding;

  const CurrencyDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: 'Choose your currency',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: currencies.map((c) {
          return DropdownMenuItem(
            value: c['code'] as String,
            child: Text('${c['symbol']} ${c['code']}'),
          );
        }).toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}
