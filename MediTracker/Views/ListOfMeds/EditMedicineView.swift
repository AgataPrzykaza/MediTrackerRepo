//
//  EditMedcineView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 27/12/2023.
//

import SwiftUI

struct EditMedicineView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager: UserManager
   
    
    var medicationEntry: MedicationEntry
    
    @State var name: String = ""
    
    @State var dose: String = ""
    @State private var unit: String = "mg"
    let unitTypes = ["mg", "ml", "sztuki"]
    
    @State var type: String = "tabletka"
    let medType = ["tabletka","syrop","zastrzyk","probiotyk"]
    
    init(manager: UserManager,medEntry: MedicationEntry) {
            self.manager = manager
        self.medicationEntry = medEntry
        _name = State(initialValue: medEntry.medicine.name )
        _dose = State(initialValue: String(medEntry.medicine.dosage))
        _unit = State(initialValue: medEntry.medicine.unit )
        _type = State(initialValue: medEntry.medicine.type )
       
        
        }
    
    var body: some View {
        VStack{
            HStack(alignment: .top,spacing: 200){
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                        .frame(alignment: .top)
                }
                
                
                
                
                Button(action: {
                   
                      
                    updateMed()
                    
                    manager.profilemanager.updateProfile(profile: manager.currentProfileSelected!) { error in
                        if let error = error {
                            print("Błąd aktualizacji danych profilu: \(error.localizedDescription)")
                        } else {
                            print("Dane profilu zaktualizowane pomyślnie!")
                            
                        }
                    }

                    dismiss()
                      
                     
                        
                   
                    
                }) {
                    Text("ZAPISZ")
                        .font(.system(size: 20))
                        .foregroundStyle(K.BrandColors.darkPink1)
                }
            }
            
            Text("Edytuj lek ")
                .font(.system(size: 25))
                .padding(.bottom)
            
            VStack(alignment: .leading){
                
                Text("Nazwa leku")
                    .bold()
                
                
                TextField("Lek", text: $name)
                    .frame(width: 300,height: 40)
                    .autocorrectionDisabled()
                
                
                Text("Dawka")
                    .bold()
                
                
                TextField("Dawka", text: $dose)
                    .frame(width: 300,height: 40)
                    .autocorrectionDisabled()
                
                Picker("Typ", selection: $unit) {
                    ForEach(unitTypes, id: \.self) { unit in
                        Text(unit).tag(unit)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width:300)
                .padding(.bottom,15)
                
                
                HStack{
                    Text("Rodzaj: ")
                    Picker("Rodzaj",selection: $type){
                        ForEach(medType,id: \.self){ type in
                            Text(type).tag(type)
                            
                        }
                    }
                    .accentColor(.pink)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .padding(.top)
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func updateMed() {
        medicationEntry.medicine.setMedName(name)
        medicationEntry.medicine.setDose(Double(dose) ?? 0.0)
        medicationEntry.medicine.setUnit(unit)
        medicationEntry.medicine.setType(type)
        manager.updateMed(med: medicationEntry)
    }
    
    
}




