import CoreData

extension UserEntity {

  var user: User {
    return User(
      id: Int(exactly: identifier) ?? 0,
      name: name ?? "",
      email: email ?? "",
      address: Address(
        street: addressStreet ?? "",
        suite: addressSuite ?? "",
        city: addressCity ?? "",
        zipcode: addressZipcode ?? "",
        geo: Coordinate(
          latitude: addressLatitude,
          longitude: addressLongitude
        )
      ),
      phone: phone ?? "",
      website: website ?? "",
      company: Company(
        name: companyName ?? "",
        catchPhrase: companyCatchPhrase ?? "",
        bs: companyBS ?? ""
      )
    )
  }

  func updateFields(with user: User) {
    identifier = Int64(user.id)
    name = user.name
    email = user.email
    addressStreet = user.address.street
    addressSuite = user.address.suite
    addressCity = user.address.city
    addressZipcode = user.address.zipcode
    addressLatitude = user.address.geo.latitude
    addressLongitude = user.address.geo.longitude
    phone = user.phone
    website = user.website
    companyName = user.company.name
    companyCatchPhrase = user.company.catchPhrase
    companyBS = user.company.bs
  }

}
