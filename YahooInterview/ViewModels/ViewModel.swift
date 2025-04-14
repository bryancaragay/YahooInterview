//
//  ViewModel.swift
//  YahooInterview
//
//  Created by Bryan Caragay on 4/14/25.
//

import SwiftUI
import Foundation
import Observation

@Observable
class CompaniesViewModel {
    enum FilterMethod {
        case alphabetical
        case marketCap
    }
    
    private var filterMethod: FilterMethod = .alphabetical
    
    var companies: [Company] = []
    var searchTerm: String = ""
    
    init() {
        let results = DependencyStore.shared.realm?.objects(Company.self).toArray(type: Company.self)
        self.companies = results ?? []
    }
    
    func setFilterMethod(_ filterMethod: FilterMethod) {
        self.filterMethod = filterMethod
    }
    
    func sortedCompanies() -> [Company] {
        let searchedCompanies = self.searchTerm.isEmpty ? self.companies : self.companies.filter { $0.name.lowercased().contains(self.searchTerm.lowercased()) || $0.symbol.lowercased().contains(self.searchTerm.lowercased()) }
        
        switch self.filterMethod {
        case .alphabetical:
            return searchedCompanies.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case .marketCap:
            return searchedCompanies.sorted { $0.marketCap?.raw ?? 0 > $1.marketCap?.raw ?? 0 }
        }
    }
    
    @MainActor
    func getCompanies() async throws {
        guard let data = try await DependencyStore.shared.apiDispatcher.dispatchRequest(request: GetCompaniesRequest()) else {
            throw URLError(.badServerResponse)
        }

        let decodedCompanies = try JSONDecoder().decode([Company?].self, from: data).compactMap { $0 }
        self.companies = decodedCompanies
        
        try? DependencyStore.shared.realm?.write {
            for newCompany in decodedCompanies {
                if let existingCompany = DependencyStore.shared.realm?.object(ofType: Company.self, forPrimaryKey: newCompany.symbol) {
                    newCompany.favorited = existingCompany.favorited
                }
                DependencyStore.shared.realm?.add(newCompany, update: .modified)
            }
        }
    }
}
