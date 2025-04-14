//
//  Realm.swift
//  YahooInterview
//
//  Created by Bryan Caragay on 4/14/25.
//

import RealmSwift

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
