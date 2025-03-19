part of 'app_bloc.dart';

final class AppState extends Equatable {
  const AppState({
    this.user = AppUser.empty,
  });

  final AppUser user;

  @override
  List<Object> get props => [user];

  AppState copyWith({AppUser? user}) {
    return AppState(
      user: user ?? this.user,
    );
  }
}
