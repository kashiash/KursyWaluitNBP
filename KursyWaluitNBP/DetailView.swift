//
//  DetailView.swift
//  KursyWaluitNBP
//
//  Created by Jacek Kosinski U on 10/01/2024.
//

import SwiftUI
import Charts

struct DetailView: View {
    var rate: CurrencyARate

  @State  var rates: [DetailARate] = []
    @State var sPadding: CGFloat = 4.2
    @State var ePadding: CGFloat = 4.5
    var body: some View {
        Group{
            if rates.count > 0 {
                Text(rate.id)
                    .font(.title)
                let costs = rates.map { $0.mid }
                let min = costs.min()!
                let max = costs.max()!
                let strideBy = 5.0

                VStack {
                    if /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/ {
                        Chart(rates) { item in
                        LineMark(
                            x: .value("Date", item.effectiveDate.toDate(.isoDate)!),
                            y: .value("mid", item.mid/max)
                        )
                        .interpolationMethod(.cardinal)
                        .foregroundStyle(.green)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        .foregroundStyle(by: .value("Value", "rate"))
                    }
                    .chartYAxis {
                        let defaultStride = Array(stride(from: 0, to: 1, by: 1.0/strideBy))
                        let costsStride = Array(stride(from: min,
                                                       through: max,
                                                       by: (max - min)/strideBy))
                        AxisMarks(position: .trailing, values: defaultStride) { axis in
                            AxisGridLine()
                            let value = costsStride[axis.index]
                            AxisValueLabel("\(String(format: "%.2F", value)) PLN", centered: false)
                        }
                    }
//                    .chartForegroundStyleScale([
//
//                        "rate": .green,
//                    ])


                .frame(height: 100)
                    } else {
                        /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                    }
                }
                List {
                    ForEach(rates) { rec in
                        HStack {
                            Text(rec.effectiveDate)
                            Spacer()
                            Text(String(format:"%.4f",rec.mid))
                        }
                        .padding(.horizontal)
                    }
                }
            } else {
                ProgressView()
            }

        }
        .task {
            do {
                try await rates = getRates()

            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getRates() async throws -> [DetailARate] {
        guard let url = URL(string:"https://api.nbp.pl/api/exchangerates/rates/A/\(rate.id)/last/50")
        else {
            return []
        }
        let (data,_) = try await URLSession.shared.data(from: url)
        print(String(data:data, encoding: .utf8))
        let res = try JSONDecoder().decode(DetailATable.self, from: data)
        return res.rates

    }
}

#Preview {
    DetailView(rate: CurrencyARate(id:"EUR",currency: "Rubel eurpejski",mid: 2.6669))
        .preferredColorScheme(.dark)
}
