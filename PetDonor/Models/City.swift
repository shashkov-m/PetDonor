//
//  City.swift
//  PetDonor
//
//  Created by Max Shashkov on 17.12.2021.
//

import Foundation

struct CityResponse: Decodable {
  var response: Response?
}

struct Response: Decodable {
  var count: Int?
  var items: [City]?
}

struct City: Decodable {
  var id: Int?
  var title: String?
  var region: String?
}
