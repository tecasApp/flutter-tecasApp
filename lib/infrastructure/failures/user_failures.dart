class PersonalInformationRegisterFailure implements Exception {
  const PersonalInformationRegisterFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory PersonalInformationRegisterFailure.fromCode(String code) {
    switch (code) {
      default:
        return const PersonalInformationRegisterFailure();
    }
  }

  final String message;
}
