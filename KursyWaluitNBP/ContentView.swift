//
//  ContentView.swift
//  KursyWaluitNBP
//
//  Created by Jacek Kosinski U on 10/01/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @State private var rates = [CurrencyARate]()
    @State private var tableNo = ""
    @State private var date = ""

    var body: some View {
        NavigationStack {
            HStack{
                Spacer()
                Text(date)
                Spacer()
                Text(tableNo)
                Spacer()
            }
            .padding(.horizontal)
            .font(.caption2)

            List{
                ForEach(rates) { rate in
                    NavigationLink {
                        DetailView(rate: rate)
                    } label: {
                        HStack {
                            Text(rate.id ).font(.title).foregroundColor(.blue)
                            Text(rate.currency ).font(.caption)
                            Spacer()
                            Text(String(format: "%.4f",rate.mid ))
                                .font(.title)
                                .foregroundColor(.teal)
                        }
                    }
                }
            }
            .task {
                do {
                    try await rates = getRates()
                } catch {
                    print(error.localizedDescription)
                }
            }
            .navigationTitle("NBP rates")
        }

    }

    func getRates() async throws -> [CurrencyARate] {
        guard let url = URL(string:"https://api.nbp.pl/api/exchangerates/tables/A")
        else {
            return []
        }
        let (data,_) = try await URLSession.shared.data(from: url)
      //  print(String(data:data, encoding: .utf8))
        let tables = try JSONDecoder().decode([NbpATable].self, from: data)
        let response = tables.first
        if let res = response {
            date = res.effectiveDate
            tableNo = res.no
            return res.rates
        } else {
            return []
        }
    }
}

#Preview {
    ContentView()
}
