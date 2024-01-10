//
//  Item.swift
//  KursyWaluitNBP
//
//  Created by Jacek Kosinski U on 10/01/2024.
//

import Foundation
import SwiftData


struct NbpATable: Decodable {
    var table: String
    var no: String
    var effectiveDate: String
    var rates: [CurrencyARate]

    enum CodingKeys: String ,CodingKey {
        case table = "table"
        case no = "no"
        case effectiveDate = "effectiveDate"
        case rates = "rates"
    }

}

struct CurrencyARate: Decodable ,Identifiable {
    var id: String
    var currency: String
    var mid: Double

    enum CodingKeys: String , CodingKey {
        case currency = "currency"
        case id = "code"
        case mid = "mid"
    }
}

struct DetailATable: Decodable {
    var table: String
    var currency: String
    var code: String
    var rates: [DetailARate]
}

struct DetailARate: Decodable ,Identifiable  {
    var id: String
    var effectiveDate: String
    var mid: Double

    enum CodingKeys: String ,CodingKey {
        case id = "no"
        case effectiveDate
        case mid
    }
}
