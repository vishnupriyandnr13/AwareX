import 'package:awarex/models/context/context_data.dart';

abstract interface class ContextService {
  Stream<ContextData> getContextStream();

  Future<ContextData> getCurrentContext();

  void dispose();
}
