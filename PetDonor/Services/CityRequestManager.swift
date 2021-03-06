//
//  CityRequestManager.swift
//  PetDonor
//
//  Created by Max Shashkov on 17.12.2021.
//

import Foundation

struct CityRequestManager {
  var urlComponentsDefault = URLComponents()
  private let accessToken = Keys.VKaccessToken
  init () {
    urlComponentsDefault.scheme = "https"
    urlComponentsDefault.host = "api.vk.com"
    urlComponentsDefault.path = "/method/database.getCities"
    urlComponentsDefault.queryItems = [
      URLQueryItem(name: "v", value: "5.131"),
      URLQueryItem(name: "access_token", value: accessToken),
      URLQueryItem(name: "country_id", value: "1"),
      URLQueryItem(name: "count", value: "7"),
      URLQueryItem(name: "need_all", value: "0")
    ]
  }
  @available (iOS 15, *)
  func getCities(query: String?) async throws -> [City] {
    var urlComponents = urlComponentsDefault
    if query != nil {
      urlComponents.queryItems?.append(URLQueryItem(name: "q", value: query))
    }
    guard let url = urlComponents.url else { throw NetworkErrors.urlCreationError }
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    let cityResponse = try decoder.decode(CityResponse.self, from: data)
    guard let response = cityResponse.response, let result = response.items
    else {
      throw NetworkErrors.emptyResponseError
    }
    return result
  }
  enum NetworkErrors: String, Error {
    case urlCreationError = "Ошибка создания URL из URLComponents"
    case emptyResponseError = "Отсутствуют значения в Response"
  }
}
