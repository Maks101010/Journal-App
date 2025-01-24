//
//
// DashboadView.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 01/01/25
// Copyright © 2025 Differenz System Pvt. Ltd. All rights reserved.
//

import SwiftUI
import Charts
struct DashboadView: View {
    @StateObject var viewModel: FireBaseAppModel = .shared
    @State var isTradeJournelOpen : Bool = false
    @State var selectedJournal : JournalModal = JournalModal()
    @State var isTradeDetailsOpen : Bool = false
    @State var isTradeChartShown : Bool = false
    @State var isProfileShown : Bool = false
    @State var isAllTradesClick : Bool = false
    @State var isMenuOpen : Bool = false
    @State var isAlertShown : Bool = false
    @State var selectedColor : Color = FireBaseAppModel.shared.themeColor
    @State var isLongPress: UUID? = nil
    @State var isColorPicker: Bool = false
    @State var isPastRecordsOpen : Bool = false
    @State var isLongPressButton : String = ""
    var body: some View {
        VStack {
            ZStack (alignment: .bottom){
                ScrollView {

                if viewModel.allJournalData.isEmpty {
                    VStack {
                        Text("No data is there")
                    }
                    .frame(maxWidth: .infinity)
                    
                }
                else {
                    VStack {
                        
                        mainCardView(journalData: viewModel.allJournalData, action: {isTradeChartShown = true}, successfullTrades: totalSuccessTrades(), totalPAndL: totalPAndL())
                            
                        Spacer(minLength: 100)
                        HStack {
                            CommonText(title: "Top Trades")
                                .bold()
                            Spacer()
                            CommonText(title: "View all",foregroundColor: Color.gray)
                                .underline()
                                .bold()
                                .onTapGesture {
                                    isAllTradesClick = true
                                }
                        }
                        
                        
                        ForEach(viewModel.allJournalData.reversed()
                                    .prefix(5), id: \.id) { i in  // Get only the top 3 items
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
                            .blur(radius: isLongPress == nil ? 0 : isLongPress == i.id ? 0 : 3)
                            .scaleEffect(isLongPress == nil ? 1 : isLongPress == i.id ? 1.05 : 1.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5), value: isLongPress) // Spring animation
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
//                            .disabled(isMenuOpen)
                        }
                    }
                    .disabled(isMenuOpen)
                    .padding()
                    .blur(radius: isMenuOpen ? 10 : 0)
                }
            }
                .scrollDisabled(isMenuOpen)
                VStack {
                    if isLongPressButton != "" {
                        ComplexShapeView(
                            text: isLongPressButton == "List" ? "History" : isLongPressButton == "Entry" ? "New Entry" : isLongPressButton == "Profile" ? "Profile" : isLongPressButton == "Trades" ? "All Trades" : "",
                            offsetX: isLongPressButton == "List" ?  -85.0 : isLongPressButton == "Entry" ?  -35 : isLongPressButton == "Profile" ? 25 : isLongPressButton == "Trades" ? 85 : 0
                        )
                            .padding(.bottom)
                    }
                    
                    
                    HStack {
                        commonImageButtonView(ImageName: "list.clipboard",
                                              color : viewModel.allJournalData.isEmpty ? Color.gray : isMenuOpen ? viewModel.themeColor : viewModel.themeColor.opacity(0.5) ,
                                              offsetX: !isMenuOpen ? 90 : 0,
                                              offsetY: !isMenuOpen ?  60 : 0,
                                              opacity: isMenuOpen ? 1 : 0,
                                              scale:  isMenuOpen ? isLongPressButton == "List" ? 1.1 : 0.8 : 1,
                                              width: 40,
                                              tapAction: {
                                                    withAnimation(){
                                                        isMenuOpen = false
                                                    }
                                                    isLongPressButton = ""
                                                    isPastRecordsOpen = true
                                                    },
                                              pressing: {
                                                    isLongPressButton = "List"
                                                    },
                                              elsepressing: {
                                                    isLongPressButton = ""
                                                    },
                                              perform: {
                                                    withAnimation(){
                                                        isMenuOpen = false
                                                    }
                                                    isLongPressButton = ""
                                                    isPastRecordsOpen = true
                                                }
                                              
                        )
                        .disabled(viewModel.allJournalData.isEmpty)
                        commonImageButtonView(ImageName: "plus.circle.dashed",
                                              color :  isMenuOpen ? viewModel.themeColor : viewModel.themeColor.opacity(0.5) ,
                                              offsetX: !isMenuOpen ? 25 : 0,
                                              offsetY: !isMenuOpen ?  60 : 0,
                                              opacity: isMenuOpen ? 1 : 0,
                                              scale:  isMenuOpen ? isLongPressButton == "Entry" ? 1.1 : 0.8 : 1,
                                              tapAction: {
                                                    withAnimation(){
                                                        isMenuOpen = false
                                                    }
                                                    isLongPressButton = ""
                                                    isTradeJournelOpen = true
                                                    },
                                              pressing: {
                                                    isLongPressButton = "Entry"
                                                    },
                                              elsepressing: {
                                                    isLongPressButton = ""
                                                    },
                                              perform: {
                                                    withAnimation(){
                                                        isMenuOpen = false
                                                    }
                                                    isLongPressButton = ""
                                                    isTradeJournelOpen = true
                                                        }
                        )
                        
                        
                        commonImageButtonView(ImageName: "person.circle",
                                              color :  isMenuOpen ? viewModel.themeColor : viewModel.themeColor.opacity(0.5) ,
                                              offsetX: !isMenuOpen ? -25 : 0,
                                              offsetY: !isMenuOpen ?  60 : 0,
                                              opacity: isMenuOpen ? 1 : 0,
                                              scale:  isMenuOpen ? isLongPressButton == "Profile" ? 1.1 : 0.8 : 1,
                                              tapAction: {
                                                    withAnimation(){
                                                        isMenuOpen = false
                                                    }
                                                    isLongPressButton = ""
                                                    isProfileShown = true
                                                    },
                                              pressing: {
                                                    isLongPressButton = "Profile"
                                                    },
                                              elsepressing: {
                                                    isLongPressButton = ""
                                                    },
                                              perform: {
                                                    withAnimation(){
                                                        isMenuOpen = false
                                                    }
                                                    isLongPressButton = ""
                                                    isProfileShown = true
                                                }
                        )
                        
                        commonImageButtonView(ImageName: "folder.circle",
                                              color : viewModel.allJournalData.isEmpty ? Color.gray : isMenuOpen ? viewModel.themeColor : viewModel.themeColor.opacity(0.5) ,
                                              offsetX: !isMenuOpen ? -90 : 0,
                                              offsetY: !isMenuOpen ?  60 : 0,
                                              opacity: isMenuOpen ? 1 : 0,
                                              scale:  isMenuOpen ? isLongPressButton == "Trades" ? 1.1 : 0.8 : 1,
                                              tapAction: {
                                                    withAnimation(){
                                                        isMenuOpen = false
                                                    }
                                                    isLongPressButton = ""
                                                    isAllTradesClick = true
                                                    },
                                              pressing: {
                                                    isLongPressButton = "Trades"
                                                    },
                                              elsepressing: {
                                                    isLongPressButton = ""
                                                    },
                                              perform: {
                                                    withAnimation(){
                                                        isMenuOpen = false
                                                    }
                                                    isLongPressButton = ""
                                                    isAllTradesClick = true
                                                }
                        )
                        .disabled(viewModel.allJournalData.isEmpty)
                        
                    }
                    .frame(maxWidth:.infinity)
                   
                    commonImageButtonView(ImageName: "plus.circle", color : !isMenuOpen ? viewModel.themeColor : Color.gray , scale: isMenuOpen ? 0.6 : 1.2, degress: isMenuOpen ? 135 : 0 , tapAction: {
                        withAnimation(.bouncy(duration: 0.5,extraBounce: 0.2).delay(0.1)){
                            isMenuOpen.toggle()
                        }
                    })
                       



                    
                }
                .animation(.default, value: isLongPressButton)
               
        }
        }
       
        
        .navigationTitle(Text("Hi , \(UserDefaults.standard.loginUser?.name ?? "User")"))
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    isAlertShown = true
                }){
                    Image(systemName: "iphone.and.arrow.forward.outward")
                        .rotationEffect(Angle(degrees: 180))
                        .foregroundStyle(viewModel.themeColor)
                }
            }
            
            ToolbarItem(placement: .topBarLeading){
                Button(action: {
                    isProfileShown = true
                }){
                    Image(systemName: "person.circle")
                    .foregroundStyle(Color.white)
                }
            }
            ToolbarItem(placement: .topBarLeading){
                Button(action: {
                    isColorPicker = true
                }){
                    Image(systemName: "pencil.and.scribble")
                    .foregroundStyle(Color.white)
                }
            }

            
            
        }
        .onAppear{
            Indicator.show()
            if viewModel.allJournalData.isEmpty {
                
                Task(priority: .background) {
                    FBDataStore.shared.getAllJournalDocuments(for: UserDefaults.standard.loginUser?.uid ?? ""){ journalModal in
                        viewModel.allJournalData = journalModal ?? []
                    }
                }
            }
            else {
                print("Data is there")
                Indicator.hide()
            }
            
            
            
           print(" \(selectedColor)")
            
//            FireBaseAuthService.shared.generateRandomizedJournalData(userId: UserDefaults.standard.loginUser?.uid ?? "", numberOfEntries: 100)
            
            
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $isTradeJournelOpen) {
            TradeJournalView(closeaction: {
                isTradeJournelOpen = false
            })
        }
        .navigationDestination(isPresented: $isProfileShown) {
            ProfileView()
        }
        .navigationDestination(isPresented: $isAllTradesClick){
            TradeListView()
        }
        .navigationDestination(isPresented: $isPastRecordsOpen){
            PastRecords()
        }
        
        .sheet(isPresented: $isColorPicker){
            VStack {
                HStack {
                    Spacer()
                    Text("Theme Picker")
                        .font(.largeTitle)
                        .fontWidth(.expanded)
                    Spacer()
                    Button(action:{
                        isColorPicker = false
                    }){
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.white)
                    }
                }
                Spacer()
                customColorPicker(selectedColor: $selectedColor)
            }
            .padding()
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $isTradeChartShown){
            ScrollView {
                Spacer(minLength: 30)
                VStack {
                    HStack {
                        Spacer()
                        Button(action:{
                            isTradeChartShown = false
                        }){
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.white)
                        }
                    }
                    CommonText(title: "Overall Details")
                        .font(.largeTitle)
                        .fontWidth(.expanded)
                        .bold()
                    Spacer(minLength: 40)
                    MainChartView(journalData: viewModel.allJournalData, height: 400)
                    Spacer(minLength: 30)
                    HStack {
                        VStack {
                            Text("All Successfull Trades:")
                            Spacer(minLength: 30)
                            CircularProgressView(progress: totalSuccessTrades())
                                .frame(height: 50)
                        }
                        
                        CustomDivider(color: .white, thickness: 1, direction: .vertical)
                        VStack {
                            Text("Trades not in fever :")
                            Spacer(minLength: 30)
                            CircularProgressView(progress: 1 - totalSuccessTrades() , color: .red)
                                .frame(height: 50)
                        }
                    }
                }
                .padding()
                
            }
            .background(.black)
            .presentationDragIndicator(.visible)
            .presentationDetents([.medium,.large])
        }
        .sheet(isPresented: $isTradeDetailsOpen) {
            TradeDetailsView(journalData: $selectedJournal,closeAction: {
                isTradeDetailsOpen = false
            })
                .background(.black)
                .presentationDetents([.medium, .large])
        }
        
        .alert(isPresented: $isAlertShown) {
            Alert(title: Text("Are you sure you want to Logout?") , message: Text("") , primaryButton: .cancel(), secondaryButton: .destructive( Text("Logout"), action: {
                FireBaseAuthService.shared.logoutUser() {
                    viewModel.allJournalData = []
                    UserDefaults.isLoggedIn = false
                    viewModel.isShowingDashboardView = false
                }
            }))
        }
        .onAppear {
            
        }
        
    }
}


    struct DashboardView_Previews: PreviewProvider {
        static var previews: some View {
//            
//            MainChartView(journalData: [
//                JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
//                JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
//                JournalModal(tradeName: "Trade 3", entryQuantity: 15, entryPrice: 100, exitQuantity: 15, exitPrice: 120, totalPAndL: 300, investedAmount: 1500, createDate: "2025-01-03")
//            ], height: 400)
            
            
            
            
            DashboadView(viewModel: {
                let mockModel = FireBaseAppModel()
                mockModel.allJournalData = [
                    JournalModal(tradeName: "Trade 1", entryQuantity: 10, entryPrice: 50, exitQuantity: 10, exitPrice: 100, totalPAndL: 500, investedAmount: 1000, createDate: "2025-01-01"),
                    JournalModal(tradeName: "Trade 2", entryQuantity: 8, entryPrice: 100, exitQuantity: 8, exitPrice: 75, totalPAndL: -200, investedAmount: 800, createDate: "2025-01-02"),
                    JournalModal(tradeName: "Trade 3", entryQuantity: 15, entryPrice: 100, exitQuantity: 15, exitPrice: 120, totalPAndL: 300, investedAmount: 1500, createDate: "2025-01-03")
                ]
                return mockModel
            }())
        }
    }
    




