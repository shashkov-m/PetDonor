//
//  CityRequestManager.swift
//  PetDonor
//
//  Created by Max Shashkov on 17.12.2021.
//

import Foundation

struct CityRequestManager {
  var urlComponentsDefault = URLComponents ()
  var q:String?
  private let accessToken = "b5c5ccd9cdbbe8c7ad1290643e3994808f9b2fd283fb5718d33319c5e98db2d27479b25385caab2f7334c"
  init () {
    urlComponentsDefault.scheme = "https"
    urlComponentsDefault.host = "api.vk.com"
    urlComponentsDefault.path = "/method/database.getCities"
    urlComponentsDefault.queryItems = [
      URLQueryItem (name: "v", value: "5.131"),
      URLQueryItem (name: "access_token", value: accessToken),
      URLQueryItem (name: "country_id", value: "1"),
      URLQueryItem (name: "count", value: "7")
    ]
  }
  func getCities () async throws -> [City] {
    guard let url = urlComponentsDefault.url else {throw NetworkErrors.urlCreationError}
    let (data, responce) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder ()
    let cityResponse = try decoder.decode(CityResponse.self, from: data)
    guard let response = cityResponse.response, let result = response.items else {throw NetworkErrors.emptyResponseError}
    return result
  }
  enum NetworkErrors:String, Error {
    case urlCreationError = "Ошибка создания URL из URLComponents"
    case emptyResponseError = "Отсутствуют значения в Response"
  }
}
