import 'package:json_annotation/json_annotation.dart';

part 'check.g.dart';

@JsonSerializable()
class Check {
  String id, payTo, signature, amountInText;
  DateTime date;
  int background;
  double amount;
  Check({
    required this.date,
    required this.payTo,
    required this.signature,
    required this.id,
    required this.background,
    required this.amount,
    required this.amountInText,
  });

  factory Check.fromJson(Map<String, dynamic> json) => _$CheckFromJson(json);

  Map<String, dynamic> toJson() => _$CheckToJson(this);
}
