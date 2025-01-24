//
//
// FireBaseAuthService.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 31/12/24
// Copyright © 2024 Differenz System Pvt. Ltd. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseAuth


class FireBaseAuthService {
    static let shared : FireBaseAuthService = FireBaseAuthService()
    private var FireBaseUser : User?
    private init() {}
}


extension FireBaseAuthService {
    func signUp(name : String, gender : String,  email: String , password : String , completion : @escaping (_ userModel : UserModel? ) -> Void ) {
        Auth.auth().createUser(withEmail: email , password: password) { (result , error) in
            guard error == nil
            else {
                self.handleError(error!)
                Indicator.hide()
                return
            }
            guard let user = result?.user
            else {
                Indicator.hide()
                print("No user data here....")
                return
            }
            
            let userDict: [String: Any] = UserModel.getUserInput(
                uid: user.uid,
                name: name ,
                gender: gender,
                email: user.email,
                password: password,
                createdDate: Date().formatted()
            )

            
            FBDataStore.shared.setUserData(for: user.uid, userDict: userDict) {
                Indicator.hide()
                UserDefaults.standard.loginUser = UserModel(dictionary: userDict)
                UserDefaults.isLoggedIn = true
                completion(UserModel(dictionary: userDict))
            }
            
        }
    }
}



extension FireBaseAuthService {
    func signIn(with email : String , and password : String, completion : @escaping ((UserModel?) -> ())){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil
            else {
                Indicator.hide()
                self.handleError(error!)
                return
            }
            guard let user = result?.user
            else {
                Indicator.hide()
                return
            }
            
            FBDataStore.shared.getUserData(for: user.uid){userModel in
                Indicator.hide()
                UserDefaults.standard.loginUser = userModel
                UserDefaults.isLoggedIn = true
                completion(userModel)
            }
        }
        
    }
}

extension FireBaseAuthService {
    func Updatepassword(userId : String,name : String, gender : String,  email: String , password : String , completion : @escaping (_ userModel : UserModel? ) -> Void ) {
        
        
        if password != UserDefaults.standard.loginUser?.password ?? "" {
            guard let user = Auth.auth().currentUser else {
                Indicator.hide()
                Alert.show(message: "Something went wrong.")
                return
            }
            
            user.updatePassword(to: password) { error in
                guard error == nil else {
                    Indicator.hide()
                    self.handleError(error!)
                    return
                }
            }
        }
        
        let userDict: [String: Any] = UserModel.getUserInput(
            uid: userId,
            name: name ,
            gender: gender,
            email: email,
            password: password,
            createdDate: UserDefaults.standard.loginUser?.createdDate ?? Date().formatted()
        )
        
        
        FBDataStore.shared.setUserData(for: userId, userDict: userDict) {
            Indicator.hide()
            UserDefaults.standard.loginUser = UserModel(dictionary: userDict)
            UserDefaults.isLoggedIn = true
            completion(UserModel(dictionary: userDict))
        }
        
        
        
    }
}


extension FireBaseAuthService {
    func handleError(_ error: Error) {
        print(error.localizedDescription)
        Alert.show(message: error.localizedDescription)
    }
}


extension FireBaseAuthService {
    func setJournalData (with userId:String, isBuyOrSell : String , tradeName : String , entryQunatity : Int, entryPrice: Double , exitedPrice: Double,completion : @escaping (_ userModel : JournalModal? ) -> Void) {
        
        
        let date = "\(Int64(Date().timeIntervalSince1970))"
        var totalPAndL : Double = 0.0
        let exitValue = exitedPrice * Double(entryQunatity)
        let entryValue = entryPrice * Double(entryQunatity)

        if isBuyOrSell == "Buy" {
            totalPAndL = exitValue - entryValue
        }
        else if isBuyOrSell == "Sell" {
            totalPAndL = entryValue - exitValue
        }
        
        let journalDict : [String : Any] = JournalModal.getUserJournalInput(
            tradeName: tradeName,
            buyORsell: isBuyOrSell,
            entryQuantity: entryQunatity,
            entryPrice: entryPrice,
            exitQuantity: entryQunatity,
            exitPrice: exitedPrice,
            totalPAndL: totalPAndL,
            investedAmount:  entryValue,
            createdDate: Date().formatted(),
            timeStampIdentifier: date
        )
        
        FBDataStore.shared.setJournalData(userId: userId,documentID: date , userDict: journalDict){
            completion(JournalModal(dictionary: journalDict))
        }
        
    }
}

extension FireBaseAuthService {
    func logoutUser(completion: (() -> ())) {
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.loginUser = nil
            UserDefaults.isLoggedIn = false
            completion()
        } catch {
            Alert.show(message: error.localizedDescription)
        }
    }
}


extension FireBaseAuthService {
    func generateRandomizedJournalData(userId: String, numberOfEntries: Int) {
        let nseTradeNames = [
            "RELIANCE", "TCS", "INFOSYS", "HDFC", "ICICI BANK","WIPRO", "ADANI", "TATA MOTORS", "MARUTI SUZUKI", "SBI"
        ]
        
        for i in 0..<numberOfEntries {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                let tradeName = nseTradeNames.randomElement() ?? "Unknown"
                let isBuyOrSell = Bool.random() ? "Buy" : "Sell"
                let entryQuantity = Int.random(in: 10...200)
                let entryPrice = Double.random(in: 100.0...200.0)
                let exitedPrice = Double.random(in: 100.0...400.0)
                
                self.setJournalData(
                    with: userId,
                    isBuyOrSell: isBuyOrSell,
                    tradeName: tradeName,
                    entryQunatity: entryQuantity,
                    entryPrice: entryPrice,
                    exitedPrice: exitedPrice
                ) { journalModel in
                    if let journal = journalModel {
                        print("Journal Entry Created: \(journal)")
                    } else {
                        print("Failed to create journal entry.")
                    }
                }
            }
        }
    }
}


extension FireBaseAuthService {
    func isUserLoggedIn(completion: @escaping (Bool, String?) -> ()) {
        // Check if the user's email matches the saved email in UserDefaults
        if Auth.auth().currentUser?.email == UserDefaults.standard.loginUser?.email {
            if let user = Auth.auth().currentUser {
                refreshUserToken(user) {
                    // User is valid and authenticated
                    UserDefaults.isLoggedIn = true
                    Indicator.hide()
                    completion(true, nil) // No error, user is logged in
                } failure: { error in
                    UserDefaults.standard.loginUser = nil
                    UserDefaults.isLoggedIn = false
                    Indicator.hide()
                    completion(false, error) // Pass error as string
                }
            }
        } else {
            // Handle mismatch or no user logged in
            UserDefaults.standard.loginUser = nil
            UserDefaults.isLoggedIn = false
            Indicator.hide()
            completion(false, "Authentication mismatch or no user found. Please log in again.") // Pass failure message
        }
    }

    func refreshUserToken(_ user: User, completion: @escaping () -> (), failure: @escaping (String) -> ()) {
        user.getIDTokenForcingRefresh(true) { (token, error) in
            if let error = error {
                print("Token refresh failed: \(error.localizedDescription)")
                failure("\(error.localizedDescription)") // Pass the error as a string
            } else {
                print("Token refreshed successfully.")
                completion() // No error
            }
        }
    }
}
