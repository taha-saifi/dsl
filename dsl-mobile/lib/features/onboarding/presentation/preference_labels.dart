import '../../../core/auth/app_user.dart';

/// Copy from Figma 03-C (`57:132`).
extension LearningGoalLabel on LearningGoal {
  String get label => switch (this) {
    LearningGoal.professional => 'Professional Dev',
    LearningGoal.academic => 'Academic Study',
    LearningGoal.certification => 'Certification',
    LearningGoal.dailyPractice => 'Daily Practice',
  };

  String get description => switch (this) {
    LearningGoal.professional => 'Career growth & workplace',
    LearningGoal.academic => 'University & research',
    LearningGoal.certification => 'Earn DSL certificates',
    LearningGoal.dailyPractice => 'Consistent vocabulary',
  };
}

extension ExperienceLevelLabel on ExperienceLevel {
  String get label => switch (this) {
    ExperienceLevel.beginner => 'Beginner',
    ExperienceLevel.intermediate => 'Intermediate',
    ExperienceLevel.advanced => 'Advanced',
  };

  String get description => switch (this) {
    ExperienceLevel.beginner => 'New to this field',
    ExperienceLevel.intermediate => 'Some background',
    ExperienceLevel.advanced => 'Expert knowledge',
  };
}

String dailyTargetLabel(int minutes) =>
    minutes >= 30 ? '$minutes min+' : '$minutes min';
