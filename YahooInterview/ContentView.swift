//
//  ContentView.swift
//  YahooInterview
//
//  Created by Bryan Caragay on 4/14/25.
//

import SwiftUI

//They want to see the information as a list of company names with the ability to view
//additional company details when tapping on a name. ✅


//They want a settings screen to specify the sort order (by company name or by market
//cap). ✅

//They would like to “favorite” companies. ✅

//The application should be up-to-date as much as possible ✅

//The application should be able to work offline (handle reboots, power failures) ✅

//While the getAllCompanies JSON currently has only a few entries, there can potentially
//be many thousands of entries and some day even require pagination. ✅

//You may assume the company symbol is unique. ✅

struct ContentView: View {
    @State var viewModel = CompaniesViewModel()
    @State private var showFilterSheet = false

    var body: some View {
        NavigationStack {
            CompanyListView(viewModel: viewModel)
                .navigationDestination(for: String.self) { symbol in
                    CompanyDetailView(symbol: symbol)
                }
                .navigationTitle("Companies")
                .toolbar {
                    Button {
                        showFilterSheet = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }
                .onAppear {
                    Task {
                        try await viewModel.getCompanies()
                    }
                }
                .sheet(isPresented: $showFilterSheet) {
                    FilterSheetView { filter in
                        viewModel.setFilterMethod(filter)
                    }
                    .presentationDetents([.fraction(0.25), .medium])
                }
        }
    }

    struct FilterSheetView: View {
        var onSelectFilter: ((CompaniesViewModel.FilterMethod) -> Void)

        var body: some View {
            List {
                Button("Filter by Name") {
                    onSelectFilter(.alphabetical)
                }
                Button("Filter by Market Cap") {
                    onSelectFilter(.marketCap)
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
