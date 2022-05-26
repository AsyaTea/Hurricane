//
//  ContentView2.swift
//  Hurricane
//
//  Created by Asya Tealdi on 05/05/22.
//

import SwiftUI

//struct ContentView2: View {
//
//    @StateObject private var vehicleVM = DataViewModel()
//
//    //    @State var vehicle : Vehicle = Vehicle()
//    @State var vehicle : VehicleModel = VehicleModel()
//    @State var expense : ExpenseModel = ExpenseModel()
//
//    @State var navigate = false
//    @State var filter : NSPredicate?
//
//    // MARK: PROVA DI AGGIUNTA
//    var body: some View {
//        NavigationView {
//        VStack{
//            TextField("Vehicle Name", text: $vehicle.name.toUnwrapped(defaultValue: ""))
//                .textFieldStyle(.roundedBorder)
//                .padding()
//            TextField("Expenses Name", text: $expense.note.toUnwrapped(defaultValue: ""))
//                .textFieldStyle(.roundedBorder)
//                .padding()
//            Text("ciao")
//            Button("Add veicolo"){
//                vehicleVM.addVehicle(vehicle: vehicle)
//            }
//            Button("Remove all vehicles"){
//                vehicleVM.removeAllVehicles()
//            }
//            Button("Remove all expenses"){
//                vehicleVM.removeAllExpenses()
//            }
//
//            Button("Set current vehicle to last added:"){
//                for vehicle in vehicleVM.vehicles {
//
//                    vehicleVM.setCurrentVehicle(currVehicle: vehicle)
//                }
//            }
//
//            List(){
//                ForEach(vehicleVM.vehicles){ vehicle in
//
//
//                        Button(action: {
//                            navigate.toggle()
//                            vehicleVM.setCurrentVehicle(currVehicle: vehicle)
//                            filter = NSPredicate(format: "vehicle ==  %@", vehicleVM.currVehicle)
//                            vehicleVM.getExpenses(filter: filter)
//                        }, label:  {
//                            HStack{
//                            Text("Vehicle name: \(vehicle.name ?? "")")
//                                Spacer()
//                                Text(">")
//                            }
//                        })
//
//                }
//                .onDelete(perform: vehicleVM.removeVehicle)
//
////                ForEach(vehicleVM.expenses) { expenses in
////                        Text("Exp: \(expenses.name ?? "")")
////                    Text("Vehicle appart:\(expenses.vehicle?.name ?? "" )")
////
////                } .onDelete(perform: vehicleVM.removeExpense(indexSet:))
//
//            }
//            NavigationLink(destination: ExpensesView(vehicleVM: vehicleVM),isActive: $navigate){}
//            //Floating button
//            .overlay(
//                VStack{
////                    Spacer(minLength: UIScreen.main.bounds.size.height * 0.62)
//                    Button(action: {
//
//                        vehicleVM.addExpense(expense: expense)
////                        vehicleVM.getExpenses()
//                    }, label: {
//                        ZStack{
//                            Rectangle()
//                                .frame(width: 343, height: 48, alignment: .center)
//                                .cornerRadius(43)
//                                .foregroundColor(Palette.black)
//                            HStack{
//                                Spacer()
//                                Image("plus")
//                                    .resizable()
//                                    .frame(width: 14, height: 14)
//                            Text("Add expense")
//                                .foregroundColor(Palette.white)
//                                .font(Typography.ControlS)
//                                Spacer()
//                            }
//                        }
//
//                    })
//                    Spacer()
//                }
////                    .padding(.top,50)
//            )
//
//        }
//        }
//    }
//}
//
//struct ExpensesView: View {
//    @ObservedObject var vehicleVM : DataViewModel
//
//    var body: some View {
//        VStack {
//            List {
//                ForEach(vehicleVM.expenses) { expenses in
//                    Text("\(vehicleVM.currVehicle.name ?? "")")
//                    Text("Exp: \(expenses.note ?? "")")
//                    Text("Vehicle appart:\(expenses.vehicle?.name ?? "" )")
//                } .onDelete(perform: vehicleVM.removeExpense(indexSet:))
//            }
//
//        }
//
//    }
//}

//struct ContentView_Previews: PreviewProvider {
//    var vehicle = Vehicle()
//    static var previews: some View {
//        ContentView(vehicle: vehicle)
//    }
//}




//Need to this to wrap optional values when Binding
extension Binding {
    func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

//MARK: TO DELETE FUNCS
//    func getVehicleID(id : UUID){
//        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
//        let filter = NSPredicate(format: "vehicleID == %@", id as CVarArg)
//        request.predicate = filter
//
//        do {
//             currentVehicle =  try manager.context.fetch(request)
//        }catch let error {
//            print("🚓 Error fetching the vehicle ID: \(error.localizedDescription)")
//        }
//
//    }


//    func getVehicles() {
//
//        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
//        let vehicle : [Vehicle]
//
//        //Sort for ID
//        let sort = NSSortDescriptor(keyPath: \Vehicle.objectID, ascending: true)
//        request.sortDescriptors = [sort]
//
//        //Filter if needed, ad esempio qua filtro per veicoli a benzina
//        //        let filter = NSPredicate(format: "fuelType == %@", "1")
//
//        do {
//            vehicle =  try manager.context.fetch(request)
//            DispatchQueue.main.async{
//                self.vehicleList = vehicle.map(VehicleViewModel.init)
//            }
//            print("VEHICLE LIST ",vehicleList)
//
//        }catch let error {
//            print("🚓 Error fetching vehicles: \(error.localizedDescription)")
//        }
//    }

//    func removeVehicle(indexSet: IndexSet) {
//        guard let index = indexSet.first else { return }
//        let entity = vehicleList[index]
//        manager.container.viewContext.delete(entity)
//        saveVehicle()
//    }

//    func getExpenses(filter : NSPredicate?){
//
//        let request = NSFetchRequest<Expense>(entityName: "Expense")
//        request.predicate = filter
//
//        do {
//            self.expenses =  try manager.context.fetch(request)
//        }catch let error {
//            print("💰 Error fetching expenses: \(error.localizedDescription)")
//        }
//    }

//    func getVehicles() {
//
//        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
//        let vehicle : [Vehicle]
//
//        //Sort for ID
//        let sort = NSSortDescriptor(keyPath: \Vehicle.objectID, ascending: true)
//        request.sortDescriptors = [sort]
//
//        //Filter if needed, ad esempio qua filtro per veicoli a benzina
//        //        let filter = NSPredicate(format: "fuelType == %@", "1")
//
//        do {
//            vehicle =  try manager.context.fetch(request)
//            DispatchQueue.main.async{
//                self.vehicleList = vehicle.map(VehicleViewModel.init)
//            }
//            print("VEHICLE LIST ",vehicleList)
//
//        }catch let error {
//            print("🚓 Error fetching vehicles: \(error.localizedDescription)")
//        }
//    }
