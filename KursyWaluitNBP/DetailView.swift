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

    var body: some View {
        Group{
            if rates.count > 0 {

                let costs = rates.map { $0.mid }
                let costMin:Double = costs.min()!
                let costMax:Double = costs.max()!
                let strideBy: Double = 3

               //
                VStack {
                    HStack{
                        Text(rate.id)
                            .font(.title)
                        Text(String(format:"%.4f",costMin))
                        Text(String(format:"%.4f",costMax))
                    }

                    if  true {
                        Chart(rates) { item in
                            let yvalue = item.mid

                        LineMark(
                            x: .value("Date", item.effectiveDate.toDate(.isoDate)!),
                            y: .value("mid",yvalue )
                        )
                        .interpolationMethod(.cardinal)
                        .foregroundStyle(.green)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        .foregroundStyle(by: .value("Value", "rate"))
                    }
                        .chartYAxis {

                            let costsStride = Array(stride(from: costMin,
                                                           through: costMax,
                                                           by: (costMax - costMin)/strideBy))
                            AxisMarks(position: .trailing, values: costsStride) { axis in
                                AxisGridLine()
                                let value = costsStride[axis.index]
                                AxisValueLabel("\(String(format: "%.4F", value)) PLN", centered: false)
                            }


                        }
                        .chartYScale(domain: costMin...costMax)
                    .chartForegroundStyleScale([

                        "rate": .green,
                    ])


                .frame(height:100)
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
        guard let url = URL(string:"https://api.nbp.pl/api/exchangerates/rates/A/\(rate.id)/last/255")
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
