//
//  UserApi.swift
//  Resturants
//
//  Created by Mohsin on 26/09/2024.
//

import Foundation
import FirebaseFirestore

func fetchDocuments<T: Decodable>(from collectionPath: String, mapTo modelType: T.Type, completion: @escaping ([T]?) -> Void) {
    let db = Firestore.firestore()
    let documentRef = db.collection(collectionPath)
    
    documentRef.getDocuments { (querySnapshot, error) in
        if let error = error {
            DLog("Error getting documents: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        guard let documents = querySnapshot?.documents else {
            DLog("No documents found in collection: \(collectionPath)")
            completion(nil)
            return
        }
        
        let models = documents.compactMap { (document) -> T? in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                let decodedModel = try JSONDecoder().decode(T.self, from: jsonData)
                return decodedModel
            } catch {
                DLog("Error decoding document: \(error)")
                return nil
            }
        }
        completion(models)
    }
}


func fetchAllUsers(handler: @escaping ([UserModel]) -> Void) {
    let path = "Users"
    fetchDocuments(from: path, mapTo: UserModel.self) { arrayUsers in
        if let arrayUsers {
            handler(arrayUsers)
        }
    }
}
