//
//
// FireBaseAppModel.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 01/01/25
// Copyright © 2025 Differenz System Pvt. Ltd. All rights reserved.
//

import Foundation
class FireBaseAppModel: ObservableObject {
    init () {}
   static var shared: FireBaseAppModel = FireBaseAppModel()
    @Published var isShowingDashboardView = false
    @Published var allJournalData : [JournalModal] = []
    @Published var themeColor = UserDefaults.themeColor
}

    
