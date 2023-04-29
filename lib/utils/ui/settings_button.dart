import 'package:breezy_checks/utils/providers/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final int selectedOption = ref.watch(dateStateNotifierProvider);
        return AlertDialog(
          content: DropdownButton(
            dropdownColor: accentGrey,
            value: selectedOption,
            items: const [
              DropdownMenuItem(
                value: 0,
                child: Text('Month-Day-Year'),
              ),
              DropdownMenuItem(
                value: 1,
                child: Text('Day-Month-Year'),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text('Year-Month-Day'),
              ),
            ],
            onChanged: (newValue) {
              ref.read(dateStateNotifierProvider.notifier).saveFormat(newValue!);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
