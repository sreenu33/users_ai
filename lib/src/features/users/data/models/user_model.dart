import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

/// User model for API data
@JsonSerializable()
class UserModel extends Equatable {
  final int id;
  final String name;
  final String username;
  final String email;
  @JsonKey(name: 'phone')
  final String? phoneNumber;
  final String? website;
  final AddressModel? address;
  final CompanyModel? company;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.website,
    this.address,
    this.company,
  });

  /// Factory constructor for creating a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts UserModel to JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Converts UserModel to domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      website: website,
      address: address?.toEntity(),
      company: company?.toEntity(),
    );
  }

  /// Creates UserModel from domain entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      username: entity.username,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      website: entity.website,
      address: entity.address != null
          ? AddressModel.fromEntity(entity.address!)
          : null,
      company: entity.company != null
          ? CompanyModel.fromEntity(entity.company!)
          : null,
    );
  }

  /// Creates a copy of UserModel with updated fields
  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    String? phoneNumber,
    String? website,
    AddressModel? address,
    CompanyModel? company,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      address: address ?? this.address,
      company: company ?? this.company,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    email,
    phoneNumber,
    website,
    address,
    company,
  ];
}

/// Address model
@JsonSerializable()
class AddressModel extends Equatable {
  final String? street;
  final String? suite;
  final String? city;
  @JsonKey(name: 'zipcode')
  final String? zipCode;
  final GeoModel? geo;

  const AddressModel({
    this.street,
    this.suite,
    this.city,
    this.zipCode,
    this.geo,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  AddressEntity toEntity() {
    return AddressEntity(
      street: street,
      suite: suite,
      city: city,
      zipCode: zipCode,
      geo: geo?.toEntity(),
    );
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      street: entity.street,
      suite: entity.suite,
      city: entity.city,
      zipCode: entity.zipCode,
      geo: entity.geo != null ? GeoModel.fromEntity(entity.geo!) : null,
    );
  }

  @override
  List<Object?> get props => [street, suite, city, zipCode, geo];
}

/// Geo coordinates model
@JsonSerializable()
class GeoModel extends Equatable {
  final String? lat;
  final String? lng;

  const GeoModel({this.lat, this.lng});

  factory GeoModel.fromJson(Map<String, dynamic> json) =>
      _$GeoModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeoModelToJson(this);

  GeoEntity toEntity() {
    return GeoEntity(lat: lat, lng: lng);
  }

  factory GeoModel.fromEntity(GeoEntity entity) {
    return GeoModel(lat: entity.lat, lng: entity.lng);
  }

  @override
  List<Object?> get props => [lat, lng];
}

/// Company model
@JsonSerializable()
class CompanyModel extends Equatable {
  final String? name;
  @JsonKey(name: 'catchPhrase')
  final String? catchPhrase;
  final String? bs;

  const CompanyModel({this.name, this.catchPhrase, this.bs});

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);

  CompanyEntity toEntity() {
    return CompanyEntity(name: name, catchPhrase: catchPhrase, bs: bs);
  }

  factory CompanyModel.fromEntity(CompanyEntity entity) {
    return CompanyModel(
      name: entity.name,
      catchPhrase: entity.catchPhrase,
      bs: entity.bs,
    );
  }

  @override
  List<Object?> get props => [name, catchPhrase, bs];
}
