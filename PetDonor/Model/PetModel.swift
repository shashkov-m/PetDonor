//
//  PetModel.swift
//  PetDonor
//
//  Created by Max Shashkov on 20.12.2021.
//

import Foundation

struct Pet {
  
  var city:City?
  let ownerId:Int
  let postId:Int
  var description:String?
  var contactInfo:String?
  var bloodType:String?
  var postType:PostType?
  var petType:String?
  
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
  
  enum PostType {
    case donor
    case recipient
  }
  
  enum PetType:String {
    case cat = "Кошка"
    case dog = "Собака"
  }
  
}

