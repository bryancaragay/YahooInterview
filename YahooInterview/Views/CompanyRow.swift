//
//  CompanyRow.swift
//  YahooInterview
//
//  Created by Bryan Caragay on 4/14/25.
//

import SwiftUI

struct CompanyRow: View {
    var company: Company
    
    var body: some View {
        HStack {
            Color.gray.opacity(0.2)
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(company.symbol)
                    .font(.caption)
                Text(company.name)
            }
            Spacer()
            Text(company.marketCap?.fmt ?? "-")
        }
        .padding(.vertical)
    }
}
