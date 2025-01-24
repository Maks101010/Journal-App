//
//
// TradeDetailsView.swift
// SampleFirebaseApp
//
// Created by Shubh Magdani on 03/01/25
// Copyright © 2025 Differenz System Pvt. Ltd. All rights reserved.
//



import SwiftUI
import Charts


struct TradeDetailsView: View {
    @Binding var journalData: JournalModal
    @Environment(\.dismiss) var dismiss
    @State private var isAnimated = false
    @State private var isPAndL = false
    @State private var isAnimatedPAndL = false
    @State private var isIntAmount = false
    @State private var isAnimatedIntAmount = false
    @State private var selectedInt : Int?
    @State  var closeAction : (()->())
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    CommonText(title: journalData.tradeName ?? "")
                    .bold()
                    .fontWidth(.expanded)
                    .font(.largeTitle)
                    Spacer()
                    Button(action:{
                        closeAction()
                    }){
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.white)
                    }
                    
                }
              
                HStack {
                    Circle().fill(journalData.totalPAndL ?? 0 > 0 ? Color.green.opacity(0.5) : Color.red.opacity(0.5)).frame(width: 10, height: 10)
                    Text("Invested Amount : \(String(format: "%.2f", Double(journalData.investedAmount ?? 0)))").font(.caption)
                    Spacer()
                    Circle().fill(journalData.totalPAndL ?? 0 > 0 ? Color.green : Color.red).frame(width: 10, height: 10)
                    Text("Total P&L : \(String(format: "%.2f", Double(journalData.totalPAndL ?? 0)))").font(.caption)
                }
                .padding(.horizontal)
                
                // Chart
                Chart([journalData]) { journal in
                    
                    if journal.totalPAndL ?? 0 < 0 {
                        let totalAmount = (journal.investedAmount ?? 0) + abs(journal.totalPAndL ??  0)
                        
                        
                        SectorMark(
                            angle: .value("Total P&L", isAnimated ? ( abs(journal.totalPAndL ??  0)) : 0),
                            innerRadius: .ratio(0.7),
                            outerRadius: isAnimatedPAndL ? 150 : 120,
                            angularInset: 8
                        )
                        .foregroundStyle(isPAndL ? .red : .red.opacity(0.5))
                        .cornerRadius(10)
                        
                        SectorMark(
                            angle: .value(" Invested Amount", isAnimated ? (totalAmount) : 0),
                            innerRadius: .ratio(0.7),
                            outerRadius: isAnimatedIntAmount ? 150 : 120,
                            angularInset: 8
                        )
                        .foregroundStyle(isIntAmount ? .red : .red.opacity(0.5))
                        .cornerRadius(10)
                    }
                else {
                    SectorMark(
                        angle: .value("Invested Amount", isAnimated ? (journal.investedAmount ?? 0) : 0),
                        innerRadius: .ratio(0.7),
                        outerRadius: isAnimatedIntAmount ? 150 : 120,
                        angularInset: 8
                    )
                    .foregroundStyle(isIntAmount ?  .green : .green.opacity(0.5))
                    .cornerRadius(10)
                    
                    
                    // Total P&L
                    SectorMark(
                        angle: .value("Total P&L", isAnimated ? (journal.totalPAndL ?? 0) : 0),
                        innerRadius: .ratio(0.7),
                        outerRadius: isAnimatedPAndL ? 150 : 120,
                        angularInset: 8
                    )
                    .foregroundStyle(isPAndL ? .green : .green.opacity(0.5))
                    .cornerRadius(10)
                }
                   
                    // Invested Amount
                    
                    
                }
                .chartAngleSelection(value: $selectedInt)
                .frame(width: 300,height: 300)
                .animation(.easeOut(duration: 1), value: isAnimated)
                .onChange(of: selectedInt) { _ , newValue in
                    if let newValue: Int = newValue  {
                        
                        if (journalData.totalPAndL ?? 0) > 0 {
                            if newValue > Int(journalData.investedAmount ?? 0) {
                                isIntAmount = false
                                isPAndL = true
                                DispatchQueue.main.async{
                                withAnimation {
                                        isAnimatedIntAmount = false
                                        isAnimatedPAndL = true
                                    }
                                   
                                }
                            } else {
                                isIntAmount = true
                                isPAndL = false
                                DispatchQueue.main.async{
                                    withAnimation{
                                        isAnimatedIntAmount = true
                                        isAnimatedPAndL = false
                                    }
                                }
                                
                            }
                        } else {
                            isIntAmount = true
                            isPAndL = false
                            if newValue > abs(Int(journalData.totalPAndL ?? 0)) {
                                DispatchQueue.main.async{
                                    withAnimation{
                                        isAnimatedIntAmount = true
                                        isAnimatedPAndL = false
                                    }
                                }
                                
                            }
                            else {
                                isIntAmount = false
                                isPAndL = true
                                DispatchQueue.main.async(){
                                    withAnimation(){
                                        isAnimatedIntAmount = false
                                        isAnimatedPAndL = true
                                    }
                                }
                               
                               
                            }
                        }
                    }
                }
                
                .chartBackground { chartProxy in
                                  GeometryReader { geometry in
                                    if let anchor = chartProxy.plotFrame {
                                      let frame = geometry[anchor]
                                        Text(isAnimatedPAndL ? "Total P&L : \n \(String(format: "%.2f", Double(journalData.totalPAndL ?? 0)))" : isAnimatedIntAmount ? "Invested Amount : \n \(String(format: "%.2f", Double(journalData.investedAmount ?? 0)))" : "")
                                            .foregroundStyle((journalData.totalPAndL ?? 0) > 0 ? Color.green : Color.red)
                                        .position(x: frame.midX, y: frame.midY)
                                    }
                                  }
                                }
                
                
                
                // Additional Text or Elements
                Text("Trade Summary")
                    .font(.headline)
                    .padding(.top)
                
                Spacer()
                VStack {
                    HStack {
                        VStack{
                            CommonText(title: "Profit & Loss:")
                                .bold()
                            CommonText(title: "₹\(String(format: "%.2f", Double(journalData.totalPAndL ?? 0)))",foregroundColor: journalData.totalPAndL ?? 0 > 0 ? Color.green : Color.red)
                            Spacer()
                            CommonText(title: "Entry Quantity:")
                                .bold()
                            CommonText(title: "\(journalData.entryQuantity ?? 0)")
                            Spacer()
                            CommonText(title: "Entry Price:")
                                .bold()
                            CommonText(title: "₹\(String(format:"%.2f",Double(journalData.entryPrice ?? 0)))")
                            
                            
                        }
                        CustomDivider(color: (journalData.totalPAndL ?? 0) > 0 ? Color.green.opacity(0.7) : Color.red.opacity(0.7), thickness: 1.0,direction: .vertical)
                        VStack{
                            CommonText(title: "InvestedAmount:")
                                .bold()
                            CommonText(title: "₹\(String(format:"%.2f", Double(journalData.investedAmount ?? 0)))")
                            Spacer()
                            CommonText(title: "Exit Quantity:")
                                .bold()
                            CommonText(title: "\(journalData.exitQuantity ?? 0)")
                            Spacer()
                            CommonText(title: "Exit Price:")
                                .bold()
                            CommonText(title: "₹\(String(format:"%.2f", Double(journalData.exitPrice ?? 0)) ) ")
                        }
                    }
                    Divider()
                    CommonText(title: "Created Date:")
                        .bold()
                    CommonText(title: journalData.createDate ?? "")
                    
                }
                .padding()
                .background((journalData.totalPAndL ?? 0) > 0 ?  Color.green.opacity(0.5) : Color.red.opacity(0.5), in: RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2.5))
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .onAppear {
            withAnimation {
                isAnimated = true
            }
        }
        
    }
}
    #Preview {
        TradeDetailsView(journalData: .constant(JournalModal()),closeAction: {})
    }
    
    
    
    struct Product: Identifiable {
        let id = UUID()
        let title: String
        let revenue: Double
    }
    
    struct SectorChartExample: View {
        @State private var products: [Product] = [
            .init(title: "Annual", revenue: 0.7),
            .init(title: "Monthly", revenue: 0.2),
            .init(title: "Lifetime", revenue: 0.1)
        ]
        
        var body: some View {
            Chart(products) { product in
                SectorMark(
                    angle: .value(
                        Text(verbatim: product.title),
                        product.revenue
                    ),
                    innerRadius: .ratio(0.6),
                    angularInset: 8
                )
                .foregroundStyle(
                    by: .value(
                        Text(verbatim: product.title),
                        product.title
                    )
                )
            }
        }
    }
    



