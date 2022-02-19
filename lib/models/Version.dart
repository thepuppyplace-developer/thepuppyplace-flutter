class Version{
  String? version;
  bool? force;

  Version({
    this.version,
    this.force
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