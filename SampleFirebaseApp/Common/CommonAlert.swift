//
//
// CommonAlert.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 31/12/24
// Copyright © 2024 Differenz System Pvt. Ltd. All rights reserved.
//


import Foundation
import SwiftUI

///`AlertData`
class AlertData {
    
    static var empty = AlertData(title: "Sample", message: "Empty", isLogOut: false)
    var title: String
    var message: String
    var isLogOut: Bool
    
    
    
    private(set) var dismissButton: Alert.Button = .default(Text("OK"))
    
    init(title: String, message: String, isLogOut: Bool) {
        
        self.title = title
        self.message = message
        self.isLogOut = isLogOut
        
        if isLogOut {
            dismissButton = .default(Text("OK")){
                
            }
        }
    }
}
extension Alert {
    //Authentication expired and Common message  Alert
    static func show(title: String = "", message: String = "", isLogOut: Bool = false) {
        NotificationCenter.default.post(name: .showAlert, object: AlertData(title: title, message: message, isLogOut: isLogOut))
    }
}
