//
//
// UserModel.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 31/12/24
// Copyright © 2024 Differenz System Pvt. Ltd. All rights reserved.
//
import Foundation

struct UserModel: Codable {
    
    var uid : String?
    var name : String?
    var gender : String?
    var email : String?
    var password : String?
    var createdDate : String?
   
    
    enum CodingKeys: CodingKey {
        case uid, name, gender, email, password,createdDate
    }
    
    init?(dictionary : [String : Any]) {
        
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.createdDate = dictionary["createdDate"] as? String ?? ""
    }
}

/** Converts model into dictionary **/
extension UserModel {
    static func getUserInput(
        uid : String? = nil,
        name : String? = nil,
        gender : String? = nil,
        email : String? = nil,
        password : String? = nil,
        createdDate : String? = nil
    ) -> [String:Any] {
        var dict: [String:Any] = [:]
        dict["uid"] = uid ?? ""
        dict["name"] = name ?? ""
        dict["gender"] = gender ?? ""
        dict["email"] = email ?? ""
        dict["password"] = password ?? ""
        dict["createDate"] = createdDate ?? ""
        return dict
    }
}




