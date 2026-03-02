abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String userIdentifier;
  final bool isEmailLogin;
  ProfileLoaded({required this.userIdentifier, required this.isEmailLogin});
}

class ProfileLoggedOut extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
