// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayPayload _$PlayPayloadFromJson(Map<String, dynamic> json) => _PlayPayload(
  exercise: PlayExercise.fromJson(json['exercise'] as Map<String, dynamic>),
  questions: (json['questions'] as List<dynamic>)
      .map((e) => PlayQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PlayPayloadToJson(_PlayPayload instance) =>
    <String, dynamic>{
      'exercise': instance.exercise,
      'questions': instance.questions,
    };

_PlayExercise _$PlayExerciseFromJson(Map<String, dynamic> json) =>
    _PlayExercise(
      id: json['_id'] as String,
      name: json['name'] as String,
      unitId: json['unitId'] as String,
      unitName: json['unitName'] as String,
      courseId: json['courseId'] as String,
      courseName: json['courseName'] as String,
      questionCount: (json['questionCount'] as num).toInt(),
    );

Map<String, dynamic> _$PlayExerciseToJson(_PlayExercise instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'unitId': instance.unitId,
      'unitName': instance.unitName,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'questionCount': instance.questionCount,
    };

_PlayChoice _$PlayChoiceFromJson(Map<String, dynamic> json) => _PlayChoice(
  id: json['id'] as String,
  text: json['text'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$PlayChoiceToJson(_PlayChoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'imageUrl': instance.imageUrl,
    };

ChoosePictureQuestion _$ChoosePictureQuestionFromJson(
  Map<String, dynamic> json,
) => ChoosePictureQuestion(
  id: json['id'] as String,
  displayText: json['displayText'] as String,
  points: (json['points'] as num).toInt(),
  prompt: json['prompt'] as String,
  options: (json['options'] as List<dynamic>)
      .map((e) => PlayChoice.fromJson(e as Map<String, dynamic>))
      .toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ChoosePictureQuestionToJson(
  ChoosePictureQuestion instance,
) => <String, dynamic>{
  'id': instance.id,
  'displayText': instance.displayText,
  'points': instance.points,
  'prompt': instance.prompt,
  'options': instance.options,
  'type': instance.$type,
};

MultipleChoiceQuestion _$MultipleChoiceQuestionFromJson(
  Map<String, dynamic> json,
) => MultipleChoiceQuestion(
  id: json['id'] as String,
  displayText: json['displayText'] as String,
  points: (json['points'] as num).toInt(),
  prompt: json['prompt'] as String,
  promptLanguage: json['promptLanguage'] as String,
  answerLanguage: json['answerLanguage'] as String,
  options: (json['options'] as List<dynamic>)
      .map((e) => PlayChoice.fromJson(e as Map<String, dynamic>))
      .toList(),
  imageUrl: json['imageUrl'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$MultipleChoiceQuestionToJson(
  MultipleChoiceQuestion instance,
) => <String, dynamic>{
  'id': instance.id,
  'displayText': instance.displayText,
  'points': instance.points,
  'prompt': instance.prompt,
  'promptLanguage': instance.promptLanguage,
  'answerLanguage': instance.answerLanguage,
  'options': instance.options,
  'imageUrl': instance.imageUrl,
  'type': instance.$type,
};

ListeningSelectQuestion _$ListeningSelectQuestionFromJson(
  Map<String, dynamic> json,
) => ListeningSelectQuestion(
  id: json['id'] as String,
  displayText: json['displayText'] as String,
  points: (json['points'] as num).toInt(),
  audioUrl: json['audioUrl'] as String,
  answerLanguage: json['answerLanguage'] as String,
  options: (json['options'] as List<dynamic>)
      .map((e) => PlayChoice.fromJson(e as Map<String, dynamic>))
      .toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ListeningSelectQuestionToJson(
  ListeningSelectQuestion instance,
) => <String, dynamic>{
  'id': instance.id,
  'displayText': instance.displayText,
  'points': instance.points,
  'audioUrl': instance.audioUrl,
  'answerLanguage': instance.answerLanguage,
  'options': instance.options,
  'type': instance.$type,
};

TypingQuestion _$TypingQuestionFromJson(Map<String, dynamic> json) =>
    TypingQuestion(
      id: json['id'] as String,
      displayText: json['displayText'] as String,
      points: (json['points'] as num).toInt(),
      prompt: json['prompt'] as String,
      promptLanguage: json['promptLanguage'] as String,
      answerLanguage: json['answerLanguage'] as String,
      imageUrl: json['imageUrl'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$TypingQuestionToJson(TypingQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayText': instance.displayText,
      'points': instance.points,
      'prompt': instance.prompt,
      'promptLanguage': instance.promptLanguage,
      'answerLanguage': instance.answerLanguage,
      'imageUrl': instance.imageUrl,
      'type': instance.$type,
    };

ListeningTranscribeQuestion _$ListeningTranscribeQuestionFromJson(
  Map<String, dynamic> json,
) => ListeningTranscribeQuestion(
  id: json['id'] as String,
  displayText: json['displayText'] as String,
  points: (json['points'] as num).toInt(),
  audioUrl: json['audioUrl'] as String,
  answerLanguage: json['answerLanguage'] as String,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ListeningTranscribeQuestionToJson(
  ListeningTranscribeQuestion instance,
) => <String, dynamic>{
  'id': instance.id,
  'displayText': instance.displayText,
  'points': instance.points,
  'audioUrl': instance.audioUrl,
  'answerLanguage': instance.answerLanguage,
  'type': instance.$type,
};

FillBlankQuestion _$FillBlankQuestionFromJson(Map<String, dynamic> json) =>
    FillBlankQuestion(
      id: json['id'] as String,
      displayText: json['displayText'] as String,
      points: (json['points'] as num).toInt(),
      sentenceLanguage: json['sentenceLanguage'] as String,
      before: json['before'] as String,
      after: json['after'] as String,
      hint: json['hint'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$FillBlankQuestionToJson(FillBlankQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayText': instance.displayText,
      'points': instance.points,
      'sentenceLanguage': instance.sentenceLanguage,
      'before': instance.before,
      'after': instance.after,
      'hint': instance.hint,
      'type': instance.$type,
    };

ArrangeSentenceQuestion _$ArrangeSentenceQuestionFromJson(
  Map<String, dynamic> json,
) => ArrangeSentenceQuestion(
  id: json['id'] as String,
  displayText: json['displayText'] as String,
  points: (json['points'] as num).toInt(),
  sentenceLanguage: json['sentenceLanguage'] as String,
  bank: (json['bank'] as List<dynamic>)
      .map((e) => PlayChoice.fromJson(e as Map<String, dynamic>))
      .toList(),
  hint: json['hint'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ArrangeSentenceQuestionToJson(
  ArrangeSentenceQuestion instance,
) => <String, dynamic>{
  'id': instance.id,
  'displayText': instance.displayText,
  'points': instance.points,
  'sentenceLanguage': instance.sentenceLanguage,
  'bank': instance.bank,
  'hint': instance.hint,
  'type': instance.$type,
};

MatchingQuestion _$MatchingQuestionFromJson(Map<String, dynamic> json) =>
    MatchingQuestion(
      id: json['id'] as String,
      displayText: json['displayText'] as String,
      points: (json['points'] as num).toInt(),
      sourceLanguage: json['sourceLanguage'] as String,
      targetLanguage: json['targetLanguage'] as String,
      left: (json['left'] as List<dynamic>)
          .map((e) => PlayChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      right: (json['right'] as List<dynamic>)
          .map((e) => PlayChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$MatchingQuestionToJson(MatchingQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayText': instance.displayText,
      'points': instance.points,
      'sourceLanguage': instance.sourceLanguage,
      'targetLanguage': instance.targetLanguage,
      'left': instance.left,
      'right': instance.right,
      'type': instance.$type,
    };

UnknownQuestion _$UnknownQuestionFromJson(Map<String, dynamic> json) =>
    UnknownQuestion(
      id: json['id'] as String,
      displayText: json['displayText'] as String,
      points: (json['points'] as num?)?.toInt() ?? 0,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$UnknownQuestionToJson(UnknownQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayText': instance.displayText,
      'points': instance.points,
      'type': instance.$type,
    };
