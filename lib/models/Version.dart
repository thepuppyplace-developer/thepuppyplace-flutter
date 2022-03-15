class Version{
  String version;
  bool force;

  Version({
    required this.version,
    required this.force
  });

  factory Version.fromJson(Map<String, dynamic> json) => Version(
    version: json['version'],
    force: json['force'],
  );

  Map<String, dynamic> toJson() => {
    'version': version,
    'force': force,
  };
}