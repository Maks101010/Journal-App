//
//
// TradeListView.swift
// SampleFirebaseApp
//
// Created by Shubh Magdani on 15/01/25
// Copyright © 2025 Differenz System Pvt. Ltd. All rights reserved.
//

import Foundation
import SwiftUI

struct TradeListView: View {
    @StateObject var viewModel: FireBaseAppModel = .shared
    @State var selectedJournal: JournalModal = JournalModal()
    @State var recordToDelete: JournalModal = JournalModal()
    @State var isTradeDetailsOpen: Bool = false
    @State var isAlertShown: Bool = false
    @State var isLongPress: UUID? = nil
    @State var AlertMessage: String = ""
    @State private var searchQuery: String = "" // State variable for search query
    @State private var sortOrder: SortOrder = .Latest // State variable for sorting order
    
    @Environment(\.dismiss) var dismiss
    
    enum SortOrder {
        case Profit, Loss , Latest , Oldest
    }
    
    var filteredTrades: [JournalModal] {
        if searchQuery.isEmpty {
            switch sortOrder {
            case .Profit:
                return  viewModel.allJournalData .filter{($0.totalPAndL ?? 0) > 0 }.sorted { ($0.totalPAndL ?? 0) > ($1.totalPAndL ?? 0) }
            case .Loss:
                return viewModel.allJournalData.filter{($0.totalPAndL ?? 0) < 0 }.sorted { ($0.totalPAndL ?? 0) < ($1.totalPAndL ?? 0) }
            case .Latest:
                return viewModel.allJournalData.reversed()
            case .Oldest:
                return viewModel.allJournalData
            }
            
        }
        switch sortOrder {
        case .Profit:
            let searchResult =  viewModel.allJournalData.filter { trade in
                trade.tradeName?.lowercased().contains(searchQuery.lowercased()) ?? false
            }
            return searchResult.filter{($0.totalPAndL ?? 0) > 0 }.sorted{($0.totalPAndL ?? 0) > ($1.totalPAndL ?? 0)}
        case .Loss:
            let searchResult =  viewModel.allJournalData.filter { trade in
                trade.tradeName?.lowercased().contains(searchQuery.lowercased()) ?? false
            }
            return searchResult.filter{($0.totalPAndL ?? 0) < 0 }.sorted{($0.totalPAndL ?? 0) < ($1.totalPAndL ?? 0)}
        case .Latest:
            return  viewModel.allJournalData.filter { trade in
                trade.tradeName?.lowercased().contains(searchQuery.lowercased()) ?? false
            }.reversed()
        case .Oldest:
            return  viewModel.allJournalData.filter { trade in
                trade.tradeName?.lowercased().contains(searchQuery.lowercased()) ?? false
            }
            
        }
        
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                if !filteredTrades.isEmpty {
                    Menu{
                        Button(action: {
                            sortOrder = .Profit
                        }){
                            Text("Profit")
                        }
                        Button(action: {
                            sortOrder = .Loss
                        }){
                            Text("Loss")
                        }
                        Button(action: {
                            sortOrder = .Latest
                        }){
                            Text("Latest")
                        }
                        Button(action: {
                            sortOrder = .Oldest
                        }){
                            Text("Oldest")
                        }
                    } label: {
                        Text("Sort by: \(sortOrder)")
                    }
                }
                
                
                
                
            }
            .padding(.horizontal)
            
