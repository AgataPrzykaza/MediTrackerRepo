//
//  MedDetailsView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 16/12/2023.
//

import SwiftUI

struct MedDetailsView: View {
    @Environment(\.dismiss) var dismiss
    var medicationEntry: MedicationEntry
    @ObservedObject var manager: UserManager
    @Binding var medEdited: Bool
    
    @State private var showAlert = false
    @State private var alertMessage = "Lek został usunięty"
    
    var med: Medicine{
        medicationEntry.medicine
    }
    var body: some View {
        ScrollView{
            VStack(alignment: .leading,spacing: 15) {
                
                HStack(alignment: .top,spacing: 80){
                    Button(action: {
                        
                       
                      
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                            .frame(alignment: .top)
                    }
                    .padding(.bottom)
                    
                    Text("Opis leku")
                        .font(.system(size: 25))
                        .padding(.bottom)
                    
                    
                }
                
                HStack{
                    Text("Nazwa leku:  ")
                        .font(.system(size: 20))
                        .foregroundColor(K.BrandColors.intensePink1)
                    Text(med.name)
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(K.BrandColors.darkPink1)
                }
                
                HStack{
                    Text("Dawka:  ")
                        .font(.system(size: 20))
                        .foregroundColor(K.BrandColors.intensePink1)
                    Text(formatDoubleToString(med.dosage))
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(K.BrandColors.darkPink1)
                    Text(med.unit)
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(K.BrandColors.darkPink1)
                }
                
                HStack{
                    Text("Typ:  ")
                        .font(.system(size: 20))
                        .foregroundColor(K.BrandColors.intensePink1)
                    Text(med.type)
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(K.BrandColors.darkPink1)
                }
                
                HStack{
                    Text("Godzina pierwszego przyjęcia: ")
                        .font(.system(size: 20))
                        .foregroundColor(K.BrandColors.intensePink1)
                    Text(formatDate(med.startHour))
                        .font(.system(size: 21))
                        .bold()
                        .foregroundColor(K.BrandColors.darkPink1)
                }
                
                VStack(alignment: .leading){
                    Text("Dni tygodnia przyjmowania: ")
                        .font(.system(size: 20))
                        .foregroundColor(K.BrandColors.intensePink1)
                    
                    ForEach(unikalneDniTygodniaPosortowane(daty: medicationEntry.times), id: \.self) { weekday in
                        Text(" - \(weekday)")
                            .font(.system(size: 21))
                            .bold()
                            .foregroundColor(K.BrandColors.darkPink1)
                    }
                }
                HStack{
                    Text("Przyjmowanie na czczo: ")
                        .font(.system(size: 20))
                        .foregroundColor(K.BrandColors.intensePink1)
                    Text(med.onEmptyStomach ? "Tak" : "Nie")
                        .font(.system(size: 21))
                        .bold()
                        .foregroundColor(K.BrandColors.darkPink1)
                }
                VStack(alignment: .leading){
                    Text("Instrukcje przyjmowania: ")
                        .font(.system(size: 20))
                        .foregroundColor(K.BrandColors.intensePink1)
                    Text(med.instructions)
                        .font(.system(size: 21))
                        .bold()
                        .foregroundColor(K.BrandColors.darkPink1)
                }
                
                VStack(alignment: .leading){
                    Text("Interakcje z innymi lekami: ")
                        .font(.system(size: 20))
                        .foregroundColor(K.BrandColors.intensePink1)
                    Text(med.interactions.joined(separator: ", "))
                        .font(.system(size: 21))
                        .bold()
                        .foregroundColor(K.BrandColors.darkPink1)
                }
                
                if med.hourPeriod == 0 && med.frequency == 0 {
                    
                } else if med.hourPeriod == 0 {
                    HStack{
                        Text("Częstotliwość: ")
                            .font(.system(size: 20))
                            .foregroundColor(K.BrandColors.intensePink1)
                        Text(" \(med.frequency) razy dziennie")
                            .font(.system(size: 21))
                            .bold()
                            .foregroundColor(K.BrandColors.darkPink1)
                    }
                    
                    
                } else if med.frequency == 0 {
                    
                    HStack{
                        Text("Okres godzinowy: ")
                            .font(.system(size: 20))
                            .foregroundColor(K.BrandColors.intensePink1)
                        Text(" co \(med.hourPeriod) godzin")
                            .font(.system(size: 21))
                            .bold()
                            .foregroundColor(K.BrandColors.darkPink1)
                    }
                    
                    
                    
                } else {
                    
                    HStack{
                        Text("Okres godzinowy: ")
                            .font(.system(size: 20))
                            .foregroundColor(K.BrandColors.intensePink1)
                        Text(" co \(med.hourPeriod) godzin")
                            .font(.system(size: 21))
                            .bold()
                            .foregroundColor(K.BrandColors.darkPink1)
                    }
                    
                    HStack{
                        Text("Częstotliwość: ")
                            .font(.system(size: 20))
                            .foregroundColor(K.BrandColors.intensePink1)
                        Text(" \(med.frequency) razy dziennie")
                            .font(.system(size: 21))
                            .bold()
                            .foregroundColor(K.BrandColors.darkPink1)
                    }
                }
                
                
                HStack{
                    Text("Przypomnienie: ")
                        .font(.system(size: 20))
                        .foregroundColor(K.BrandColors.intensePink1)
                    Text(med.reminder ? "Tak" : "Nie")
                        .font(.system(size: 21))
                        .bold()
                        .foregroundColor(K.BrandColors.darkPink1)
                }
                HStack{
                    Text("Jest antybiotykiem: ")
                        .font(.system(size: 20))
                        .foregroundColor(K.BrandColors.intensePink1)
                    Text(med.isAntibiotic ? "Tak" : "Nie")
                        .font(.system(size: 21))
                        .bold()
                        .foregroundColor(K.BrandColors.darkPink1)
                }
                
                HStack(spacing: 45){
                    
                    NavigationLink("Edytuj lek", destination: EditMedicineView(manager: manager, medEntry: medicationEntry, medBinding: $medEdited))
                        .padding()
                        .font(.system(size: 20))
                        .frame(minWidth: 0, maxWidth: 130)
                        .background(K.BrandColors.pink2)
                        .foregroundStyle(.white)
                        .cornerRadius(24)
                    
                    
                    Button(action: {
                        
                        removeMedicine()
                        dismiss()
                    }) {
                        Text("Usuń lek")
                            .padding()
                            .font(.system(size: 20))
                            .frame(minWidth: 0, maxWidth: 130)
                            .background(K.BrandColors.darkPink2)
                            .foregroundStyle(.white)
                            .cornerRadius(24)
                    }
                    
                }
                .padding(.bottom)
                
                
                
                
                
            }}
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                       Alert(title: Text("Powiadomienie"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                   }
            
               
           
    }
    
    func removeMedicine(){
        for time in medicationEntry.times{
            
          
                
            manager.currentProfileSelected?.removeNotification(forMedicineName: medicationEntry.medicine.name,
                                                                   onDayOfWeek: Calendar.current.component(.weekday, from: time),
                                                                   atHour: Calendar.current.component(.hour, from: time))
            
        }
        manager.removeMedicine(medicineUID: medicationEntry.medicine.uid.uuidString) { error in
                       if let error = error {
                           alertMessage = "Błąd: \(error.localizedDescription)"
                       } else {
                           alertMessage = "Lek został usunięty."
                           
                       }
                       showAlert = true
                   }
    }
    
    func formatDoubleToString(_ value: Double) -> String {
        let intValue = Int(value)
        if value == Double(intValue) {
            return String(intValue)
        } else {
            return String(format: "%.1f", value)
        }
    }
    // Funkcja do formatowania daty
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    

    func unikalneDniTygodniaPosortowane(daty: [Date]) -> [String] {
        var dniTygodnia = Set<String>()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // format dla pełnej nazwy dnia tygodnia
            formatter.locale = Locale(identifier: "pl_PL") // Ustawienie polskiej lokalizacji

            let mapaDniTygodnia: [String: Int] = [
                "poniedziałek": 1,
                "wtorek": 2,
                "środa": 3,
                "czwartek": 4,
                "piątek": 5,
                "sobota": 6,
                "niedziela": 7
            ]

            for data in daty {
                dniTygodnia.insert(formatter.string(from: data))
            }

            return dniTygodnia.sorted { mapaDniTygodnia[$0]! < mapaDniTygodnia[$1]! }
    }
    
    }

//struct MedDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let medicine = Medicine(name: "Example Medicine", dosage: 10.0, unit: "mg", type: "Tabletka", hourPeriod: 6, frequency: 3, startHour: Date(), dayPeriod: 7, onEmptyStomach: false, delayMeds: 1, instructions: "Before meal", interactions: ["Interaction 1", "Interaction 2"], reminder: true, isAntibiotic: false)
//        let timestamps = [
//            1702635000,
//            1702678200,
//            1702883400,
//            1702926600,
//            1703153400,
//            1703196600
//        ]
//        
//        let times: [Date] = timestamps.map { Date(timeIntervalSince1970: TimeInterval($0)) }
//        let medicationEntry = MedicationEntry(medicine: medicine, times: times)
//        
//        return MedDetailsView(medicationEntry: medicationEntry, manager: UserManager(), medEdited: Binding<Bool>)
//    }
//}
