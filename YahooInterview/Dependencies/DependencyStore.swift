//
//  DependencyStore.swift
//  YahooInterview
//
//  Created by Bryan Caragay on 4/14/25.
//

import RealmSwift

class DependencyStore {
    static var shared = DependencyStore()
    
    var apiDispatcher = APIDispatcher()
    var realm: Realm? {
        return try? Realm()
    }
}
