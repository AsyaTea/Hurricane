//
//  AddReportView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct AddReportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var vehicleManager: VehicleManager

    @EnvironmentObject var utilityVM: UtilityViewModel

    @State private var showOdometerAlert = false

    @State private var reminder: Reminder = .mock()
    @State var fuelExpense: FuelExpense = .mock()
    @State var fuelCategories: [FuelType] = []

    @State private var fuelTotal: Float = 0.0

    // FIXME: Focus keyboard
    @FocusState var focusedField: FocusField?

    @State private var currentPickerTab: AddReportTabs = .fuel

    var body: some View {
        NavigationView {
            VStack {
                // MARK: Text field

                switch currentPickerTab {
                case .reminder:
                    TextFieldComponent(
                        submitField: $reminder.title,
                        placeholder: "-",
                        attribute: "ㅤ",
                        keyboardType: .default,
                        focusedField: $focusedField,
                        defaultFocus: .reminderTab
                    )
                    .padding(.top, 15)
                case .fuel:
                    HStack {
                        Spacer()
                        TextField("", value: $fuelTotal, formatter: NumberFormatter.twoDecimalPlaces)
                            .keyboardType(.decimalPad)
                            .font(Typography.headerXXL)
                            .foregroundColor(Palette.black)
                            .fixedSize(horizontal: true, vertical: true)
                        Text(utilityVM.currency)
                            .font(Typography.headerXXL)
                            .foregroundColor(Palette.black)
                        Spacer()
                    }
                    .padding(.top, 15)
                }

                SegmentedPicker(currentTab: $currentPickerTab, onTap: {})
                    .padding(.horizontal, 32)
                    .padding(.top, -10.0)

                // MARK: List

                switch currentPickerTab {
                case .reminder:
                    ReminderInputView(reminder: $reminder, focusedField: $focusedField)
                case .fuel:
                    FuelExpenseInputView(vehicleFuels: fuelCategories, fuelExpense: $fuelExpense)
                        .onAppear {
                            // Reset the reminder when switching tabs
                            reminder = .mock()
                        }
                }
            }
            .background(Palette.greyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .font(Typography.headerM)
                })
                .accentColor(Palette.greyHard),
                trailing:
                Button(
                    action: {
                        switch currentPickerTab {
                        case .reminder:
                            NotificationManager.shared.requestAuthNotifications()
                            do {
                                try reminder.saveToModelContext(context: modelContext)
                            } catch {
                                // TODO: Implement error handling
                                print("error \(error)")
                            }
                            NotificationManager.shared.createNotification(for: reminder)
                            presentationMode.wrappedValue.dismiss()
                        case .fuel:
                            if fuelExpense.isValidOdometer(for: vehicleManager.currentVehicle) {
                                if fuelExpense.odometer > vehicleManager.currentVehicle.odometer {
                                    vehicleManager.currentVehicle.odometer = fuelExpense.odometer
                                }
                                fuelExpense.totalPrice = fuelTotal
                                vehicleManager.currentVehicle.fuelExpenses.append(fuelExpense)
                                fuelExpense.insert(context: modelContext)
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                showOdometerAlert.toggle()
                            }
                        }
                    },
                    label: {
                        Text(String(localized: "Save"))
                            .font(Typography.headerM)
                    }
                )
                .disabled(reminder.title.isEmpty && (fuelExpense.totalPrice.isZero || fuelExpense.quantity.isZero))
                .opacity(reminder.title.isEmpty && (fuelExpense.totalPrice.isZero || fuelExpense.quantity.isZero) ? 0.6 : 1)
            )
            .toolbar {
                /// Keyboard focus
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button(action: {
                            focusedField = nil
                        }, label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .resizable()
                                .foregroundColor(Palette.black)
                        })
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(String(localized: "New report"))
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            .alert(isPresented: $showOdometerAlert) {
                Alert(
                    title: Text("Attention"),
                    message: Text("Can't set this odometer value for the specific timerframe, make sure it's correct")
                )
            }
        }
        .onAppear {
            initializeFuelExpense()
        }
    }

    private func initializeFuelExpense() {
        let currentVehicle = vehicleManager.currentVehicle
        fuelExpense = FuelExpense(
            totalPrice: 0.0,
            quantity: 0,
            pricePerUnit: 0.0,
            odometer: currentVehicle.odometer,
            fuelType: currentVehicle.mainFuelType,
            date: Date(),
            vehicle: nil
        )

        fuelCategories.append(currentVehicle.mainFuelType)
        guard let secondaryFuelType = currentVehicle.secondaryFuelType else { return }
        fuelCategories.append(secondaryFuelType)
    }
}

struct TextFieldComponent: View {
    @Binding var submitField: String
    var placeholder: String
    var attribute: String
    var keyboardType: UIKeyboardType

    var focusedField: FocusState<FocusField?>.Binding
    var defaultFocus: FocusField

    var body: some View {
        HStack {
            Spacer()
            TextField(placeholder, text: $submitField)
                .focused(focusedField, equals: defaultFocus)
                .font(Typography.headerXXL)
                .foregroundColor(Palette.black)
                .keyboardType(keyboardType)
                .fixedSize(horizontal: true, vertical: true)

            Text(attribute)
                .font(Typography.headerXXL)
                .foregroundColor(Palette.black)
            Spacer()
        }
    }
}

enum FocusField: Hashable {
    case odometerTab
    case reminderTab
    case fuelTab
    case odometer
    case liter
    case priceLiter
    case note
}

enum AddReportTabs: String, CaseIterable, Identifiable {
    case fuel
    case reminder

    var id: Self { self }
}
