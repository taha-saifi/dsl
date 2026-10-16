import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/error_messages.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/state_views.dart';
import '../../learn/data/language_names.dart';
import '../../learn/data/learn_models.dart';
import '../../learn/data/learn_repository.dart';
import '../data/catalog_providers.dart';
import 'course_card.dart';

/// Figma 05 "Course Catalog" (`62:5`): search, domain chips, a language
/// filter, and course cards with Enroll Now. Sort and "Load more" wait until
/// there's enough content to need them.
class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  late final TextEditingController _search = TextEditingController(
    text: ref.read(catalogFilterProvider).search,
  );
  Timer? _debounce;
  String? _enrollingId;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => ref.read(catalogFilterProvider.notifier).search(text),
    );
  }

  Future<void> _enroll(CourseSummary course) async {
    setState(() => _enrollingId = course.id);
    try {
      await ref.read(enrollmentActionsProvider).enroll(course.id);
      if (mounted) _snack('Enrolled in ${course.name}.');
    } on Object catch (error) {
      if (mounted) _snack(describeError(error));
    } finally {
      if (mounted) setState(() => _enrollingId = null);
    }
  }

  void _snack(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(catalogFilterProvider);
    final domains = ref.watch(specializationsProvider);
    final courses = ref.watch(catalogCoursesProvider);
    final colors = context.colors;
    final type = context.type;

    // A preferred domain without published courses isn't a chip; treat it
    // as "All" (catalogCoursesProvider ignores it too).
    final domainList = domains.value ?? const <SpecializationSummary>[];
    final selectedDomain =
        domainList.any((d) => d.id == filter.specializationId)
        ? filter.specializationId
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Explore Courses')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenMargin,
            ),
            child: TextField(
              controller: _search,
              onChanged: _onSearchChanged,
              onSubmitted: (text) {
                _debounce?.cancel();
                ref.read(catalogFilterProvider.notifier).search(text);
              },
              textInputAction: TextInputAction.search,
              style: type.body.copyWith(color: colors.white),
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: Icon(Icons.search_rounded, color: colors.muted),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenMargin,
              ),
              children: [
                _FilterChip(
                  label: 'All',
                  selected: selectedDomain == null,
                  onTap: () => ref
                      .read(catalogFilterProvider.notifier)
                      .selectDomain(null),
                ),
                for (final domain in domainList)
                  _FilterChip(
                    label: domain.name,
                    selected: selectedDomain == domain.id,
                    onTap: () => ref
                        .read(catalogFilterProvider.notifier)
                        .selectDomain(domain.id),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenMargin,
              AppSpacing.sm,
              AppSpacing.screenMargin,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    courses.hasValue
                        ? '${countLabel(courses.value!.length, 'course')} found'
                        : '',
                    style: type.caption.copyWith(color: colors.muted),
                  ),
                ),
                _LanguageButton(
                  code: filter.targetLanguage,
                  specializationId: selectedDomain,
                ),
              ],
            ),
          ),
          Expanded(
            child: courses.when(
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(
                error: error,
                title: "Couldn't load courses",
                onRetry: () => ref
                  ..invalidate(specializationsProvider)
                  ..invalidate(catalogCoursesProvider),
              ),
              data: (items) => items.isEmpty
                  ? EmptyView(
                      title: 'No courses found',
                      message: filter.search.trim().isEmpty
                          ? 'Nothing is published for these filters yet. '
                                'Try another domain or language.'
                          : 'No course matches "${filter.search.trim()}". '
                                'Try another word or clear the filters.',
                      actionLabel: 'Show all courses',
                      onAction: () {
                        _search.clear();
                        ref
                          ..read(catalogFilterProvider.notifier).search('')
                          ..read(
                            catalogFilterProvider.notifier,
                          ).selectDomain(null)
                          ..read(
                            catalogFilterProvider.notifier,
                          ).selectLanguage(null);
                      },
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.refresh(catalogCoursesProvider.future),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenMargin,
                          AppSpacing.xs,
                          AppSpacing.screenMargin,
                          AppSpacing.xxl,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, i) => CourseCard(
                          course: items[i],
                          enrolling: _enrollingId == items[i].id,
                          onOpen: () => context.go(Routes.course(items[i].id)),
                          onEnroll: () => _enroll(items[i]),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected
              ? colors.cyan.withValues(alpha: 0.15)
              : colors.inkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            side: BorderSide(color: selected ? colors.cyan : colors.inkBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Center(
                child: Text(
                  label,
                  style: context.type.body.copyWith(
                    color: selected ? colors.cyan : colors.white,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "French ▾": picks the language filter from the languages that have
/// courses in the selected domain.
class _LanguageButton extends ConsumerWidget {
  const _LanguageButton({required this.code, required this.specializationId});

  final String? code;
  final String? specializationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return TextButton.icon(
      onPressed: () => _pick(context, ref),
      iconAlignment: IconAlignment.end,
      icon: Icon(Icons.expand_more_rounded, color: colors.cyan, size: 18),
      label: Text(
        code == null ? 'All languages' : LanguageName.of(code!).english,
        style: context.type.caption.copyWith(
          color: colors.cyan,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(catalogFilterProvider.notifier);
    final picked = await showModalBottomSheet<({String? code})>(
      context: context,
      backgroundColor: context.colors.inkSurface,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final languages = ref.watch(languagesProvider(specializationId));
          final type = context.type;
          final colors = context.colors;
          Widget row(String? value, String label, String? detail) => ListTile(
            title: Text(
              label,
              style: type.bodyLarge.copyWith(color: colors.white),
            ),
            subtitle: detail == null
                ? null
                : Text(
                    detail,
                    style: type.caption.copyWith(color: colors.muted),
                  ),
            trailing: value == code
                ? Icon(Icons.check_rounded, color: colors.cyan)
                : null,
            onTap: () => Navigator.of(context).pop((code: value)),
          );
          return SafeArea(
            child: languages.when(
              loading: () => const SizedBox(height: 160, child: LoadingView()),
              error: (error, _) => SizedBox(
                height: 280,
                child: ErrorView(
                  error: error,
                  title: "Couldn't load languages",
                  onRetry: () =>
                      ref.invalidate(languagesProvider(specializationId)),
                ),
              ),
              data: (items) => ListView(
                shrinkWrap: true,
                children: [
                  row(null, 'All languages', null),
                  for (final l in items)
                    row(
                      l.code,
                      LanguageName.of(l.code).english,
                      '${LanguageName.of(l.code).native} · '
                      '${countLabel(l.publishedCourseCount, 'course')}',
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
    if (picked != null) notifier.selectLanguage(picked.code);
  }
}
