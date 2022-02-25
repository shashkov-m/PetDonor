//
//  PetModel.swift
//  PetDonor
//
//  Created by Max Shashkov on 20.12.2021.
//
import Foundation

struct Pet {
  var city:City?
  var description:String?
  var contactInfo:String?
  var bloodType:String?
  var postType:String?
  var petType:PetType?
  var isVisible:Bool
  let userID:String
  var dateCreate:Date?
  var date:Date?
  var reward:String?
  var age:String?
  var imageUrl:String?
  var firebaseDocID:String?
  var birthDate:String?
}
