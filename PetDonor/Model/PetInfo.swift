//
//  PetInfo.swift
//  PetDonor
//
//  Created by Max Shashkov on 28.12.2021.
//

import Foundation

let catBloodTypes = [
  "Неизвестно",
  "A",
  "B",
  "AB"
]
let dogBloodTypes = [
  "Неизвестно",
  "DEA 1.1",
  "DEA 1.2",
  "DEA 3",
  "DEA 4",
  "DEA 5",
  "DEA 6",
  "DEA 7"
]

enum PostType:String {
  case recipient = "Реципиент"
  case donor = "Донор"
}

enum PetType:String,CaseIterable {
  case cat = "Кошка"
  case dog = "Собака"
}

enum PetKeys:String {
  case petType
  case bloodType
  case postType
  case description
  case contactInfo
  case cityID
  case city
  case dateCreate
  case isVisible
  case userID
  case reward
  case imageUrl
  case age
}
