//
//  YahooInterviewTests.swift
//  YahooInterviewTests
//
//  Created by Bryan Caragay on 4/14/25.
//

import Testing
@testable import YahooInterview
import RealmSwift

struct YahooInterviewTests {

    // NOTE: Untested. Target won't build due to the following system error: Failed to clone device named 'iPhone 16 Pro'. (Underlying Error: The operation couldn’t be completed. Device was allocated but was stuck in creation state.  Check CoreSimulator.log for more information.)
    
    @MainActor
    @Test func testToggleCompanyFavorite() async throws {
        let realm = try? await Realm()
        let company = Company()

        try realm?.write {
            company.favorited = false
            company.symbol = "aaa"
            
            realm?.add(company)
        }

        let viewModel = CompanyDetailViewModel(company: Company())
        viewModel.toggleFavorite()
        
        #expect(company.favorited == true)
    }

    @Test func testCompanySearch() {
        let viewModel = CompaniesViewModel()
        viewModel.companies = [Company(name: "Apple", symbol: "AAPL", favorited: false), Company(name: "Block", symbol: "BLOCK", favorited: false), Company(name: "Capital One", symbol: "CPTL", favorited: false)]
        viewModel.searchTerm = "a"
        
        #expect(viewModel.sortedCompanies().count == 1)
    }
    
    @Test func testFilterCompanies() {
        let viewModel = CompaniesViewModel()
        viewModel.setFilterMethod(.alphabetical)
        viewModel.companies = [Company(name: "Block", symbol: "Block", favorited: false), Company(name: "Apple", symbol: "AAPL", favorited: false), Company(name: "Capital One", symbol: "CPTL", favorited: false)]
        
        #expect(viewModel.sortedCompanies().first?.name == "Apple")
    }
}
