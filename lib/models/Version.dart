class Version{
  final String currentVersion;
  final String recentVersion;
  final bool isRequired;

  Version({
    required this.currentVersion,
    required this.recentVersion,
    required this.isRequired,
  });

  factory Version.fromJson(Map<String, dynamic> json) => Version(
    currentVersion: json['current_version'],
    recentVersion: json['recent_version'],
    isRequired: json['is_required'],
  );
}