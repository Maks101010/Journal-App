//
//
// ProfileView.swift
// SampleFirebaseApp
//
// Created by Shubh Magdani on 09/01/25
// Copyright © 2025 Differenz System Pvt. Ltd. All rights reserved.
//


import Foundation
import SwiftUI


struct ProfileView : View {
    @StateObject var viewModel: FireBaseAppModel = .shared
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @State var name : String = ""
    @State var email : String = ""
    @State var gender : String = ""
    @State var password : String = ""
    @State var confirmPassword : String = ""
    @State var isPopupTrue = false
    
    var body: some View {
        ZStack {
            VStack{
                ScrollView {
                    VStack (spacing: 30){
                        
                        TextFieldView(placeholder: "Name", text: $name)
                        TextFieldView(placeholder: "Email", text: $email)
                            .disabled(true)
                        GenderPicker(placeholder: "Gender", text: $gender)
                        SecureFieldView(placeholder: "Change Password", text: $password)
                            
                                
                                
                                   
                                 
                            
                        if UserDefaults.standard.loginUser?.password ?? "" != password {
                            SecureFieldView(placeholder: "Confirm Password", text: $confirmPassword)
                        }
                        
                        
                        
                        ButtonView(title: "Update Profile", action: {
                            Indicator.show()
                            if UserDefaults.standard.loginUser?.password ?? "" != password {
                                if !name.isEmpty && !email.isEmpty && !gender.isEmpty && !password.isEmpty && !confirmPassword.isEmpty {
                                    if password == confirmPassword {
                                        FireBaseAuthService.shared.Updatepassword(userId: UserDefaults.standard.loginUser?.uid ?? "", name: name, gender: gender, email: email, password: password) { userModel in
                                            FireBaseAuthService.shared.logoutUser() {
                                                viewModel.isShowingDashboardView = false
                                                UserDefaults.isLoggedIn = false
                                                NavigationUtil.popToRootView()
                                            }
                                        }
                                    }
                                    else {
                                        Indicator.hide()
                                        Alert.show(message: "Passwords don't match.")
                                        return
                                    }
                                }
                                else {
                                    Indicator.hide()
                                    Alert.show(message:"All fields Are required.")
                                    return
                                }
                            }
                            else {
                                if !name.isEmpty && !email.isEmpty && !gender.isEmpty && !password.isEmpty {
                                    FireBaseAuthService.shared.Updatepassword(userId: UserDefaults.standard.loginUser?.uid ?? "", name: name, gender: gender, email: email, password: password) { userModel in
                                        if userModel != nil {
                                           
                                            dismiss()
                                            
                                        }
                                        else {
                                            Indicator.hide()
                                            FireBaseAuthService.shared.logoutUser() {
                                                viewModel.isShowingDashboardView = false
                                                UserDefaults.isLoggedIn = false
                                                viewModel.allJournalData = []
                                                NavigationUtil.popToRootView()
                                            }
                                        }
                                    }
                                }
                            }
                            
                        })
                        
                        
                        
                    }
                    .padding()
                }
            }
            .navigationBarHidden(isPopupTrue)
            .navigationTitle("Profile")
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement:.topBarLeading) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }){
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(viewModel.themeColor)
                                    Text("Back")
                                .foregroundStyle(viewModel.themeColor)
                                }
                    }
                       
                    
                        
                   
                }
            }
            .blur(radius: isPopupTrue ? 15 : 0)
            if isPopupTrue {
                CustomPopupView(action: {
                    withAnimation(.easeInOut){
                        isPopupTrue = false
                    }
                })
                .transition(.opacity)  // Optional transition for popup
                       }
        }
        .onAppear{
            if UserDefaults.standard.loginUser != nil {
                withAnimation(.easeInOut){
                    isPopupTrue = true
                }
                name = UserDefaults.standard.loginUser?.name ?? ""
                email = UserDefaults.standard.loginUser?.email ?? ""
                gender = UserDefaults.standard.loginUser?.gender ?? ""
                password = UserDefaults.standard.loginUser?.password ?? ""
            }
            else {
                FireBaseAuthService.shared.logoutUser {
                    viewModel.isShowingDashboardView = false
                    UserDefaults.isLoggedIn = false
                    viewModel.allJournalData = []
                    NavigationUtil.popToRootView()
                }
            }
        }
       
        

    }
}


#Preview {
    ProfileView()
}
