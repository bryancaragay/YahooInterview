//
//  Company.swift
//  YahooInterview
//
//  Created by Bryan Caragay on 4/14/25.
//

import RealmSwift

class Marketcap: Object, Codable {
    @Persisted var fmt: String
    @Persisted var longFmt: String
    @Persisted var raw: Double
}

class Company: Object, Codable, Identifiable {
    var id: String {
        return self.symbol
    }
    @Persisted var name: String
    @Persisted(primaryKey: true) var symbol: String
    @Persisted var marketCap: Marketcap?
    @Persisted var favorited: Bool
    
    convenience init(name: String, symbol: String, marketCap: Marketcap? = nil, favorited: Bool) {
        self.init()
        self.name = name
        self.symbol = symbol
        self.marketCap = marketCap
        self.favorited = favorited
    }
    
    enum CodingKeys: CodingKey {
        case name
        case symbol
        case marketCap
    }
}
