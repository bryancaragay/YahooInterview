//
//  CompanyListView.swift
//  YahooInterview
//
//  Created by Bryan Caragay on 4/14/25.
//

import SwiftUI
import Observation

struct CompanyListView: View {
    @State var viewModel: CompaniesViewModel
    var onSelectCompany: ((Company) -> Void)?

    var body: some View {
        List {
            let sorted = viewModel.sortedCompanies()
            let favorites = sorted.filter { $0.favorited }
            let nonFavorites = sorted.filter { !$0.favorited }

            if !favorites.isEmpty {
                Section("Favorites") {
                    ForEach(favorites) { company in
                        companyRow(for: company)
                    }
                }
            }

            Section("All Companies") {
                ForEach(nonFavorites) { company in
                    companyRow(for: company)
                }
            }
        }
        .searchable(text: $viewModel.searchTerm)
    }

    @ViewBuilder
    private func companyRow(for company: Company) -> some View {
        if let onSelectCompany = onSelectCompany {
            Button {
                onSelectCompany(company)
            } label: {
                CompanyRow(company: company)
            }
        } else {
            NavigationLink(value: company.symbol) {
                CompanyRow(company: company)
            }
        }
    }
}
