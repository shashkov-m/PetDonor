//
//  Database.swift
//  PetDonor
//
//  Created by Max Shashkov on 03.01.2022.
//

import Foundation
import Firebase
import UIKit

final class Database {
  static let share = Database ()
  private let db = Firestore.firestore()
  private let storage = Storage.storage()
  private let user = Auth.auth().currentUser
  private let queue = DispatchQueue (label: "FirestoreAddDocumentQueue", qos: .utility, attributes: .concurrent )
  let petCollection:CollectionReference
  let petVisibleOnlyQuery:Query
  private let storageImagesPath = "petImages"
  var limit = 3
  
  private init () {
    petCollection = db.collection("pets")
    petVisibleOnlyQuery = petCollection.whereField(PetKeys.isVisible.rawValue, isEqualTo: true)
  }
  enum Errors:Error {
    case imageUploadError
  }
  
  func addPet (pet:Pet, image:UIImage?, completion: @escaping (Result <Pet,Error>) -> ()) {
    let ref = petCollection
    var pet = pet
    if let image = image, let data = image.jpegData(compressionQuality: 0.4) {
      let imagePath = "\(storageImagesPath)/\(pet.userID)/\(pet.dateCreate ?? Date.now).jpg"
      let storageRef = storage.reference(withPath: "\(imagePath)")
      pet.imageUrl = imagePath
      queue.async () {
        storageRef.putData(data, metadata: nil)
      }
    }
    queue.async () {
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
        PetKeys.reward.rawValue : pet.reward ?? "",
        PetKeys.imageUrl.rawValue : pet.imageUrl ?? "",
        PetKeys.age.rawValue : pet.age ?? ""
      ]
      ref.document().setData (petObject) { error in
        if let error = error {
          completion (.failure(error))
        } else {
          completion (.success (pet))
        }
      }
    }
  }
  
  //  @available (iOS 15, *)
  //  func getPetList () async throws -> QuerySnapshot {
  //    let result = try await petLimittedQuery.getDocuments()
  //    return result
  //  }
  
  @available (iOS 15, *)
  func getNextPetsPart (from snapshot:QueryDocumentSnapshot, filterOrNil: [String:Any]?) async throws -> QuerySnapshot {
    let query = petVisibleOnlyQuery
    if let filter = filterOrNil {
      filter.forEach { field in
        query.whereField(field.key, isEqualTo: field.value)
      }
    }
    query.limit(to: limit).order(by: PetKeys.dateCreate.rawValue, descending: true)
    query.start(afterDocument: snapshot)
    let result = try await query.getDocuments()
    return result
  }
  @available (iOS 15, *)
  func getPetsWithFilter (filter: [String:Any]) async throws -> QuerySnapshot {
    let query = petVisibleOnlyQuery
    filter.forEach { field in
      print (field)
      query.whereField(field.key, isEqualTo: field.value)
    }
    query.limit(to: limit).order(by: PetKeys.dateCreate.rawValue, descending: true)
    print (query)
    let result = try await query.getDocuments()
    return result
  }
  
  @available (iOS 15, *)
  func getUserPets (for user:User) async throws -> [Pet] {
    let query = petCollection.whereField(PetKeys.userID.rawValue, isEqualTo: user.uid).limit(to: limit).order(by: PetKeys.dateCreate.rawValue, descending: true)
    let result = try await query.getDocuments()
    return convertSnapshotToPet(snapshot: result)
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
