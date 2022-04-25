import 'dart:convert';

List<Income> incomeFromJson(String str) =>
    List<Income>.from(json.decode(str).map((x) => Income.fromJson(x)));

String incomeToJson(List<Income> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Income {
  Income(
      {this.id,
      required this.motif,
      required this.value,
      this.createdAt,
      this.updatedAt});

  int? id;
  double value;
  String? motif;
  String? createdAt;
  String? updatedAt;

  factory Income.fromJson(Map<String, dynamic> json) => Income(
      id: json["id"],
      motif: json["motif"],
      value: json["value"],
      createdAt: json['created_at'],
      updatedAt: json['updated_at']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "created_at": createdAt,
        'updated_at': updatedAt
      };

  Income copy(
          {int? id,
          String? motif,
          double? value,
          String? createdAt,
          String? updatedAt}) =>
      Income(
        id: id ?? this.id,
        motif: motif ?? this.motif,
        value: value ?? this.value,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
