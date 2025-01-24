//
//
// RegistrationView.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 31/12/24
// Copyright © 2024 Differenz System Pvt. Ltd. All rights reserved.
//



import SwiftUI

struct RegistrationView : View {
    @StateObject var viewModel: FireBaseAppModel = .shared
    @Environment(\.dismiss) var dismiss
    @State var email : String = ""
    @State var password : String = ""
    @State var confirmPassword : String = ""
    @State var gender : String = ""
    @State var name : String = ""
    var body: some View {
        ScrollView {
            VStack (alignment: .leading,spacing: 30){

                TextFieldView(placeholder: "Name", text: $name)
                TextFieldView(placeholder: "Email", text: $email)
                GenderPicker(placeholder: "Gender", text: $gender)
                SecureFieldView(placeholder: "Password", text: $password)
                SecureFieldView(placeholder: "Confirm Password", text: $confirmPassword)
                
                
                ButtonView(title: "Sign Up", action: {
                    Indicator.show()
                    FireBaseAuthService.shared.signUp(name: name, gender: gender, email: email, password: password){userModel in
                        
                        if userModel != nil {
                            UserDefaults.isLoggedIn = true
                            FireBaseAppModel.shared.isShowingDashboardView = true
                        }
                        else {
                            Alert.show(title: "Registration failed")
                        }
                        
                    }
                })
                Spacer()
                HStack {
                    Spacer()
                    Text("Already have An Account?")
                    Text("Sign In")
                        .underline(true,color: Color.white)
                        .foregroundStyle(Color.white)
                        .onTapGesture {
                            dismiss()
                        }
                    Spacer()
                }.foregroundStyle(Color.gray)
                
            }
            .padding()
        }
        .onAppear{
            #if DEBUG
            name = "Test"
            email = "test@gmail.com"
            gender = "Male"
            password = "12345678"
            confirmPassword = "12345678"
            #endif
        }
        .navigationTitle( Text("Sign Up"))
        .navigationDestination(isPresented: $viewModel.isShowingDashboardView){
            DashboadView()
        }
    }
}



#Preview {
    RegistrationView()
}
