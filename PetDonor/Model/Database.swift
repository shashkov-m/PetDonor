//
//  Database.swift
//  PetDonor
//
//  Created by Max Shashkov on 03.01.2022.
//

import Foundation
import Firebase

struct DB {
  let db = Firestore.firestore()
  let user = Auth.auth().currentUser
  private let userCollection = "users"
  private let petCollection = "pets"
  private let queue = DispatchQueue (label: "FirestoreAddDocumentQueue", qos: .utility, attributes: .concurrent)
  func addPet (pet:Pet) {
    guard let userId = user?.uid else { return }
    let now = Date ()
    let dateFormatter = DateFormatter ()
    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    let stringDate = dateFormatter.string(from: now)
    let petObject:[String : Any] = [
      "Pet type" : pet.petType?.rawValue ?? "",
      "Blood type" : pet.bloodType ?? "",
      "Post type" : pet.postType ?? "",
      "Description" : pet.description ?? "",
      "Contact info" : pet.contactInfo ?? "",
      "City id" : pet.city?.id ?? "",
      "City:" : pet.city?.title ?? "",
      "isVisible" : pet.isVisible
    ]
    queue.async {
      db.collection(userCollection).document(userId).collection(petCollection).document(stringDate).setData (petObject) { error in
        if let error = error {
          print (error.localizedDescription)
        }
      }
    }
  }
}
