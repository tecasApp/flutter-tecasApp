part of 'register_flow_bloc.dart';

abstract class RegisterFlowEvent {}

class GoToNextStep extends RegisterFlowEvent {}

class GoToPreviousStep extends RegisterFlowEvent {}

class UpdateProfileData extends RegisterFlowEvent {
  final UserProfile updatedProfile;
  UpdateProfileData(this.updatedProfile);
}
