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
  private let storage = Storage.storage()
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
  
  func addPet (pet:Pet, completion: @escaping (Result <Pet,Error>) -> ()) {
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
      PetKeys.userID.rawValue : pet.userID,
      PetKeys.reward.rawValue : pet.reward ?? ""
    ]
    let ref = petCollection
    queue.async {
      ref.document().setData (petObject) { error in
        if let error = error {
          completion (.failure(error))
        } else {
          completion (.success (pet))
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
  func convertSnapshotToPet (snapshot:QuerySnapshot) -> [Pet] {
    var array = [Pet] ()
    for document in snapshot.documents {
      let doc = document.data()
      if let petType = doc[PetKeys.petType.rawValue] as? String, let bloodType = doc[PetKeys.bloodType.rawValue] as? String,
         let postType = doc[PetKeys.postType.rawValue] as? String, let description = doc[PetKeys.description.rawValue] as? String,
         let contactInfo = doc[PetKeys.contactInfo.rawValue] as? String, let cityID = doc[PetKeys.cityID.rawValue] as? Int,
         let cityTitle = doc[PetKeys.city.rawValue] as? String, let dateCreate = doc[PetKeys.dateCreate.rawValue] as? Timestamp,
         let isVisible = doc[PetKeys.isVisible.rawValue] as? Bool, let userID = doc[PetKeys.userID.rawValue] as? String,
         let reward = doc[PetKeys.reward.rawValue] as? String
      {
        let city = City (id: cityID, title: cityTitle)
        let date = dateCreate.dateValue()
        let pet = Pet (city: city, description: description, contactInfo: contactInfo, bloodType: bloodType, postType: postType, petType: PetType.init(rawValue: petType), isVisible: isVisible, userID: userID, dateCreate: date, reward: reward)
        array.append(pet)
      }
    }
    return array
  }
}
