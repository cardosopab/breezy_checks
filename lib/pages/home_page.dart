import 'package:breezy_checks/models/check.dart';
import 'package:breezy_checks/utils/providers/check_list.dart';
import 'package:breezy_checks/utils/providers/date_format.dart';
import 'package:breezy_checks/utils/ui/settings_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../utils/functions/format_date.dart';
import '../utils/ui/add_dialog.dart';
import '../utils/ui/update_dialog.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dateTextController = useTextEditingController();
    final payToTextController = useTextEditingController();
    final signatureTextController = useTextEditingController();
    final amountTextController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: mainGrey,
        centerTitle: true,
        title: const Text(
          'Breezy Checks',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const Settings(),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final List<Check> checkList = ref.watch(checkStateNotifierProvider);
            final int switchValue = ref.watch(dateStateNotifierProvider);

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: checkList.isEmpty
                  ? const Center(
                      child: Text(
                      'Time to add your first Check!',
                    ))
                  : ReorderableListView(
                      buildDefaultDragHandles: false,
                      onReorder: (int oldIndex, int newIndex) {
                        ref.read(checkStateNotifierProvider.notifier).reorderCheckList(oldIndex, newIndex);
                      },
                      children: [
                        for (Check check in checkList)
                          InkWell(
                            key: ValueKey(check.id),
                            onTap: () {
                              updateCheckAlertDialog(
                                check,
                                dateTextController,
                                payToTextController,
                                signatureTextController,
                                amountTextController,
                                context,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                elevation: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/background${checkList.indexOf(check)}.jpg'),
                                      // image: AssetImage('assets/background${check.background}.jpg'),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                          horizontal: 4.0,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 2.0),
                                                      child: Text(formatDate(check.date, switchValue)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 2.0),
                                                            child: Text(check.payTo),
                                                          )),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Text(
                                                        '${check.amount.toStringAsFixed(2)}~',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 2.0),
                                                          child: Text(
                                                            '${check.amountInText} and ${check.amount.toStringAsFixed(2).split('.').last.padLeft(2, '0')}/100 ~',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Colors.white,
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(left: 2.0),
                                                      child: Text('Currency'),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Text(check.signature),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ReorderableDragStartListener(
                                        index: checkList.indexOf(check),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: mainPeach,
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.fingerprint,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            );
          },
        ),
      ),
      floatingActionButton: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) => FloatingActionButton(
          elevation: 10,
          onPressed: () {
            addCheckAlertDialog(
              dateTextController,
              payToTextController,
              signatureTextController,
              amountTextController,
              context,
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
