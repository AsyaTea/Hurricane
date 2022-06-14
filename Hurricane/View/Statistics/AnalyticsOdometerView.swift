//
//  AnalyticsOdometerView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 12/05/22.
//

import SwiftUI

struct AnalyticsOdometerView: View {
    @ObservedObject var categoryVM : CategoryViewModel
    @ObservedObject var dataVM : DataViewModel
    @ObservedObject var utilityVM : UtilityViewModel
    var body: some View {
        VStack {
            
            List {
                Section {
                        VStack{
                            HStack {
                                VStack(alignment: .leading){
                                    Spacer()
                                    Text("\(String(Int(dataVM.currentVehicle.first?.odometer ?? 0))) Km")
                                        .font(Typography.headerL)
                                        .padding(1)
                                    Text("Odometer")
                                        .foregroundColor(Palette.greyHard)
                                }
                                Spacer()
                                Text(" ▼ 12 % ")
                                    .font(Typography.headerS)
                                    .foregroundColor(Palette.greenHighlight)
                            }
                            .padding(-3)
                            HStack{
//                                VStack(alignment: .trailing){
//                                    Text("10")
//                                    Text("9.5")
//                                    Text("9")
//                                    Text("8.5")
//                                    Text("8")
//                                    Text("7.5")
//                                }
//                               
//                                .font(.subheadline)
//                                .foregroundColor(Palette.greyMiddle)
                                OdometerGraphView(data: categoryVM.odometerGraphData)
                                    .frame(height: 200)
                                    .padding(.top, 25)
                                    .padding(1)
                            }
                            .padding(-15)
                            
//                            HStack(alignment: .bottom) {
//                                Text("Dec")
//                                Text("Jan")
//                                Text("Feb")
//                                Text("Mar")
//                                Text("Apr")
//                                Text("May")
//                                Text("Jun")
//                            }
//                            .font(.subheadline)
//                            .foregroundColor(Palette.greyMiddle)
//
                            Spacer()
                        }
                    }
                Section {
                    OdometerCostsView(categoryVM: categoryVM, dataVM: dataVM, utilityVM: utilityVM)
                        .padding(4)
                }
                }
                
            }
        .background(Palette.greyLight)
        }
    }


struct AnalyticsOdometerView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsOdometerView(categoryVM: CategoryViewModel(), dataVM: DataViewModel(), utilityVM: UtilityViewModel())
    }
}
