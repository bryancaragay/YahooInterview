//
//  CompanyDetailViewModel.swift
//  YahooInterview
//
//  Created by Bryan Caragay on 4/14/25.
//

import SwiftUI
import Foundation
import Observation
import RealmSwift

@Observable
class CompanyDetailViewModel {
    
    private var company: Company
    
    init(company: Company) {
        self.company = company
    }
    
    func toggleFavorite() {
        guard let thawed = company.thaw(), !thawed.isInvalidated, let realm = thawed.realm else { return }
        try? realm.write {
            thawed.favorited.toggle()
        }
    }
}
