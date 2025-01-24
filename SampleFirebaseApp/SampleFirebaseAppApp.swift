//
//
// SampleFirebaseAppApp.swift
// SampleFirebaseApp
//
// Created by Shubh Magdani on 02/01/25
// Copyright © 2025 Differenz System Pvt. Ltd. All rights reserved.
//


import SwiftUI

@main
struct SampleFirebaseAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var alert: AlertData = AlertData.empty
    @State private var showAlert: Bool = false
    @State private var showLoader: Bool = false
    @StateObject var viewModel: FireBaseAppModel = .shared
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView()
            }
            .onReceive(NotificationCenter.default.publisher(for: .showAlert)) { result in
                if let alert = result.object as? AlertData {
                    self.alert = alert
                    self.showAlert = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .showLoader)) { result in
                if let loaderData = result.object as? [Any], let showLoader = loaderData.first as? Bool {
                    print("showLoader - \(showLoader)")
                    self.showLoader = showLoader
                }
            }
            .activityIndicator(show: self.showLoader)

            .alert(isPresented: $showAlert) {
                if self.alert.isLogOut == true {
                    return Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
                } else
                {
                    return Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
                }
                
            }
            .modifier(AlertButtonTintColor(color: $viewModel.themeColor))
            
        }
    }
}
