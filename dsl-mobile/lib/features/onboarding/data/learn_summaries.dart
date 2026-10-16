import 'package:freezed_annotation/freezed_annotation.dart';

part 'learn_summaries.freezed.dart';
part 'learn_summaries.g.dart';

/// `GET /learn/specializations`: a domain that has published courses.
@freezed
abstract class SpecializationSummary with _$SpecializationSummary {
  const factory SpecializationSummary({
    @JsonKey(name: '_id') required String id,
    required String name,
    required int publishedCourseCount,
    String? iconUrl,
  }) = _SpecializationSummary;

  factory SpecializationSummary.fromJson(Map<String, dynamic> json) =>
      _$SpecializationSummaryFromJson(json);
}

/// `GET /learn/languages`: a target language with published courses.
@freezed
abstract class LanguageSummary with _$LanguageSummary {
  const factory LanguageSummary({
    required String code,
    required int publishedCourseCount,
  }) = _LanguageSummary;

  factory LanguageSummary.fromJson(Map<String, dynamic> json) =>
      _$LanguageSummaryFromJson(json);
}
