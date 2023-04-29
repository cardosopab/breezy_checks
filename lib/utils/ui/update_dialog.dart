import 'package:breezy_checks/utils/providers/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import '../../constants.dart';
import '../../models/check.dart';
import '../providers/check_list.dart';
import '../functions/format_date.dart';

Future<dynamic> updateCheckAlertDialog(
  Check check,
  dateTextController,
  payToTextController,
  signatureTextController,
  amountTextController,
  context,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          int switchValue = ref.watch(dateStateNotifierProvider);
          dateTextController.text = formatDate(check.date, switchValue);
          payToTextController.text = check.payTo;
          signatureTextController.text = check.signature;
          amountTextController.text = check.amount.toString();
          DateTime? date;
          return AlertDialog(
            title: const Text("Update the Check"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.none,
                    controller: dateTextController,
                    decoration: const InputDecoration(
                      hintText: 'Date',
                    ),
                    onTap: () async {
                      date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                        builder: (context, child) => Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Colors.black87,
                              onPrimary: mainGrey,
                              surface: mainGrey,
                              onSurface: Colors.black87,
                            ),
                            dialogTheme: DialogTheme(
                              backgroundColor: mainGrey,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (date != null) {
                        dateTextController.text = formatDate(date!, switchValue);
                      }
                    },
                  ),
                  TextField(
                    controller: payToTextController,
                    decoration: const InputDecoration(
                      hintText: 'Pay To Order Of',
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: amountTextController,
                    decoration: const InputDecoration(
                      hintText: 'Amount',
                    ),
                  ),
                  TextField(
                    controller: signatureTextController,
                    decoration: const InputDecoration(
                      hintText: 'Signature',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        ref.read(checkStateNotifierProvider.notifier).deleteCheck(check.id);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete)),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            dateTextController.text = '';
                            payToTextController.text = '';
                            signatureTextController.text = '';
                            amountTextController.text = '';
                            signatureTextController.text = '';
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            String amountInText = NumberToWordsEnglish.convert(check.amount.toInt());
                            ref.read(checkStateNotifierProvider.notifier).updateCheck(
                                  Check(
                                    date: date ?? check.date,
                                    payTo: payToTextController.text,
                                    signature: signatureTextController.text,
                                    background: check.background,
                                    id: check.id,
                                    amount: double.parse(amountTextController.text),
                                    amountInText: amountInText,
                                  ),
                                  check.id,
                                );
                            Navigator.pop(context);
                            dateTextController.text = '';
                            payToTextController.text = '';
                            signatureTextController.text = '';
                            amountTextController.text = '';
                            signatureTextController.text = '';
                          },
                          child: const Text("Accept"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  ).then((_) {
    dateTextController.text = '';
    payToTextController.text = '';
    signatureTextController.text = '';
    amountTextController.text = '';
    signatureTextController.text = '';
  });
}
