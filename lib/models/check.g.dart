// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Check _$CheckFromJson(Map<String, dynamic> json) => Check(
      date: DateTime.parse(json['date'] as String),
      payTo: json['payTo'] as String,
      signature: json['signature'] as String,
      id: json['id'] as String,
      background: json['background'] as int,
      amount: (json['amount'] as num).toDouble(),
      amountInText: json['amountInText'] as String,
    );

Map<String, dynamic> _$CheckToJson(Check instance) => <String, dynamic>{
      'id': instance.id,
      'payTo': instance.payTo,
      'signature': instance.signature,
      'amountInText': instance.amountInText,
      'date': instance.date.toIso8601String(),
      'background': instance.background,
      'amount': instance.amount,
    };
