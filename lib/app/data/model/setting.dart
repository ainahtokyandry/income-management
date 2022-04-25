import 'dart:convert';

List<Setting> settingFromJson(String str) =>
    List<Setting>.from(json.decode(str).map((x) => Setting.fromJson(x)));

String settingToJson(List<Setting> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Setting {
  Setting(
      {this.id,
      required this.name,
      required this.value,
      this.createdAt,
      this.updatedAt});

  int? id;
  String name;
  String value;
  String? createdAt;
  String? updatedAt;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
      id: json["id"],
      value: json["value"],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      name: json['updated_at']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "created_at": createdAt,
        'updated_at': updatedAt
      };

  Setting copy(
          {int? id,
          String? name,
          String? value,
          String? createdAt,
          String? updatedAt}) =>
      Setting(
        id: id ?? this.id,
        value: value ?? this.value,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name,
      );
}
