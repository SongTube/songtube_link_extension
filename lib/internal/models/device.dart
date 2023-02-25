// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Device {

  String name;
  Uri uri;
  Device({
    required this.name,
    required this.uri,
  });


  Device copyWith({
    String? name,
    Uri? uri,
  }) {
    return Device(
      name: name ?? this.name,
      uri: uri ?? this.uri,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uri': uri.toString(),
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      name: map['name'] as String,
      uri: Uri.parse(map['uri']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) => Device.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Device(name: $name, uri: $uri)';

  @override
  bool operator ==(covariant Device other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.uri == uri;
  }

  @override
  int get hashCode => name.hashCode ^ uri.hashCode;
}
