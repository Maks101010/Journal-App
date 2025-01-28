//
//
// ChartListView.swift
// SampleFirebaseApp
//
// Created by Shubh Magdani on 23/01/25
// Copyright © 2025 Differenz System Pvt. Ltd. All rights reserved.
//


import SwiftUI
import Charts
struct ChartListView : View {
    @Environment(\.dismiss) var dismiss
    @State var select : Int? = nil
    @State var scrollIndex : Int = 1
    var companyData : [JournalModal]
    var companyData2: [JournalModal] {
           if let select = select {
               // Filter for the matching trade
               if select < 1 {
                   return companyData
               }
               else if select > companyData.count {
                   return companyData
               }
               else {
                   return companyData.filter { $0.id == companyData[select - 1].id }
               }
               
           } else {
               // Return the original company data if no selection is made
               return companyData
           }
       }
    var body: some View {
        VStack {
            
//            ScrollView {
                VStack {
                    if companyData.isEmpty {
                        NoDataFound()
                    }
                    else {
                        Spacer()
                        List {
                            ChartViewWithSelectionHandled(journalData: companyData, height: 300, scrollValue: $scrollIndex, select: $select)
                            ForEach(companyData2.enumerated().map { $0 }, id: \.element.id) { index, i in
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
                                .onTapGesture {
                                    if select == nil {
                                        select = index + 1
                                        withAnimation(){
                                            scrollIndex = index - 1
                                        }
                                    }
                                    else {
                                        select = nil
                                    }
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .listRowBackground(Color.black)
                                .listRowInsets(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
                            }
                        }
                        .animation(.default, value: companyData2)
                        
                    }
                }
//            }
        }
        .navigationTitle("Trade history")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(FireBaseAppModel.shared.themeColor)
                        Text("Back")
                            .foregroundStyle(FireBaseAppModel.shared.themeColor)
                    }
                }
            }
        }
    }
}



extension ChartListView {
    func mainView (tradeName : String, pAndL : Double, invested : Double,entryQty : Int, entryPrice : Double , exitQty : Int , exitPrice : Double,createdDate:String) -> some View {
        VStack (alignment: .leading){
            HStack {
                VStack(alignment:.leading) {
                    Text(createdDate)
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
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(FireBaseAppModel.shared.themeColor.opacity(0.7), in: RoundedRectangle(cornerRadius: 10).stroke())
        
    }
}


extension ChartListView {
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


struct ChartViewWithSelectionHandled: View {
    var journalData: [JournalModal]
    var height: CGFloat
    var isAxisShown = true
    @State private var isAnimated = false
    @Binding  var scrollValue : Int
    @Binding  var select : Int?
    
    var body: some View {
        Chart {
            ForEach(journalData.enumerated().map { $0 }, id: \.element.id) { index, trade in
                BarMark(
                    x: .value("Trades", index + 1),
                    y: .value("Cumulative P&L", isAnimated ? trade.totalPAndL ?? 0 : 0),
                    width : 20
                    
                )
                
                .foregroundStyle(trade.totalPAndL ?? 0 < 0 ? Color.red : Color.green)
                .opacity(select == nil ? 1 : select == (index + 1) ? 1 : 0.2)
                .annotation(position: (trade.totalPAndL ?? 0) > 0 ?  .top  : .bottom  , overflowResolution: .init(x : .fit , y : .padScale)) {
                    if select == index + 1 {
                    VStack {
                        HStack {
                            VStack {
                                Text("Total P&L:")
                                    .bold()
                                if let selectData = select {
                                    Text("\(String(format: "%.2f", journalData[selectData - 1].totalPAndL ?? 0))")
                                }
                            }
                        }
                        
                        
                        
                    }
                    .font(.caption)
                    .padding()
                    .foregroundStyle(Color.white)
                    .frame(maxWidth:.infinity)
                    .background( RoundedRectangle(cornerRadius: 10).fill((trade.totalPAndL ?? 0) > 0 ? Color.green : Color.red))
                    .animation(.default, value: scrollValue)
                }
                }
               
                
            }
        }
        .frame(height: height)
        .animation(.default, value: select)
        .chartXVisibleDomain(length: 12)
        .chartXSelection(value: $select)
        .chartScrollTargetBehavior(.valueAligned(unit: 1))
        .chartXAxis(isAxisShown ? .visible : .hidden)
        .chartYAxis(isAxisShown ? .visible : .hidden)
        .chartScrollPosition(x: $scrollValue)
        .chartScrollableAxes(.horizontal)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                isAnimated = true
            }
        }
        
        .onChange(of: scrollValue){ o , n in
            print("The n = \(n) and o : = \(0)")
        }
    }
}


#Preview{
    ChartListView(companyData: [
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 3", entryQuantity: 15, entryPrice: 100, exitQuantity: 15, exitPrice: 120, totalPAndL: 300, investedAmount: 1500, createDate: "2025-01-03")
        
    ])
}
