import 'package:equatable/equatable.dart';

/// User entity for domain layer
class UserEntity extends Equatable {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? website;
  final AddressEntity? address;
  final CompanyEntity? company;

  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.website,
    this.address,
    this.company,
  });

  /// Returns formatted full address
  String get formattedAddress {
    if (address == null) return 'No address available';
    return '${address!.street ?? ''}, ${address!.suite ?? ''}, '
        '${address!.city ?? ''}, ${address!.zipCode ?? ''}';
  }

  /// Returns formatted company info
  String get companyInfo {
    if (company == null) return 'No company info';
    return company!.name ?? 'Unknown Company';
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

/// Address entity
class AddressEntity extends Equatable {
  final String? street;
  final String? suite;
  final String? city;
  final String? zipCode;
  final GeoEntity? geo;

  const AddressEntity({
    this.street,
    this.suite,
    this.city,
    this.zipCode,
    this.geo,
  });

  @override
  List<Object?> get props => [street, suite, city, zipCode, geo];
}

/// Geo coordinates entity
class GeoEntity extends Equatable {
  final String? lat;
  final String? lng;

  const GeoEntity({this.lat, this.lng});

  @override
  List<Object?> get props => [lat, lng];
}

/// Company entity
class CompanyEntity extends Equatable {
  final String? name;
  final String? catchPhrase;
  final String? bs;

  const CompanyEntity({this.name, this.catchPhrase, this.bs});

  @override
  List<Object?> get props => [name, catchPhrase, bs];
}