extension DashboadView {
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
extension DashboadView {
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
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(viewModel.themeColor.opacity(0.7), in: RoundedRectangle(cornerRadius: 10).stroke())
        
    }
}






struct MainChartView: View {
    var journalData: [JournalModal]
    var height: CGFloat
    var isAxisShown = true
    @State private var isAnimated = false
    @State private var select : Int? = nil
    
    var body: some View {
        Chart {
            ForEach(journalData.enumerated().map { $0 }, id: \.element.id) { index, trade in
                BarMark(
                    x: .value("Trades", index + 1),
                    y: .value("Cumulative P&L", isAnimated ? trade.totalPAndL ?? 0 : 0),
                    width:20
                    
                )
                
                .foregroundStyle(trade.totalPAndL ?? 0 < 0 ? Color.red : Color.green)
                .opacity(select == nil ? 1 : select == (index + 1) ? 1 : 0.2)
                .annotation(position:  (trade.totalPAndL ?? 0) > 0 ? .top : .bottom  , overflowResolution: .init(x : .fit , y : .padScale)) {
                    if select == index + 1 {
                    VStack {
                        HStack {
                            VStack {
                                Text("Trade Name:")
                                    .bold()
                                if let selectData = select {
                                    Text("\(journalData[selectData - 1].tradeName ?? "")")
                                }
                            }
                            CustomDivider(color: .white, thickness: 1, direction: .vertical)
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
                }
                }
               
                
            }
        }
        .frame(height: height)
        .animation(.easeInOut(duration: 0.5), value: select)
        .chartXVisibleDomain(length: 12)
        .chartXSelection(value: $select)
        .chartXAxis(isAxisShown ? .visible : .hidden)
        .chartYAxis(isAxisShown ? .visible : .hidden)
        .chartScrollableAxes(.horizontal)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                isAnimated = true
            }
        }
    }
}

