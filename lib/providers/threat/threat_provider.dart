import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/models/threat/threat_assessment.dart';

import 'package:awarex/providers/context/context_provider.dart';

import 'package:awarex/services/threat/threat_service.dart';
import 'package:awarex/services/threat/threat_service_impl.dart';

final threatServiceProvider = Provider<ThreatService>((ref) {
  final service = ThreatServiceImpl(
    contextService: ref.read(contextServiceProvider),
  );

  ref.onDispose(service.dispose);

  return service;
});

final threatProvider = StreamProvider.autoDispose<ThreatAssessment>((ref) {
  final threatService = ref.watch(threatServiceProvider);

  return threatService.getThreatStream();
});
