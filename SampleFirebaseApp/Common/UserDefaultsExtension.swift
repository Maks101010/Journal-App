//
//
// UserDefaultsExtension.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 31/12/24
// Copyright © 2024 Differenz System Pvt. Ltd. All rights reserved.
//


import Foundation
import SwiftUICore
import UIKit

/// `To Set and Get Data to UserDefaults`
extension UserDefaults {
    func setData<T: Codable>(_ data: T, _ key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    
    /// `To get Data from UserDefault`
    func getData<T: Codable>(_ key: String, data: T.Type) -> T? {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            let loadedPerson = try? decoder.decode(data, from: savedPerson)
            return loadedPerson
        } else {
            print("Error")
            return nil
        }
    }
    
    ///`Remove All Data from UserDefaults`
    func removeAll() {
        let domain = Bundle.main.bundleIdentifier!
        removePersistentDomain(forName: domain)
        synchronize()
    }
}
extension UserDefaults {
    ///`Auth Login`
    class var isLoggedIn : Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.kIsLogin)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kIsLogin)
        }
    }
}

extension UserDefaults {
    class var themeColor: Color {
          get {
              let index = UserDefaults.standard.integer(forKey: UserDefaultsKey.kAppThemeColor)
              return Constants.predefinedColors[index]
          }
          set {
              if let index = Constants.predefinedColors.firstIndex(of: newValue) {
                  UserDefaults.standard.set(index, forKey: UserDefaultsKey.kAppThemeColor)
              }
          }
      }
}
///`LoginUser`
extension UserDefaults {
    var loginUser: UserModel? {
        get {
            if object(forKey: #function) != nil {
                if let data = self.value(forKey: #function) as? Data {
                    let myObject = try? PropertyListDecoder().decode(UserModel.self, from: data)
                    return myObject!
                }
            }
            
            return nil
        }
        set {
            set(try? PropertyListEncoder().encode(newValue), forKey: #function)
            synchronize()
        }
    }
}


/// `UserDefaultsKey`
struct UserDefaultsKey {
    static let kLoginUser                           = "loginUser"
    static let kIsLogin                             = "isLogin"
    static let kAppThemeColor                       = "appthemeColor"
}

