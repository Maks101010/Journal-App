//
//
// TradeJournalView.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 01/01/25
// Copyright © 2025 Differenz System Pvt. Ltd. All rights reserved.
//
import SwiftUI
struct TradeJournalView : View {
    @Environment(\.dismiss) var dismiss
    @State var isBuySelected : Bool = true
    @State var enterQunatity : String = ""
    @State var tradeName : String = ""
    @State var entryPrice : String = ""
    @State var exitedPrice : String = ""
    var closeaction: (() -> ())
    var body: some View {
        VStack{
            ScrollView {
                Spacer(minLength: 40)
                VStack(spacing:30) {
                    HStack {
                        if isBuySelected {
                            BtnWithoutBorder(img: "checkmark.circle.fill", label: "Buy", fun: {}, color: .green)
                            BtnWithBorder(img: "checkmark.circle.fill", label: "sell", fun: {withAnimation(){
                                isBuySelected = false
                            } }, color: .red)
                        }
                        else {
                            BtnWithBorder(img: "checkmark.circle.fill", label: "Buy", fun: {
                                withAnimation(){
                                    isBuySelected = true
                                }
                            }, color: .green)
                            BtnWithoutBorder(img: "checkmark.circle.fill", label: "sell", fun: {}, color: .red)
                        }
                    }
                    TextFieldView(placeholder: "Trade Name", text: $tradeName)
                        .textCase(.uppercase)
                    TextFieldView(placeholder: "Entry Quantity", text: $enterQunatity)
                        .keyboardType(.numberPad)
                    TextFieldView(placeholder: "Entry Price", text: $entryPrice)
                        .keyboardType(.numberPad)
                    TextFieldView(placeholder: "Exited Quantity", text: $enterQunatity)
                        .disabled(true)
                    TextFieldView(placeholder: "Exited Price", text: $exitedPrice)
                        .keyboardType(.numberPad)
                    
                    
                    ButtonView(
                        title: "Create Journal",
                        action: {
                            if !entryPrice.isEmpty && !exitedPrice.isEmpty && !enterQunatity.isEmpty && !tradeName.isEmpty {
                                FireBaseAuthService.shared.setJournalData(
                                    with: UserDefaults.standard.loginUser?.uid ?? "",
                                    isBuyOrSell: isBuySelected ? "Buy" : "Sell",
                                    tradeName: tradeName,
                                    entryQunatity: Int( enterQunatity) ?? 0,
                                    entryPrice: Double( entryPrice) ?? 0.0,
                                    exitedPrice: Double( exitedPrice) ?? 0.0
                                )
                                { journalModal in
                                    if journalModal != nil {
                                        closeaction()
                                    }
                                }
                            }
                            else {
                                Alert.show(title: "Required all fields.")
                            }
                    })
                }
                .padding()
                
                
            }
        }
        .navigationTitle("Create Journal")
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement:.topBarLeading) {
                HStack {
                    Button(action: {dismiss() }){
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(FireBaseAppModel.shared.themeColor)
                                Text("Back")
                            .foregroundStyle(FireBaseAppModel.shared.themeColor)
                            }
                }
            }
        }
        .background(Color.black)
    }
}

#Preview {
    TradeJournalView( closeaction: {})
}
