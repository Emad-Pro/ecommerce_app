class ValidationErrorModel {
  final int status;
  final String title;
  final Map<String, List<String>> errors;

  const ValidationErrorModel({
    required this.status,
    required this.title,
    required this.errors,
  });

  factory ValidationErrorModel.fromJson(Map<String, dynamic> json) {
    final rawErrors = json['errors'];
    final Map<String, List<String>> parsed = {};

    if (rawErrors is Map) {
      for (final entry in rawErrors.entries) {
        final key = entry.key.toString();
        final v = entry.value;

        if (v is List) {
          parsed[key] = v.map((e) => e.toString()).toList();
        } else if (v is String) {
          parsed[key] = [v];
        } else {
          parsed[key] = [v.toString()];
        }
      }
    }

    return ValidationErrorModel(
      status: (json['status'] as int?) ?? 400,
      title: (json['title']?.toString() ?? 'Validation error'),
      errors: parsed,
    );
  }

  /// أول رسالة لعرضها في SnackBar
  String get firstMessage {
    if (errors.isEmpty) return title;
    final k = errors.keys.first;
    return errors[k]!.isNotEmpty ? errors[k]!.first : title;
  }
}
