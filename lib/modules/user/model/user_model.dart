// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? id;

  String? employeeId;

  String? name;

  File? imgUrl;

  DateTime? dob;

  String? nationality;

  UserModel(
      {this.id,
      this.employeeId,
      this.name,
      this.dob,
      this.nationality,
      this.imgUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      employeeId: json["employeeId"],
      name: json["name"],
      nationality: json['nationality'],
      dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
      imgUrl: json['imgUrl'] == null ? null : File(json['imgUrl']));

  Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "name": name,
        "imgUrl": imgUrl?.path,
        "dob": dob?.toIso8601String(),
        "nationality": nationality
      };
}
