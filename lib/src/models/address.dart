import 'dart:convert';

Address AddressFromJson(String str) => Address.fromJson(json.decode(str));

String AddressToJson(Address data) => json.encode(data.toJson());

class Address {
  String? id;
  String? idUser;
  String? address;
  String? neighborhood;
  double? lat;
  double? lng;
  List<Address> toList = [];

  Address({
    this.id,
    this.idUser,
    this.address,
    this.neighborhood,
    this.lat,
    this.lng,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"] is int ? json['id'].toString() : json['id'],
    idUser: json["id_user"],
    address: json["address"],
    neighborhood: json["neighborhood"],
    lat: json['lat'] is String ? double.parse(json['lat']) : json['lat'],
    lng: json['lng'] is String ? double.parse(json['lng']) : json['lng']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_user": idUser,
    "address": address,
    "neighborhood": neighborhood,
    "lat": lat,
    "lng": lng,
  };

  Address.fromJsonList(List<dynamic>? jsonList){
    if(jsonList == null){
      return;
    }else{
      jsonList.forEach((item) {
        Address address = Address.fromJson(item);
        toList.add(address);
      });
    }
  }

}