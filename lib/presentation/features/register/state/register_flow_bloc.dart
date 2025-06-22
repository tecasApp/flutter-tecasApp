import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecas_app/domain/entities/app_user.dart';
import 'package:tecas_app/domain/entities/user_profile.dart';

part 'register_flow_event.dart';
part 'register_flow_state.dart';

class RegisterFlowBloc extends Bloc<RegisterFlowEvent, RegisterFlowState> {
  RegisterFlowBloc({
    required AppUser initialUser,
    required UserProfile initialProfile,
  }) : super(
          RegisterFlowState(
            user: initialUser,
            profile: initialProfile,
            step: getStepFromUserAndProfile(initialUser, initialProfile),
          ),
        ) {
    on<GoToNextStep>((event, emit) {
      final nextIndex = state.step.index + 1;
      if (nextIndex < RegisterStep.values.length) {
        emit(state.copyWith(step: RegisterStep.values[nextIndex]));
      }
    });

    on<GoToPreviousStep>((event, emit) {
      final prevIndex = state.step.index - 1;
      if (prevIndex >= 0) {
        emit(state.copyWith(step: RegisterStep.values[prevIndex]));
      }
    });

    on<UpdateProfileData>((event, emit) {
      final newProfile = event.updatedProfile;
      final newStep = getStepFromUserAndProfile(state.user, newProfile);
      emit(state.copyWith(profile: newProfile, step: newStep));
    });
  }
}

RegisterStep getStepFromUserAndProfile(AppUser user, UserProfile profile) {
  if (user == AppUser.empty) {
    return RegisterStep.method;
  }

  if (profile.fullName.isEmpty ||
      profile.username.isEmpty ||
      profile.nationality.isEmpty ||
      profile.phoneNumber.isEmpty) {
    return RegisterStep.personalInformation;
  }

  if (profile.birthdayDate == null) {
    return RegisterStep.birthdayFilter;
  }

  if (profile.gender?.isNotEmpty != true ||
      profile.sexualOrientation?.isNotEmpty != true) {
    return RegisterStep.personalInclinations;
  }

  if (profile.musicalTastes.isEmpty ||
      profile.hobbies.isEmpty) {
    return RegisterStep.personalLikes;
  }

  return RegisterStep.complete;
}
