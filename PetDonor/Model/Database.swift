//
//  Database.swift
//  PetDonor
//
//  Created by Max Shashkov on 03.01.2022.
//

import Foundation
import Firebase

final class Database {
  static let share = Database ()
  private let db = Firestore.firestore()
  private let user = Auth.auth().currentUser
  private let queue = DispatchQueue (label: "FirestoreAddDocumentQueue", qos: .utility, attributes: .concurrent)
  private let petCollection:CollectionReference
  private let petLimittedQuery:Query
  var limit = 3
  
  private init () {
    petCollection = db.collection("pets")
    petLimittedQuery = petCollection.whereField(PetKeys.isVisible.rawValue, isEqualTo: true).limit(to: limit).order(by: PetKeys.dateCreate.rawValue, descending: true)
  }
  enum Errors:Error {
    case s
  }
  
  func addPet (pet:Pet, completion: @escaping (Error?) -> ()) {
    let petObject:[String : Any] = [
      PetKeys.petType.rawValue : pet.petType?.rawValue ?? "",
      PetKeys.bloodType.rawValue : pet.bloodType ?? "",
      PetKeys.postType.rawValue : pet.postType ?? "",
      PetKeys.description.rawValue : pet.description ?? "",
      PetKeys.contactInfo.rawValue : pet.contactInfo ?? "",
      PetKeys.cityID.rawValue : pet.city?.id ?? 0,
      PetKeys.city.rawValue : pet.city?.title ?? "",
      PetKeys.dateCreate.rawValue : pet.dateCreate ?? Date.now,
      PetKeys.isVisible.rawValue : pet.isVisible,
      PetKeys.userID.rawValue : pet.userID
    ]
    let ref = petCollection
    queue.async {
      ref.document().setData (petObject) { error in
        if let error = error {
          completion (error)
        }
      }
    }
  }
  @available (iOS 15, *)
  func getPetList () async throws -> QuerySnapshot {
    let result = try await petLimittedQuery.getDocuments()
    return result
  }
  
  @available (iOS 15, *)
  func getNextPetsPart (from snapshot:QueryDocumentSnapshot) async throws -> QuerySnapshot {
    let query = petLimittedQuery.start(afterDocument: snapshot)
    let result = try await query.getDocuments()
    return result
  }
  
  @available (iOS 15, *)
  func updatePetList (from snapshot:QueryDocumentSnapshot) async throws ->QuerySnapshot {
    let query = petLimittedQuery.end(beforeDocument: snapshot)
    let result = try await query.getDocuments()
    return result
  }
}
