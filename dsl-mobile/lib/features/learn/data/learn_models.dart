import 'package:freezed_annotation/freezed_annotation.dart';

import 'question_type.dart';

part 'learn_models.freezed.dart';
part 'learn_models.g.dart';

/// Shapes of the `/learn` endpoints (docs/contracts/api-contract.md). They
/// only ever contain content that is published all the way down.

/// `GET /learn/specializations`: a domain that has visible courses.
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

/// `GET /learn/languages`: a target language with visible courses.
@freezed
abstract class LanguageSummary with _$LanguageSummary {
  const factory LanguageSummary({
    required String code,
    required int publishedCourseCount,
  }) = _LanguageSummary;

  factory LanguageSummary.fromJson(Map<String, dynamic> json) =>
      _$LanguageSummaryFromJson(json);
}

/// Completed exercises ÷ published exercises, computed by the server from
/// completed sessions (feat-learning-progress). Students only.
@freezed
abstract class Progress with _$Progress {
  const factory Progress({
    required int completedExercises,
    required int totalExercises,
    required int percent,
  }) = _Progress;

  const Progress._();

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);

  bool get isComplete =>
      totalExercises > 0 && completedExercises >= totalExercises;
}

/// A course in `GET /learn/courses`, and the head of a [CourseDetail].
@freezed
abstract class CourseSummary with _$CourseSummary {
  const factory CourseSummary({
    @JsonKey(name: '_id') required String id,
    required String specializationId,
    required String specializationName,
    required String name,
    required String sourceLanguage,
    required String targetLanguage,
    required int unitCount,
    required int exerciseCount,
    String? description,

    /// Absolute MinIO URL built from the current `MINIO_PUBLIC_ENDPOINT`.
    String? thumbnailUrl,

    /// Always false for teachers and admins.
    @Default(false) bool isEnrolled,
    DateTime? enrolledAt,

    /// Students only. Where Continue goes: the first exercise not completed
    /// yet; both null once everything is done.
    Progress? progress,
    String? nextUnitId,
    String? nextExerciseId,
    DateTime? lastActivityAt,
  }) = _CourseSummary;

  factory CourseSummary.fromJson(Map<String, dynamic> json) =>
      _$CourseSummaryFromJson(json);
}

/// A unit listed in a [CourseDetail], in `orderIndex` order.
@freezed
abstract class UnitSummary with _$UnitSummary {
  const factory UnitSummary({
    @JsonKey(name: '_id') required String id,
    required String name,
    required int orderIndex,
    required int exerciseCount,
    Progress? progress,
  }) = _UnitSummary;

  factory UnitSummary.fromJson(Map<String, dynamic> json) =>
      _$UnitSummaryFromJson(json);
}

/// `GET /learn/courses/:id`: the course fields plus its visible units.
@freezed
abstract class CourseDetail with _$CourseDetail {
  const factory CourseDetail({
    required CourseSummary course,
    required List<UnitSummary> units,
  }) = _CourseDetail;

  /// The API sends one flat object; split it into the summary and units.
  factory CourseDetail.fromJson(Map<String, dynamic> json) => CourseDetail(
    course: CourseSummary.fromJson(json),
    units: (json['units']! as List<Object?>)
        .map((u) => UnitSummary.fromJson(u! as Map<String, dynamic>))
        .toList(),
  );
}

enum ExerciseStatus {
  @JsonValue('not_started')
  notStarted,
  completed,
}

/// A playable exercise in a [UnitDetail], in `orderIndex` order.
@freezed
abstract class ExerciseSummary with _$ExerciseSummary {
  const factory ExerciseSummary({
    @JsonKey(name: '_id') required String id,
    required String name,
    required int orderIndex,
    required int questionCount,

    /// Distinct types in the order they first appear; exercises are
    /// mixed-type.
    @JsonKey(unknownEnumValue: QuestionType.unknown)
    @Default(<QuestionType>[])
    List<QuestionType> questionTypes,

    /// Students only: done at any score; the best session's percent.
    @JsonKey(unknownEnumValue: ExerciseStatus.notStarted)
    ExerciseStatus? status,
    int? bestPercent,
  }) = _ExerciseSummary;

  factory ExerciseSummary.fromJson(Map<String, dynamic> json) =>
      _$ExerciseSummaryFromJson(json);
}

/// `GET /learn/units/:id`.
@freezed
abstract class UnitDetail with _$UnitDetail {
  const factory UnitDetail({
    @JsonKey(name: '_id') required String id,
    required String courseId,
    required String courseName,
    required String name,
    required int orderIndex,
    required List<ExerciseSummary> exercises,
    Progress? progress,
    String? nextExerciseId,
  }) = _UnitDetail;

  factory UnitDetail.fromJson(Map<String, dynamic> json) =>
      _$UnitDetailFromJson(json);
}
