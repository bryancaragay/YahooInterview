//
//  CompanyDetailView.swift
//  YahooInterview
//
//  Created by Bryan Caragay on 4/14/25.
//

import SwiftUI
import RealmSwift

struct CompanyDetailView: View {
    @State var viewModel: CompanyDetailViewModel
    
    // Note: Realm suggests keeping my object defined in the view, not the model, for observability purposes. Mutations are made via viewModel.
    @ObservedRealmObject var company: Company
    @State var comparisonCompany: Company?
    @State private var showComparisonSheet = false

    init(symbol: String) {
        guard let realm = DependencyStore.shared.realm else {
            _company = ObservedRealmObject(wrappedValue: Company())
            self.viewModel = .init(company: Company())
            return
        }
        
        if let fetchedCompany = realm.object(ofType: Company.self, forPrimaryKey: symbol) {
            _company = ObservedRealmObject(wrappedValue: fetchedCompany)
            self.viewModel = .init(company: fetchedCompany)
        } else {
            _company = ObservedRealmObject(wrappedValue: Company())
            self.viewModel = .init(company: Company())
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("Company") {
                    Text(self.company.name)
                    Text(self.company.symbol)
                    HStack {
                        Text("Market Cap")
                        Spacer()
                        Text(self.company.marketCap?.fmt ?? "-")
                            .font(.headline.bold())
                    }
                }
                
                if let comparisonCompany = self.comparisonCompany {
                    Section("Company") {
                        Text(comparisonCompany.name)
                        Text(comparisonCompany.symbol)
                        HStack {
                            Text("Market Cap")
                            Spacer()
                            Text(comparisonCompany.marketCap?.fmt ?? "-")
                                .font(.headline.bold())
                        }
                    }
                    Button("Change comparison") {
                        showComparisonSheet = true
                    }
                } else {
                    Button("Compare") {
                        showComparisonSheet = true
                    }
                }
            }
        }
        .sheet(isPresented: $showComparisonSheet) {
            CompanyListView(viewModel: CompaniesViewModel()) { company in
                DispatchQueue.main.async {
                   self.comparisonCompany = company
                   self.showComparisonSheet = false
               }
            }
            .buttonStyle(.plain)
        }
        .toolbar {
            Button {
                self.viewModel.toggleFavorite()
                print(self.company.favorited)
            } label: {
                self.company.favorited ? Image(systemName: "star.fill") : Image(systemName: "star")
            }
        }
    }
}

#Preview {
    CompanyDetailView(symbol: "AAPL")
}
