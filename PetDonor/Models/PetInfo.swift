//
//  PetInfo.swift
//  PetDonor
//
//  Created by Max Shashkov on 28.12.2021.
//

import Foundation

let petDateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "dd.MM.yyyy"
  return formatter
}()

let catBloodTypes = [
  "Неизвестно",
  "A",
  "B",
  "AB"
]
let dogBloodTypes = [
  "Неизвестно",
  "DEA 1+",
  "DEA 1-"
]

enum PostType: String {
  case recipient = "Реципиент"
  case donor = "Донор"
}

enum PetType: String, CaseIterable {
  case cat = "Кошка"
  case dog = "Собака"
}

enum PetKeys: String {
  case petType
  case bloodType
  case postType
  case description
  case contactInfo
  case cityID
  case city
  case dateCreate
  case date
  case isVisible
  case userID
  case reward
  case imageUrl
  case birthDate
  case firebaseDocID
}
