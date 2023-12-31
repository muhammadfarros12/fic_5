// {
//     "email": "faras@gmail.com",
//     "password": "1234",
//     "name": "Farros",
//     "avatar": "https://api.lorem.space/image/face?w=640&h=480",
//     "role": "customer",
//     "id": 252,
//     "creationAt": "2023-11-13T04:42:31.000Z",
//     "updatedAt": "2023-11-13T04:42:31.000Z"
// }

import 'dart:convert';

class RegisterResponseModel {
    String? email;
    String? password;
    String? name;
    String? avatar;
    String? role;
    int? id;
    DateTime? creationAt;
    DateTime? updatedAt;

    RegisterResponseModel({
        this.email,
        this.password,
        this.name,
        this.avatar,
        this.role,
        this.id,
        this.creationAt,
        this.updatedAt,
    });

    factory RegisterResponseModel.fromJson(String str) => RegisterResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RegisterResponseModel.fromMap(Map<String, dynamic> json) => RegisterResponseModel(
        email: json["email"],
        password: json["password"],
        name: json["name"],
        avatar: json["avatar"],
        role: json["role"],
        id: json["id"],
        creationAt: json["creationAt"] == null ? null : DateTime.parse(json["creationAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toMap() => {
        "email": email,
        "password": password,
        "name": name,
        "avatar": avatar,
        "role": role,
        "id": id,
        "creationAt": creationAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}



