// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_summaries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpecializationSummary _$SpecializationSummaryFromJson(
  Map<String, dynamic> json,
) => _SpecializationSummary(
  id: json['_id'] as String,
  name: json['name'] as String,
  publishedCourseCount: (json['publishedCourseCount'] as num).toInt(),
  iconUrl: json['iconUrl'] as String?,
);

Map<String, dynamic> _$SpecializationSummaryToJson(
  _SpecializationSummary instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'publishedCourseCount': instance.publishedCourseCount,
  'iconUrl': instance.iconUrl,
};

_LanguageSummary _$LanguageSummaryFromJson(Map<String, dynamic> json) =>
    _LanguageSummary(
      code: json['code'] as String,
      publishedCourseCount: (json['publishedCourseCount'] as num).toInt(),
    );

Map<String, dynamic> _$LanguageSummaryToJson(_LanguageSummary instance) =>
    <String, dynamic>{
      'code': instance.code,
      'publishedCourseCount': instance.publishedCourseCount,
    };
