//
//  PetStruct.swift
//  PetDonor
//
//  Created by Shashkov Max on 07.12.2021.
//

import Foundation

struct Pet {
  var petType:PetType?
  var bloodType = ""
  enum CatBloodType:String {
    case A
    case B
    case AB
    case none
  }
  
  enum DogBloodType:String {
    case none
  }
  
  enum PetType {
    case cat
    case dog
  }
  
}
