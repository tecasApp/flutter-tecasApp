import 'package:tecas_app/domain/repositories_def/miscellaneous_repository_def.dart';

class CachedRegistrationOptions {
  static final CachedRegistrationOptions _instance = CachedRegistrationOptions._internal();
  factory CachedRegistrationOptions() => _instance;
  CachedRegistrationOptions._internal();

  Map<String, List<String>>? _options;

Future<Map<String, List<String>>> getOptions(MiscellaneousRepository repository) async {
  if (_options != null) {
    print('🟡 [CachedRegistrationOptions] Retornando opciones desde caché');
    return _options!;
  }

  print('🔵 [CachedRegistrationOptions] No hay caché, solicitando al repositorio...');
  _options = await repository.getRegistrationOptions();
  print("✅ [CachedRegistrationOptions] Opciones obtenidas y almacenadas en caché: $_options");

  return _options!;
}


List<String> getOption(String key) {
  final value = _options?[key] ?? [];
  print('🔍 [getOption] Obteniendo $key: $value');
  return value;
}

void clear() {
  print('🧹 [CachedRegistrationOptions] Caché eliminada');
  _options = null;
}
}
