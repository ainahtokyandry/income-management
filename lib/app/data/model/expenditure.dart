import 'dart:convert';

List<Expenditure> expenditureFromJson(String str) => List<Expenditure>.from(
    json.decode(str).map((x) => Expenditure.fromJson(x)));

String expenditureToJson(List<Expenditure> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Expenditure {
  Expenditure(
      {this.id,
      required this.motif,
      required this.value,
      this.incomeId,
      this.createdAt,
      this.updatedAt});

  int? id;
  int? incomeId;
  String motif;
  double value;
  String? createdAt;
  String? updatedAt;

  factory Expenditure.fromJson(Map<String, dynamic> json) => Expenditure(
      id: json["id"],
      value: json["value"],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      incomeId: json['income_id'],
      motif: json['motif']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "created_at": createdAt,
        'updated_at': updatedAt,
        'motif': motif,
        'income_id': incomeId,
      };

  Expenditure copy(
          {int? id,
          String? motif,
          double? value,
          int? incomeId,
          String? createdAt,
          String? updatedAt}) =>
      Expenditure(
        id: id ?? this.id,
        value: value ?? this.value,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        motif: motif ?? this.motif,
        incomeId: incomeId ?? this.incomeId,
      );
}
