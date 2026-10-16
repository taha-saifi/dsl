import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../learn/data/learn_models.dart';
import '../../learn/data/learn_repository.dart';

final unitDetailProvider = FutureProvider.autoDispose
    .family<UnitDetail, String>(
      (ref, id) => ref.watch(learnRepositoryProvider).unit(id),
    );
