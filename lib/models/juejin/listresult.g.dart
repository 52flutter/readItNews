// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listresult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListResult _$ListResultFromJson(Map<String, dynamic> json) {
  return ListResult(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ListResultToJson(ListResult instance) =>
    <String, dynamic>{'data': instance.data};
