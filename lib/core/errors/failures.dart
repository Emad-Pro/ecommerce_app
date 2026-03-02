abstract class Failure {
  final String? message;
  final int? code;
  final bool? phoneIsVerfied;

  const Failure({this.message, this.code, this.phoneIsVerfied});
}
