import 'package:freezed_annotation/freezed_annotation.dart';

part 'play_models.freezed.dart';
part 'play_models.g.dart';

/// `GET /learn/exercises/:id/play` (docs/contracts/api-contract.md). It never
/// contains an answer: choices are shuffled and unmarked, and ids are opaque.
@freezed
abstract class PlayPayload with _$PlayPayload {
  const factory PlayPayload({
    required PlayExercise exercise,
    required List<PlayQuestion> questions,
  }) = _PlayPayload;

  factory PlayPayload.fromJson(Map<String, dynamic> json) =>
      _$PlayPayloadFromJson(json);
}

@freezed
abstract class PlayExercise with _$PlayExercise {
  const factory PlayExercise({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String unitId,
    required String unitName,
    required String courseId,
    required String courseName,
    required int questionCount,
  }) = _PlayExercise;

  factory PlayExercise.fromJson(Map<String, dynamic> json) =>
      _$PlayExerciseFromJson(json);
}

/// An answer choice, word block or matching card. Exactly one of [text] or
/// [imageUrl] is set.
@freezed
abstract class PlayChoice with _$PlayChoice {
  const factory PlayChoice({
    required String id,
    String? text,
    String? imageUrl,
  }) = _PlayChoice;

  factory PlayChoice.fromJson(Map<String, dynamic> json) =>
      _$PlayChoiceFromJson(json);
}

@Freezed(unionKey: 'type', fallbackUnion: 'unknown')
sealed class PlayQuestion with _$PlayQuestion {
  @FreezedUnionValue('choose_picture')
  const factory PlayQuestion.choosePicture({
    required String id,
    required String displayText,
    required int points,
    required String prompt,
    required List<PlayChoice> options,
  }) = ChoosePictureQuestion;

  @FreezedUnionValue('multiple_choice')
  const factory PlayQuestion.multipleChoice({
    required String id,
    required String displayText,
    required int points,
    required String prompt,
    required String promptLanguage,
    required String answerLanguage,
    required List<PlayChoice> options,
    String? imageUrl,
  }) = MultipleChoiceQuestion;

  @FreezedUnionValue('listening_select')
  const factory PlayQuestion.listeningSelect({
    required String id,
    required String displayText,
    required int points,
    required String audioUrl,
    required String answerLanguage,
    required List<PlayChoice> options,
  }) = ListeningSelectQuestion;

  @FreezedUnionValue('typing')
  const factory PlayQuestion.typing({
    required String id,
    required String displayText,
    required int points,
    required String prompt,
    required String promptLanguage,
    required String answerLanguage,
    String? imageUrl,
  }) = TypingQuestion;

  @FreezedUnionValue('listening_transcribe')
  const factory PlayQuestion.listeningTranscribe({
    required String id,
    required String displayText,
    required int points,
    required String audioUrl,
    required String answerLanguage,
  }) = ListeningTranscribeQuestion;

  @FreezedUnionValue('fill_blank')
  const factory PlayQuestion.fillBlank({
    required String id,
    required String displayText,
    required int points,
    required String sentenceLanguage,
    required String before,
    required String after,
    String? hint,
  }) = FillBlankQuestion;

  @FreezedUnionValue('arrange_sentence')
  const factory PlayQuestion.arrangeSentence({
    required String id,
    required String displayText,
    required int points,
    required String sentenceLanguage,
    required List<PlayChoice> bank,
    String? hint,
  }) = ArrangeSentenceQuestion;

  @FreezedUnionValue('matching')
  const factory PlayQuestion.matching({
    required String id,
    required String displayText,
    required int points,
    required String sourceLanguage,
    required String targetLanguage,
    required List<PlayChoice> left,
    required List<PlayChoice> right,
  }) = MatchingQuestion;

  /// A type added to the API after this build: shown as "update the app".
  const factory PlayQuestion.unknown({
    required String id,
    required String displayText,
    @Default(0) int points,
  }) = UnknownQuestion;

  factory PlayQuestion.fromJson(Map<String, dynamic> json) =>
      _$PlayQuestionFromJson(json);
}
