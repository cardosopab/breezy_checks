import 'dart:math';

import 'package:breezy_checks/utils/providers/date_format.dart';
import 'package:breezy_checks/utils/providers/signature_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../models/check.dart';
import '../providers/check_list.dart';
import '../functions/format_date.dart';

Future<dynamic> addCheckAlertDialog(
  dateTextController,
  payToTextController,
  signatureTextController,
  amountTextController,
  context,
) {
  return showDialog(
    context: context,
    builder: (context) {
      Uuid uuid = const Uuid();
      final rand = Random();
      DateTime? date;
      return Consumer(
        builder: (context, ref, child) {
          signatureTextController.text = ref.watch(signatureStateNotifier);
          int switchValue = ref.watch(dateStateNotifierProvider);
          return AlertDialog(
            title: const Text("Add a Check"),
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
                  if (date != null && payToTextController != null && signatureTextController != null && amountTextController != null) {
                    String amountInText = NumberToWordsEnglish.convert(int.parse(amountTextController.text.toString().split('.').first));
                    ref.read(signatureStateNotifier.notifier).saveSignature(signatureTextController.text);
                    ref.read(checkStateNotifierProvider.notifier).addCheck(
                          Check(
                            date: date!,
                            payTo: payToTextController.text,
                            signature: signatureTextController.text,
                            amount: double.parse(amountTextController.text),
                            background: rand.nextInt(6),
                            id: uuid.v4(),
                            amountInText: amountInText,
                          ),
                        );
                    Navigator.pop(context);
                    dateTextController.text = '';
                    payToTextController.text = '';
                    signatureTextController.text = '';
                    amountTextController.text = '';
                    signatureTextController.text = '';
                  }
                },
                child: const Text("Accept"),
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
