//
//
// JournalModal.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 01/01/25
// Copyright © 2025 Differenz System Pvt. Ltd. All rights reserved.
//

import Foundation
struct JournalModal: Codable,Hashable,Identifiable {
    
    var tradeName : String?
    var id = UUID()
    var buyORsell : String?
    var entryQuantity : Int?
    var entryPrice : Double?
    var exitQuantity : Int?
    var exitPrice : Double?
    var totalPAndL : Double?
    var investedAmount : Double?
    var createDate : String?
    var timeStampIdentifier : String?
   
    
    enum CodingKeys: CodingKey {
        case buyORsell, tradeName, entryQuantity, entryPrice, exitQuantity,exitPrice,totalPAndL,createDate , investedAmount , timeStampIdentifier
    }
    
    init(
           tradeName: String? = nil,
           buyORsell: String? = nil,
           entryQuantity: Int? = nil,
           entryPrice: Double? = nil,
           exitQuantity: Int? = nil,
           exitPrice: Double? = nil,
           totalPAndL: Double? = nil,
           investedAmount: Double? = nil,
           createDate: String? = nil ,
           timeStampIdentifier: String? = nil
       ) {
           self.tradeName = tradeName
           self.buyORsell = buyORsell
           self.entryQuantity = entryQuantity
           self.entryPrice = entryPrice
           self.exitQuantity = exitQuantity
           self.exitPrice = exitPrice
           self.totalPAndL = totalPAndL
           self.investedAmount = investedAmount
           self.createDate = createDate
           self.timeStampIdentifier = timeStampIdentifier
       }
    
    init?(dictionary : [String : Any]) {
        self.tradeName = dictionary["tradeName"] as? String ?? ""
        self.buyORsell = dictionary["buyORsell"] as? String ?? ""
        self.entryQuantity = dictionary["entryQuantity"] as? Int ?? nil
        self.entryPrice = dictionary["entryPrice"] as? Double ?? nil
        self.exitQuantity = dictionary["exitQuantity"] as? Int ?? nil
        self.exitPrice = dictionary["exitPrice"] as? Double ?? nil
        self.totalPAndL = dictionary["totalPAndL"] as? Double ?? nil
        self.investedAmount = dictionary["investedAmount"] as? Double ?? nil
        self.createDate = dictionary["createDate"] as? String ?? ""
        self.timeStampIdentifier = dictionary["timeStampIdentifier"] as? String ?? ""
        
    }
}

/** Converts model into dictionary **/
extension JournalModal {
    static func getUserJournalInput(
        tradeName : String? = nil,
        buyORsell : String? = nil,
        entryQuantity : Int? = nil,
        entryPrice : Double? = nil,
        exitQuantity : Int? = nil,
        exitPrice : Double? = nil,
        totalPAndL : Double? = nil,
        investedAmount : Double? = nil,
        createdDate : String? = nil,
        timeStampIdentifier : String? = nil
    ) -> [String:Any] {
        var dict: [String:Any] = [:]
        dict["tradeName"] = tradeName ?? ""
        dict["buyORsell"] = buyORsell ?? ""
        dict["entryQuantity"] = entryQuantity ?? ""
        dict["entryPrice"] = entryPrice ?? ""
        dict["exitQuantity"] = exitQuantity ?? ""
        dict["exitPrice"] = exitPrice ?? ""
        dict["totalPAndL"] = totalPAndL ?? ""
        dict["investedAmount"] = investedAmount ?? ""
        dict["createDate"] = createdDate ?? ""
        dict["timeStampIdentifier"] = timeStampIdentifier ?? ""
        return dict
    }
}




