//
//
// LoginView.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 31/12/24
// Copyright © 2024 Differenz System Pvt. Ltd. All rights reserved.
//



import SwiftUI

struct LoginView : View {
    @State var email : String = ""
    @State var password : String = ""
    @State var isSignUp : Bool = false
    @StateObject var viewModel: FireBaseAppModel = .shared
    @State private var showSplash = true
    @State private var isExitingSplash = false
    var body: some View {
        
        if showSplash {
            
                SplashView(isExiting: $isExitingSplash)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                isExitingSplash = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                showSplash = false
                            }
                        }
                    }
            
        }
        else {
            ScrollView {
                VStack (alignment: .leading,spacing: 30){
                    TextFieldView(placeholder: "Email", text: $email)
                    SecureFieldView(placeholder: "Password", text: $password)
                    
                    
                    ButtonView(title: "Sign In", action: {
                        Indicator.show()
                        FireBaseAuthService.shared.signIn(with: email, and: password){userModel in
                        
                            
                            if userModel != nil {
                                viewModel.isShowingDashboardView = true
                            }
                            else {
                                Alert.show(title: "Login Failed !!!!!")
                            }
                        }
                    })
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .underline(true,color: Color.white)
                            .foregroundStyle(Color.white)
                            .onTapGesture {
                                isSignUp = true
                            }
                        Spacer()
                    }.foregroundStyle(Color.gray)
                    
                    
                }
                .padding()
            }
            
            .onAppear{
                if UserDefaults.isLoggedIn {
                    viewModel.isShowingDashboardView = true
                }
#if DEBUG
                self.email = "test@gmail.com"
                self.password = "12345678"
#endif
            }
            .navigationTitle( Text("Sign In"))
            
            .navigationDestination(isPresented: $isSignUp, destination: {
                RegistrationView()
            })
            .navigationDestination(isPresented: $viewModel.isShowingDashboardView){
                DashboadView()
            }
        }
        
        
        
       
    }
}



#Preview {
    LoginView()
}
