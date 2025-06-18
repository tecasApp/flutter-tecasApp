import 'package:tecas_app/infrastructure/services_impl/dtos/personal_information_user_dto.dart';

abstract class UserService {
  Future<bool> personalInformationRegister(
    PersonalInformationUserDTO personalInformationUserDTO,
  );
}
