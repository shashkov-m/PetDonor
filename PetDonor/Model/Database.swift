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
  var limit = 5
  
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
    var tmpQuery = petVisibleOnlyQuery
    if let filter = filterOrNil {
      filter.forEach { field in
        tmpQuery = tmpQuery.whereField(field.key, isEqualTo: field.value)
      }
    }
    let query = tmpQuery.limit(to: limit).order(by: PetKeys.dateCreate.rawValue, descending: true).start(afterDocument: snapshot)
    let result = try await query.getDocuments()
    return result
  }
  @available (iOS 15, *)
  func getPetsWithFilter (filter: [String:Any]) async throws -> QuerySnapshot {
    var tmpQuery = petVisibleOnlyQuery
    filter.forEach { field in
      tmpQuery = tmpQuery.whereField(field.key, isEqualTo: field.value)
    }
    let query = tmpQuery.limit(to: limit).order(by: PetKeys.dateCreate.rawValue, descending: true)
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
      if let petType = doc[PetKeys.petType.rawValue] as? String,
         let bloodType = doc[PetKeys.bloodType.rawValue] as? String,
         let postType = doc[PetKeys.postType.rawValue] as? String,
         let description = doc[PetKeys.description.rawValue] as? String,
         let contactInfo = doc[PetKeys.contactInfo.rawValue] as? String,
         let cityID = doc[PetKeys.cityID.rawValue] as? Int,
         let cityTitle = doc[PetKeys.city.rawValue] as? String,
         let dateCreate = doc[PetKeys.dateCreate.rawValue] as? Timestamp,
         let isVisible = doc[PetKeys.isVisible.rawValue] as? Bool,
         let userID = doc[PetKeys.userID.rawValue] as? String,
         let reward = doc[PetKeys.reward.rawValue] as? String,
         let imageUrl = doc [PetKeys.imageUrl.rawValue] as? String,
         let birthDate = doc [PetKeys.age.rawValue] as? String
      {
        let city = City (id: cityID, title: cityTitle)
        let date = dateCreate.dateValue()
        var age = birthDate
        let calendar = Calendar.current
        let formatter = DateFormatter ()
        formatter.dateFormat = "dd.MM.yyyy"
        if let tmpAge = formatter.date(from: birthDate) {
          let components = calendar.dateComponents([.year, .month], from: tmpAge, to: Date ())
          age = ruDatePlural(year: components.year, month: components.month)
        }
        let pet = Pet (city: city, description: description, contactInfo: contactInfo, bloodType: bloodType, postType: postType, petType: PetType.init(rawValue: petType), isVisible: isVisible, userID: userID, dateCreate: date, reward: reward, age: age, imageUrl: imageUrl)
        array.append(pet)
      }
    }
    return array
  }
  func ruDatePlural (year:Int?, month:Int?) -> String {
    var ruYears = "год"
    var ruMonths = "месяц"
    switch year {
    case 1:
      break
    case 2,3,4:
      ruYears += "а"
    default:
      ruYears = "лет"
    }
    switch month {
    case 1:
      break
    case 2,3,4:
      ruMonths += "а"
    default:
      ruMonths += "ев"
    }
    let result = "\(year ?? 0) \(ruYears), \(month ?? 0) \(ruMonths)"
    return result
  }
  func getImageReference (from string:String) -> StorageReference {
    let storageRef = storage.reference()
    return storageRef.child(string)
  }
}
