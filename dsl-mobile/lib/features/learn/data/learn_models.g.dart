// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_models.dart';

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

_CourseSummary _$CourseSummaryFromJson(Map<String, dynamic> json) =>
    _CourseSummary(
      id: json['_id'] as String,
      specializationId: json['specializationId'] as String,
      specializationName: json['specializationName'] as String,
      name: json['name'] as String,
      sourceLanguage: json['sourceLanguage'] as String,
      targetLanguage: json['targetLanguage'] as String,
      unitCount: (json['unitCount'] as num).toInt(),
      exerciseCount: (json['exerciseCount'] as num).toInt(),
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isEnrolled: json['isEnrolled'] as bool? ?? false,
      enrolledAt: json['enrolledAt'] == null
          ? null
          : DateTime.parse(json['enrolledAt'] as String),
    );

Map<String, dynamic> _$CourseSummaryToJson(_CourseSummary instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'specializationId': instance.specializationId,
      'specializationName': instance.specializationName,
      'name': instance.name,
      'sourceLanguage': instance.sourceLanguage,
      'targetLanguage': instance.targetLanguage,
      'unitCount': instance.unitCount,
      'exerciseCount': instance.exerciseCount,
      'description': instance.description,
      'thumbnailUrl': instance.thumbnailUrl,
      'isEnrolled': instance.isEnrolled,
      'enrolledAt': instance.enrolledAt?.toIso8601String(),
    };

_UnitSummary _$UnitSummaryFromJson(Map<String, dynamic> json) => _UnitSummary(
  id: json['_id'] as String,
  name: json['name'] as String,
  orderIndex: (json['orderIndex'] as num).toInt(),
  exerciseCount: (json['exerciseCount'] as num).toInt(),
);

Map<String, dynamic> _$UnitSummaryToJson(_UnitSummary instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'orderIndex': instance.orderIndex,
      'exerciseCount': instance.exerciseCount,
    };

_CourseDetail _$CourseDetailFromJson(Map<String, dynamic> json) =>
    _CourseDetail(
      course: CourseSummary.fromJson(json['course'] as Map<String, dynamic>),
      units: (json['units'] as List<dynamic>)
          .map((e) => UnitSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseDetailToJson(_CourseDetail instance) =>
    <String, dynamic>{'course': instance.course, 'units': instance.units};

_ExerciseSummary _$ExerciseSummaryFromJson(Map<String, dynamic> json) =>
    _ExerciseSummary(
      id: json['_id'] as String,
      name: json['name'] as String,
      orderIndex: (json['orderIndex'] as num).toInt(),
      questionCount: (json['questionCount'] as num).toInt(),
      questionTypes:
          (json['questionTypes'] as List<dynamic>?)
              ?.map(
                (e) => $enumDecode(
                  _$QuestionTypeEnumMap,
                  e,
                  unknownValue: QuestionType.unknown,
                ),
              )
              .toList() ??
          const <QuestionType>[],
    );

Map<String, dynamic> _$ExerciseSummaryToJson(_ExerciseSummary instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'orderIndex': instance.orderIndex,
      'questionCount': instance.questionCount,
      'questionTypes': instance.questionTypes
          .map((e) => _$QuestionTypeEnumMap[e]!)
          .toList(),
    };

const _$QuestionTypeEnumMap = {
  QuestionType.choosePicture: 'choose_picture',
  QuestionType.multipleChoice: 'multiple_choice',
  QuestionType.listeningSelect: 'listening_select',
  QuestionType.typing: 'typing',
  QuestionType.listeningTranscribe: 'listening_transcribe',
  QuestionType.fillBlank: 'fill_blank',
  QuestionType.arrangeSentence: 'arrange_sentence',
  QuestionType.matching: 'matching',
  QuestionType.unknown: 'unknown',
};

_UnitDetail _$UnitDetailFromJson(Map<String, dynamic> json) => _UnitDetail(
  id: json['_id'] as String,
  courseId: json['courseId'] as String,
  courseName: json['courseName'] as String,
  name: json['name'] as String,
  orderIndex: (json['orderIndex'] as num).toInt(),
  exercises: (json['exercises'] as List<dynamic>)
      .map((e) => ExerciseSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UnitDetailToJson(_UnitDetail instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'name': instance.name,
      'orderIndex': instance.orderIndex,
      'exercises': instance.exercises,
    };
