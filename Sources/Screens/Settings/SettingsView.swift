//
//  SettingsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var homeVM: HomeViewModel
    @StateObject var onboardingVM: OnboardingViewModel

    @Query
    var vehicles: [Vehicle2]

    var body: some View {
        NavigationView {
            VStack {
                Text("") // FIX: Workaround to not overlap  list on navigation title
                CustomList {
                    Section(header: Text("Vehicles")) {
                        ForEach(vehicles, id: \.uuid) { vehicle in
                            let destination = EditVehicleView(vehicle2: vehicle)
                            NavigationLink(destination: destination) {
                                CategoryRow(title: vehicle.name, icon: .carSettings, color: Palette.colorViolet)
                            }
                        }
                        .onDelete(perform: deleteVehicle)

                        Button(action: {
                            onboardingVM.addNewVehicle = true
                            onboardingVM.destination = .page2
                        }, label: {
                            CategoryRow(title: "Add vehicle ", icon: .plus, color: Palette.greyBackground)
                        })
                        .buttonStyle(.plain)
                    }
                    .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))

                    Section(header: Text("Other")) {
                        NavigationLink(destination: AboutView()) {
                            CategoryRow(title: "About us ", icon: .paperclip, color: Palette.greyBackground)
                        }

                        NavigationLink(destination: ToSView()) {
                            CategoryRow(title: "Terms of Service", icon: .paperclip, color: Palette.greyBackground)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                }
                .listStyle(.insetGrouped)
                Spacer()
            }
            .fullScreenCover(isPresented: $onboardingVM.addNewVehicle) {
                OnboardingView(onboardingVM: onboardingVM,
                               shouldShowOnboarding: $onboardingVM.addNewVehicle)
            }
            .background(Palette.greyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Text("Settings")
                    .foregroundColor(Palette.black)
                    .font(Typography.headerXL)
                    .padding(.top, 15)
            )
        }
    }

    func deleteVehicle(at offsets: IndexSet) {
        for index in offsets {
            let vehicleToDelete = vehicles[index]
            modelContext.delete(vehicleToDelete)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to delete vehicle: \(error)")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(homeVM: HomeViewModel(),
                     onboardingVM: OnboardingViewModel())
    }
}

struct PremiumBanner: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.accentColor)
                .cornerRadius(15)
                .frame(width: UIScreen.main.bounds.width * 0.915, height: UIScreen.main.bounds.height * 0.235 - 50)
            HStack {
                VStack(alignment: .leading) {
                    Text("Get more features")
                        .font(Typography.headerL)
                        .foregroundColor(Palette.white)
                    Text("Add more features to better \nmanage your vehicles")
                        .font(Typography.TextM)
                        .foregroundColor(Palette.white)
                        .padding(.top, -8)
                        .multilineTextAlignment(.leading)
                    ZStack {
                        Rectangle()
                            .cornerRadius(8)
                            .foregroundColor(Palette.white)
                            .frame(width: 100, height: 32)
                        Text("Coming soon")
                            .foregroundColor(Palette.black)
                            .font(Typography.ControlS)
                    }.padding(.top, 10)

                }.padding()
                Image("premium")
            }
            .padding(8)
        }
    }
}

struct ToSView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        HTMLView(htmlFileName: "TermsOfService")
            .padding()
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("arrowLeft")
                })
                .accentColor(Palette.greyHard)
            )
    }
}
