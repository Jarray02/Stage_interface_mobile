import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class ProfileList {
  final List<Profile> profileList;
  ProfileList({
    required this.profileList,
  });

  ProfileList copyWith({
    List<Profile>? profileList,
  }) {
    return ProfileList(
      profileList: profileList ?? this.profileList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileList': profileList.map((x) => x.toMap()).toList(),
    };
  }

  factory ProfileList.fromMap(Map<String, dynamic> map) {
    return ProfileList(
      profileList: List<Profile>.from(
        (map['profileList'] as List<int>).map<Profile>(
          (x) => Profile.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileList.fromJson(String source) =>
      ProfileList.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProfileList(profileList: $profileList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is ProfileList && listEquals(other.profileList, profileList);
  }

  @override
  int get hashCode => profileList.hashCode;
}

class Profile {
  final String name;
  final int id;
  final AssetImage icon;
  final double maxTemp;
  final double maxHumid;
  Profile({
    required this.name,
    required this.id,
    required this.icon,
    required this.maxTemp,
    required this.maxHumid,
  });

  Profile copyWith({
    String? name,
    int? id,
    AssetImage? icon,
    double? maxTemp,
    double? maxHumid,
  }) {
    return Profile(
      name: name ?? this.name,
      id: id ?? this.id,
      icon: icon ?? this.icon,
      maxTemp: maxTemp ?? this.maxTemp,
      maxHumid: maxHumid ?? this.maxHumid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'maxTemp': maxTemp,
      'maxHumid': maxHumid,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      name: map['name'] as String,
      id: map['id'] as int,
      icon: map['icon'] as AssetImage,
      maxTemp: map['maxTemp'] as double,
      maxHumid: map['maxHumid'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Profile(name: $name, id: $id, icon: $icon, maxTemp: $maxTemp, maxHumid: $maxHumid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Profile &&
        other.name == name &&
        other.id == id &&
        other.icon == icon &&
        other.maxTemp == maxTemp &&
        other.maxHumid == maxHumid;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        icon.hashCode ^
        maxTemp.hashCode ^
        maxHumid.hashCode;
  }
}