struct mainCardView:View {
    var journalData : [JournalModal]
    var action : () -> ()
    var successfullTrades : Double
    var totalPAndL : Double
    var body: some View {
        ZStack(alignment: .top) {
            MainChartView(journalData: journalData,height: 180, isAxisShown: false)
                .opacity(0.4)
                .padding()
                .disabled(true)
            
            VStack (spacing: 10){
                HStack{
                    CommonText(title: UserDefaults.standard.loginUser?.name ?? "")
                        .bold()
                    Spacer()
                    CommonText(title: "\(String(format: "%.2f", totalPAndL))",foregroundColor: totalPAndL > 0 ? Color.green : Color.red)
                        .bold()
                    
                    
                }
                Spacer()
                HStack {
                    Spacer()
                    HStack (spacing: 35){
                        CircularProgressView(progress: 1 - successfullTrades  ,color:  Color.red)
                            .frame(width: 20, height: 20, alignment: .center)
                        CircularProgressView(progress: successfullTrades,color:  Color.green )
                            .frame(width: 20, height: 20, alignment: .center)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                
                
               
                
                
            }
            .padding()
            .frame(height: 200)
            .background(totalPAndL > 0 ?  Color.green.opacity(0.7) : Color.red.opacity(0.7) , in: RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 3))

        }
        .onTapGesture {
            action()
        }
    }
}







extension DashboadView {
    func totalPAndL() -> Double {
        var cumulativeTotal: Double = 0.0
        for element in viewModel.allJournalData {
            cumulativeTotal += element.totalPAndL ?? 0.0
        }
        return cumulativeTotal
    }
}

extension DashboadView {
    func totalSuccessTrades() -> Double {
        var cumulativeTotal: Double = 0.0
        for element in viewModel.allJournalData {
            if (element.totalPAndL ?? 0) > 0 {
                cumulativeTotal += 1
            }
            
        }
        
        var percentage : Double = 0.0
        percentage = (cumulativeTotal / Double(viewModel.allJournalData.count) )
        
        return percentage
    }
}
