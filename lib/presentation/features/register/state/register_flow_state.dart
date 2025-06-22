part of 'register_flow_bloc.dart';

enum RegisterStep {
  method,
  personalInformation,
  birthdayFilter,
  personalInclinations,
  personalLikes,
  complete,
}

class RegisterFlowState {
  final RegisterStep step;
  final AppUser user;
  final UserProfile profile;

  RegisterFlowState({
    required this.step,
    required this.user,
    required this.profile,
  });

  RegisterFlowState copyWith({
    RegisterStep? step,
    AppUser? user,
    UserProfile? profile,
  }) {
    return RegisterFlowState(
      step: step ?? this.step,
      user: user ?? this.user,
      profile: profile ?? this.profile,
    );
  }

  static final initial = RegisterFlowState(
    step: RegisterStep.method,
    user: AppUser.empty,
    profile: UserProfile.empty,
  );
}
