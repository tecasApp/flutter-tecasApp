import 'package:tecas_app/domain/repositories_def/miscellaneous_repository_def.dart';
import 'package:tecas_app/domain/services_def/miscellaneous_service_def.dart';

class MiscellaneousRepositoryImpl implements MiscellaneousRepository {
  final MiscellaneousService _miscellaneousService;
  MiscellaneousRepositoryImpl({
    required MiscellaneousService miscellaneousService,
  }) : _miscellaneousService = miscellaneousService;
  @override
  Future<Map<String, List<String>>> getRegistrationOptions() async {
    return await _miscellaneousService.getRegistrationOptions();
  }
}