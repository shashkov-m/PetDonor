//
//  PetStruct.swift
//  PetDonor
//
//  Created by Shashkov Max on 07.12.2021.
//

import Foundation

protocol Pet {
  var description:String { get set}
}

struct Cat:Pet {
  var description: String
  let bloodType: CatBloodType
  
  enum CatBloodType {
    case A
    case B
    case AB
    case none
  }
  
}

struct Dog:Pet {
  var description: String
  let bloodType: DogBloodType
  
  enum DogBloodType {
    case none
  }
}
