//
//  PetInfo.swift
//  PetDonor
//
//  Created by Max Shashkov on 28.12.2021.
//

import Foundation

let catBloodTypes = [
  "A",
  "B",
  "AB"
]
let dogBloodTypes = [
  "DEA 1.1",
  "DEA 1.2",
  "DEA 3",
  "DEA 4",
  "DEA 5",
  "DEA 6",
  "DEA 7"
]

enum PostType:Int {
  case recipient = 0
  case donor = 1
}

enum PetType:String {
  case cat = "Кошка"
  case dog = "Собака"
}