            VStack {
                if filteredTrades.isEmpty {
                    Spacer()
                    NoDataFound()
                    Spacer()
                    
                }
                else {
                    List(filteredTrades) { i in
                        mainView(
                            tradeName: i.tradeName ?? "",
                            pAndL: i.totalPAndL ?? 0,
                            invested: i.investedAmount ?? 0,
                            entryQty: i.entryQuantity ?? 0,
                            entryPrice: i.entryPrice ?? 0,
                            exitQty: i.exitQuantity ?? 0,
                            exitPrice: i.exitPrice ?? 0,
                            createdDate: i.createDate ?? ""
                        )
                        .frame(maxWidth: .infinity)
                        .blur(radius: isLongPress == nil ? 0 : isLongPress == i.id ? 0 : 3)
                        .scaleEffect(isLongPress == nil ? 1 : isLongPress == i.id ? 1.02 : 1)
                        .animation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5), value: isLongPress)
                        .onLongPressGesture(minimumDuration: 1, pressing: { isPress in
                            if isPress {
                                isLongPress = i.id
                            }
                            else {
                                isLongPress = nil
                            }
                        }, perform: {
                            selectedJournal = i
                            isTradeDetailsOpen = true
                            isLongPress = nil
                            
                        })
                        .onTapGesture {
                            selectedJournal = i
                            isTradeDetailsOpen = true
                        }
                        .listRowBackground(Color.black)
                        .listRowInsets(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
                        .swipeActions(edge: .trailing) {
                            Button(action: {
                                recordToDelete = i
                                isAlertShown = true
                            }) {
                                Image(systemName: "trash.fill")
                            }
                        }
                        .tint(Color.clear)
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                selectedJournal = i
                                isTradeDetailsOpen = true
                            }) {
                                Image(systemName: "arrowshape.turn.up.forward.fill")
                            }
                        }
                        .tint(Color.clear)
                    }
                }
                

            }
        }
        .searchable(text: $searchQuery) // Add searchable modifier
        .alert(isPresented: $isAlertShown) {
            Alert(title: Text("Are you sure you want to delete record?"), message: Text(""), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {
                FBDataStore.shared.deleteJournalData(for: UserDefaults.standard.loginUser?.uid ?? "", documentTimeStamp: recordToDelete.timeStampIdentifier ?? "", completion: {
                    
                })
            }))
        }
        .sheet(isPresented: $isTradeDetailsOpen) {
            TradeDetailsView(journalData: $selectedJournal,closeAction: {
                isTradeDetailsOpen = false
            })
                .background(.black)
                .presentationDetents([.medium, .large])
        }
        .navigationTitle("All Trades")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(viewModel.themeColor)
                        Text("Back")
                            .foregroundStyle(viewModel.themeColor)
                    }
                }
            }
        }
    }
}

extension TradeListView {
    func mainView (tradeName : String, pAndL : Double, invested : Double,entryQty : Int, entryPrice : Double , exitQty : Int , exitPrice : Double,createdDate:String) -> some View {
        VStack (alignment: .leading){
            HStack {
                VStack(alignment:.leading) {
                    Text(tradeName)
                        .fontWidth(.expanded)
                }
                
                
                Spacer()
                
                Text("\(String(format: "%.2f", Double(pAndL)))")
                    .foregroundStyle(pAndL > 0.0 ? Color.green : pAndL < 0.0 ? Color.red : pAndL == 0.0 ? Color.gray : Color.gray)
            }
            
            HStack (spacing:1){
                Text("Invested:")
                Text("\(String(format: "%.2f", Double(invested)))")
                Spacer()
                Text(createdDate)
            }
            .foregroundStyle(Color.gray)
            .font(.subheadline)
            Divider()
            
            HStack {
                VStack{
                    commonQtyView(priceOrQtyInt: Double(entryQty) , priceOrQtyIntString: "Entry Qty")
                }
                VStack{
                    commonQtyView(priceOrQtyInt: entryPrice, priceOrQtyIntString: "Entry Price")
                }
                VStack{
                    commonQtyView(priceOrQtyInt: Double(exitQty), priceOrQtyIntString: "Exit Qty")
                }
                VStack{
                    commonQtyView(priceOrQtyInt: exitPrice, priceOrQtyIntString: "Exit Price")
                }
            }
          
                    }
        .padding()
        .frame(maxWidth: .infinity)
        .background(viewModel.themeColor.opacity(0.7), in: RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1.5))
    }
}

extension TradeListView {
    func commonQtyView (priceOrQtyInt : Double , priceOrQtyIntString : String) -> some View {
        VStack{
            Text("\(String(format: "%.2f", Double(priceOrQtyInt)))")
            Text(priceOrQtyIntString)
                .foregroundStyle(Color.gray)
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}
