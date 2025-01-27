//
//
// PastRecords.swift
// SampleFirebaseApp
//
// Created by Shubh Magdani on 22/01/25
// Copyright © 2025 Differenz System Pvt. Ltd. All rights reserved.
//


import SwiftUI
import Charts

struct PastRecords: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: FireBaseAppModel = .shared
    @State var searchText : String = ""
    @State var isChartListShown = false
    
    @State var SelectedCompanyModel : [JournalModal] = []
    var groupedData: [String: [JournalModal]] {
        let filteredData: [JournalModal]
        
        if searchText.isEmpty {
            // If searchText is empty, use all data
            filteredData = viewModel.allJournalData
        } else {
            // Filter the data based on the search text
            filteredData = viewModel.allJournalData.filter { journal in
                guard let tradeName = journal.tradeName else { return false }
                return tradeName.lowercased().contains(searchText.lowercased())
            }
        }
        
        // Group the filtered data by tradeName
        return Dictionary(grouping: filteredData, by: { $0.tradeName ?? "" })
    }
    
    var body: some View {
        ScrollView {
            VStack() {
                ForEach(groupedData.keys.sorted(), id: \.self) { tradeName in
                    if let trades = groupedData[tradeName] {
                        let overallInvested = trades.reduce(0) { $0 + ($1.investedAmount ?? 0) }
                        let overallPandL = trades.reduce(0) { $0 + ($1.totalPAndL ?? 0) }
                        let successfulTrades = trades.filter { trade in
                            let pAndL = trade.totalPAndL ?? 0
                            return pAndL > 0
                        }.count
                        let totalTrades = trades.count
                        
                        cardView(
                            companyTrades: trades,
                            tradeName: tradeName,
                            overallInvested: overallInvested,
                            overallPandL: overallPandL,
                            successfulTrades: ( ( Double (successfulTrades) /  Double(totalTrades) ) )
                        )
                        .onTapGesture{
                            SelectedCompanyModel = trades
                            isChartListShown = true
                        }
                    }
                }
            }
            .padding()
        }
        .searchable(text: $searchText, prompt: "Search")
        .navigationTitle("Trade history")
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $isChartListShown) {
            ChartListView(companyData: SelectedCompanyModel)
        }
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



extension PastRecords {
    func cardView(companyTrades : [JournalModal], tradeName: String,overallInvested: Double,overallPandL: Double,successfulTrades: Double) -> some View {
        ZStack (alignment: .center){
            backgroundChartView(CompanyTrades: companyTrades, height: 100,isAxisShown: false)
                .opacity(0.4)
                
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(tradeName)
                        .font(.largeTitle)
                        .fontWidth(.expanded)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .textCase(.uppercase)
                    Spacer()
                    Text("\(overallPandL, specifier: "%.2f")")
                        .foregroundColor(overallPandL >= 0 ? .green : .red)
                        .bold()
                }
                HStack {
                    Spacer()
                    HStack (spacing: 35){
                        CircularProgressView(progress: 1 - successfulTrades  ,color:  Color.red)
                            .frame(width: 20, height: 20, alignment: .center)
                        CircularProgressView(progress: successfulTrades,color:  Color.green )
                            .frame(width: 20, height: 20, alignment: .center)
                    }
                }
                .padding()
                        
                            
                            
    
                
               
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .frame(height: 100)
            .padding()
            .background(viewModel.themeColor.opacity(0.7), in: RoundedRectangle(cornerRadius: 10).stroke())
        }
    }
}


struct backgroundChartView : View {
    var CompanyTrades: [JournalModal]
    var height: CGFloat
    @State private var isAnimated = false
    @State private var select : Int? = nil
    var isAxisShown = true
    var body: some View {
        Chart {
            ForEach(CompanyTrades.enumerated().map { $0 }, id: \.element.id) { index , trade in
                LineMark(
                    x: .value("Trades", index + 1),
                    y: .value("Cumulative P&L", isAnimated ?  trade.totalPAndL ?? 0 : 0 )
                )
//                .interpolationMethod(.catmullRom)
                .foregroundStyle(FireBaseAppModel.shared.themeColor)
                .symbol{
                    Circle()
                        .frame(width: 6,height:6)
                        .foregroundStyle(FireBaseAppModel.shared.themeColor)
                }
            }
        }
        .frame(height: height)
        .padding(.horizontal)
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 12)
        .animation(.easeInOut(duration: 0.5), value: select)
        .chartXAxis(isAxisShown ? .visible : .hidden)
        .chartYAxis(isAxisShown ? .visible : .hidden)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                isAnimated = true
            }
        }

    }
}


#Preview{
    backgroundChartView(CompanyTrades: [
        JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
        JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
        JournalModal(tradeName: "Trade 3", entryQuantity: 15, entryPrice: 100, exitQuantity: 15, exitPrice: 120, totalPAndL: 300, investedAmount: 1500, createDate: "2025-01-03")
    ], height: 50)
}



#Preview {
    PastRecords(
                viewModel: {
                    let mockModel = FireBaseAppModel()
                    mockModel.allJournalData = [
                        JournalModal(tradeName: "SBI", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
                            JournalModal(tradeName: "SBI", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
                        JournalModal(tradeName: "SBI", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 60, totalPAndL: -320, investedAmount: 800, createDate: "2025-01-02"),
                        JournalModal(tradeName: "MARUTI SUZUKI", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 60, totalPAndL: -320, investedAmount: 800, createDate: "2025-01-02"),
                            JournalModal(tradeName: "TATA", entryQuantity: 15, entryPrice: 100, exitQuantity: 15, exitPrice: 120, totalPAndL: 300, investedAmount: 1500, createDate: "2025-01-03"),
                            JournalModal(tradeName: "TATA", entryQuantity: 5, entryPrice: 120, exitQuantity: 5, exitPrice: 130, totalPAndL: 50, investedAmount: 600, createDate: "2025-01-04")
                    ]
                    return mockModel
                }())
}
