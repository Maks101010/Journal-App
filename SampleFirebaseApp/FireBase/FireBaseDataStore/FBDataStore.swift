//
//
// FBDataStore.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 31/12/24
// Copyright © 2024 Differenz System Pvt. Ltd. All rights reserved.
//


import Foundation
import FirebaseFirestore



enum FBDataStoreCollection : String {
    case users = "Users"
    case Journal = "Journal"
}

class FBDataStore {
    static let shared : FBDataStore = FBDataStore()
    private init () {}
    let db : Firestore = Firestore.firestore()
}




extension FBDataStore {
    func setUserData (for userID : String, userDict : [String : Any] , completion : @escaping (()->())) {
        self.db.getCollection(.users).document(userID).setData(userDict) { error in
            if let error = error as? NSError {
                
                print("error getting for  set the user data with documentId: \(userID), error: \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
}

extension FBDataStore {
    func getUserData(for userID: String , completion :@escaping ((UserModel?) -> ())){
        self.db.getCollection(.users).document(userID).getDocument{ FBData , error in
            if let error = error as? NSError {
                print("error getting data from UserDocument with id \(userID) , error \(error.localizedDescription) ")
                Indicator.hide()
                completion(nil)
            }
            else {
                guard let document = FBData else {return}
                do {
                    let messageModel = try document.data(as: UserModel.self)
                    Indicator.hide()
                    completion(messageModel)
                }
                catch let error {
                    print("Error in read(from:ofType:) description= \(error.localizedDescription)")
                }
            }
            
        }
    }
}




extension Firestore {
    func getCollection(_ collectionPath: FBDataStoreCollection) -> CollectionReference {
        self.collection(collectionPath.rawValue)
    }
}



extension FBDataStore {
    func setJournalData( userId:String , documentID : String , userDict : [String : Any] ,  completion : @escaping (()->())){
        self.db.getCollection(.Journal).document(userId).collection("JournalDoc").document(documentID).setData(userDict){ error in
            if let error = error as? NSError {
                
                print("error getting for  set the journal data with documentId: \(userId), error: \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
}




extension FBDataStore {
    func getAllJournalDocuments(for userID: String, completion: @escaping ([JournalModal]?) -> Void) {
        // Reference the specific collection within the user's document
        self.db.getCollection(.Journal)
            .document(userID)
            .collection("JournalDoc")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    completion(nil)
                    Indicator.hide()
                    return
                }
                
                // Ensure there are documents in the snapshot
                guard let documents = querySnapshot?.documents else {
                    print("No documents found in JournalDoc for userID: \(userID)")
                    Indicator.hide()
                    completion(nil)
                    return
                }
                
                // Extract the data from each document
                let JournalData: [JournalModal] = documents.compactMap({ snapshot -> JournalModal? in
                    
                    do {
                        return try snapshot.data(as: JournalModal.self)
                    } catch let error {
                        print("error decoding message data with documentId, error: \(error.localizedDescription)")
                        return nil
                    }
                })
                Indicator.hide()
                completion(JournalData)
            }
    }
}


extension FBDataStore {
    func deleteJournalData(for userId : String, documentTimeStamp : String , completion: @escaping (()->())){
        self.db.getCollection(.Journal).document(userId).collection("JournalDoc").document(documentTimeStamp).delete(){ error in
            if error == nil {
                completion()
            }
            else {
                print("error in deleting",error ?? "")
                Indicator.hide()
                return
            }
        }
    }
}
