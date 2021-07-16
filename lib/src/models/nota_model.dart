// To parse this JSON data, do
//
//     final notaModel = notaModelFromJson(jsonString);

import 'dart:convert';

NotaModel notaModelFromJson(String str) => NotaModel.fromJson(json.decode(str));

String notaModelToJson(NotaModel data) => json.encode(data.toJson());

class NotaModel {
    NotaModel({
        this.id,
        this.parentid,
        this.title,
        this.body,
        this.active
    });

    int? id;
    int? parentid;
    String? title;
    String? body;
    int? active;

    factory NotaModel.fromJson(Map<String, dynamic> json) => NotaModel(
        id: json["id"],
        parentid: json["parentid"],
        title: json["title"],
        body: json["body"],
        active: json["active"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "parentid": parentid,
        "title": title,
        "body": body,
        "active": active
    };
}
