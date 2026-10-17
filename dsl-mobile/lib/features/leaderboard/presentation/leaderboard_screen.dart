import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/coming_soon.dart';
import '../../../core/widgets/dsl_card.dart';

/// Figma 11 "Leaderboard" (`111:213`), static sample rows with invented
/// names, clearly marked. No network calls; real rankings arrive with
/// feat-leaderboard (and XP with feat-xp-and-levels).
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _weekly = true;

  static const _rows = [
    ('Learner A', 4820),
    ('Learner B', 3940),
    ('Learner C', 3210),
    ('Learner D', 2980),
    ('Learner E', 2840),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          const ComingSoonBanner(
            message:
                'Rankings start once XP is added. These rows are examples.',
          ),
          const SizedBox(height: AppSpacing.lg),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Weekly')),
              ButtonSegment(value: false, label: Text('Monthly')),
            ],
            selected: {_weekly},
            onSelectionChanged: (s) => setState(() => _weekly = s.first),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final (i, (name, xp)) in _rows.indexed) ...[
            DslCard(
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      '#${i + 1}',
                      style: type.h3.copyWith(
                        color: i < 3 ? colors.amber : colors.muted,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: colors.inkTrack,
                    child: Text(
                      name.characters.last,
                      style: type.button.copyWith(color: colors.cyan),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      name,
                      style: type.body.copyWith(color: colors.white),
                    ),
                  ),
                  Text(
                    '${_weekly ? xp : xp * 4} XP',
                    style: type.body.copyWith(
                      color: colors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
