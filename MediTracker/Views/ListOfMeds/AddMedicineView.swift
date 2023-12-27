//
//  AddMedicineView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 02/12/2023.
//

import SwiftUI

struct AddMedicineView: View {
    
   @ObservedObject var manager: UserManager
    
    
    @State private var keyboardHeight: CGFloat = 0

    @State var name: String = ""
    
    @State var dose: String = ""
    @State private var unit: String = "mg"
    let unitTypes = ["mg", "ml", "sztuki"]
    
    @State var type: String = "tabletka"
    let medType = ["tabletka","syrop","zastrzyk","probiotyk"]
    @State var antibioticToggle: Bool = false
    
    @State var frequencyType: String = "raz dziennie"
    let frequencyTypes = ["raz dziennie","X razy dziennie","co X godzin"]
    
    @State var frequency: Int = 0
    let frequencies = [0,2,3,4,5,6,7,8,9,10,11,12]
    
    @State var dayType: Int = 0
    let dayTypes = [0,1,2,3,4,5,6,7]

    
    @State var hourPeriod: Int = 0
    let hours = [0,1,2,3,4,5,6,7,8,9,10,11,12]
    
    @State var firstDose = Date.now
    
    //Instrukcje przyjmowania
     @State private var selectedInstruction = "Brak"
     let instructions = ["Przed jedzeniem","Po jedzeniu","Na czczo","W trakcie jedzenia","Brak"]
    
    @State var extraInstruction: String = ""
    @State var interactions: String = ""
    @State var withOtherMeds :Bool = false

    @State var delayMeds: Int = 0
    let hourDelay = [1,2,3,4,5,6,7,8,9,10,11,12]
    
    @State var probioticName: String = ""
    @State var probioticDose: String = ""
    
    @State var probioticPeriod: Int = 0
    @State var beforeAfterProbiotic: String = "przed"
    
    @State var everyday: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    
    
    func goodFields() -> Bool {
        
        
        if !name.isEmpty && !dose.isEmpty {
            
            
            if antibioticToggle{
                
                if !probioticDose.isEmpty && !probioticName.isEmpty{
                    
                    return true
                }
                else
                {
                    return false
                }
                
                
                
            }
            else{
                return true
            }
            
            
            
        }
        else{
            return false
        }
        
        
        
        
    }
    
    func calculateHourPeriod() -> Int{
        
        if frequencyType == frequencyTypes[1]{
            return 24/frequency
        }
        else if frequencyType == frequencyTypes[2]{
            
            return hourPeriod
        }
        else
        {
            return 0
        }
      
    }
    
    func calculateFrequency() -> Int{
        
        if frequencyType == frequencyTypes[1]{
            return frequency
        }
        else if frequencyType == frequencyTypes[2]{
            
            return 24/frequency
        }
        else
        {
            return 1
        }
      
    }
    
    func stringToArray(_ input: String) -> [String] {
        let components = input.components(separatedBy: ",")
        return components.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    func createMedicine(){
        
        let med = Medicine(name: name, dosage: Double(dose)!, unit: unit, type: type, hourPeriod: hourPeriod, frequency:frequency,startHour: firstDose, dayPeriod: dayType, onEmptyStomach: selectedInstruction == "Na czczo" ? true: false, delayMeds: 0, instructions: selectedInstruction + ", " + extraInstruction, interactions: stringToArray(interactions), reminder: true, isAntibiotic: antibioticToggle)
        manager.currentProfileSelected?.addMedication(med,delay: Double(delayMeds))
      
      
        if antibioticToggle{
            
            var timeProbiotic: Date
            if beforeAfterProbiotic == "przed"{
                timeProbiotic = firstDose.addingTimeInterval(Double(-probioticPeriod * 3600))
            }else{
                timeProbiotic = firstDose.addingTimeInterval(Double(probioticPeriod*3600))
            }
            
            let probiotic = Medicine(name: probioticName, dosage: Double(probioticDose)!, unit: "sztuki", type: "probiotyk", hourPeriod: 0, frequency: 1, startHour: timeProbiotic, dayPeriod: dayType, onEmptyStomach: false, delayMeds: 0, instructions: "", interactions: [], reminder: true, isAntibiotic: false)
         
            manager.currentProfileSelected?.addMedication(probiotic,delay:0)

        }
       
        
        manager.updateProfile() 
    }
    
    var body: some View {
        
        ScrollView{
            
            
            VStack{
                
                //MARK: - Nagłówek widoku
                //-----------------------------------------------------------------
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
                        
                        if goodFields(){
                            createMedicine()
                            dismiss()
                        }
                        
                    }) {
                        Text("ZAPISZ")
                            .font(.system(size: 20))
                            .foregroundStyle(K.BrandColors.darkPink1)
                    }
                    
                    
                }
                
    
                Text("Dodaj lek ")
                    .font(.system(size: 25))
                    .padding(.bottom)
                //------------------------------------------------------------------------------
                
                //MARK: - Pole nazwy leku oraz dawki
                
                VStack(alignment: .leading){
                    
                    Text("Nazwa leku")
                        .bold()
                    
                    TextField("Lek", text: $name)
                        .frame(width: 300,height: 40)
                        .autocorrectionDisabled()
                        .onSubmit {
                            
                        }
                    
                    
                    Text("Dawka")
                        .bold()
                    
                    
                    TextField("Lek", text: $dose)
                        .frame(width: 300,height: 40)
                        .autocorrectionDisabled()
                        .onSubmit {
                            
                        }
                    
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
                    
                    
                   Divider()
                        .frame(width:300)
                        .background(K.BrandColors.darkPink2)
                        .padding(.bottom, 15)
                    
                    
                    
                    
                }
                //MARK: - Czestotliwosc brania leku i wybranie startowej godziny
            //Braanie leku---------------------------------------------------------------------------
                VStack(alignment: .leading){
                    
                    Text("Częstotliwość brania leku:")
                        .bold()
                        .padding(.bottom,10)
                    
                    
                    //MARK: - Czy mozna brac z innymi lekami
                    HStack{
                        Text("Codzienne")
                            .frame(width: 200)
                        Toggle(isOn: $everyday) {
                        }
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .tint(.pink)
                        
                        
                    }
                    
                    if !everyday{
                        HStack{
                            Text("Co")
                            Picker("Dni", selection: $dayType) {
                                ForEach(dayTypes, id: \.self) { day in
                                    Text(String(day)).tag(day)
                                }
                            }
                            .accentColor(.pink)
                            
                            Text("dni")
                        }
                    }
                    
                   
                    
                    Picker("Czestosc", selection: $frequencyType) {
                        ForEach(frequencyTypes, id: \.self) { freq in
                            Text(freq).tag(freq)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width:300)
                    .padding(.bottom)
                    
                    if frequencyType == frequencyTypes[0]{
                        HStack{
                            
                            Text("Godzina przypomnienia: ")
                            DatePicker("Please enter a date", selection: $firstDose, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                            
                        }
                        .padding(.bottom)
                    }
                    
                    if frequencyType == frequencyTypes[1]{
                        
                        HStack{
                            Text("Ile razy dziennie")
                            
                            Picker("Czestosc", selection: $frequency) {
                                ForEach(frequencies, id: \.self) { freq in
                                    Text(String(freq)).tag(freq)
                                }
                            }
                            .accentColor(.pink)
                            
                        }
                        
                        HStack{
                            
                            Text("Pierwsze przypomnienie: ")
                            DatePicker("Please enter a date", selection: $firstDose, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                            
                        }
                        .padding(.bottom)
                    }
                    
                    if frequencyType == frequencyTypes[2]{
                        
                        HStack{
                            Text("Co ile godzin")
                            
                            Picker("Godziny", selection: $hourPeriod) {
                                ForEach(hours, id: \.self) { hour in
                                    Text(String(hour)).tag(hour)
                                }
                            }
                            .accentColor(.pink)
                            
                        }
                        
                        
                        HStack{
                            
                            Text("Pierwsze przypomnienie: ")
                            DatePicker("Please enter a date", selection: $firstDose, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                            
                        }
                        .padding(.bottom)
                    }
                    
                    //MARK: - Instrukcje przyjmowania
                    Divider()
                         .frame(width:300)
                         .background(K.BrandColors.darkPink2)
                         .padding(.bottom, 15)
                    VStack{
                        
                        Text("Instrukcje przyjmowania")
                            .bold()
                        
                        Picker("Picker", selection: $selectedInstruction) {
                            ForEach(instructions, id: \.self) { instruction in
                                Text("\(instruction)")
                                    .tag(instruction)
                                
                            }
                        }
                        .accentColor(.pink)
                    }
                    .padding(.bottom)
                    
                    
                    Text("Dodatkowe instrukcje i informacje")
                        .bold()
                    
                    TextField("Informacje", text: $extraInstruction)
                        .frame(width: 300,height: 40)
                        .autocorrectionDisabled()
                        .onSubmit {
                            
                        }
                    
                    
                    
                    Text("Czy można brać lek z innymi lekami:")
                        .bold()
                    
                    //MARK: - Czy mozna brac z innymi lekami
                    HStack{
                        Text("Nie można")
                            .frame(width: 200)
                        Toggle(isOn: $withOtherMeds) {
                        }
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .tint(.pink)
                        
                        
                    }
                    
                    if withOtherMeds{
                        
                        Text("Przesunięcie leków")
                        
                        HStack{
                            Text("O ile godzin przesunąć")
                             
                            Picker("godziny", selection: $delayMeds) {
                                ForEach(hourDelay, id: \.self) { hour in
                                    Text(String(hour)).tag(hour)
                                }
                            }
                            .accentColor(.pink)
                            
                            
                            
                        }
                        
                        Text("Lista interacji, po przecinku")
                        TextField("Interakcje", text: $interactions)
                            .frame(width: 300,height: 40)
                            .autocorrectionDisabled()
                            .onSubmit {
                                
                            }
                        
                    }
                    
                    //MARK: - Informacja o antybiotyku i probiotyku
                    HStack{
                        Text("Antybiotyk")
                            .frame(width: 200)
                        Toggle(isOn: $antibioticToggle) {
                        }
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .tint(.pink)
                        
                        
                    }
                    
                    if antibioticToggle{
                        
                        Text("Nazwa probiotyku")
                            .bold()
                        
                        TextField("Probiotyk", text: $probioticName)
                            .frame(width: 300,height: 40)
                            .autocorrectionDisabled()
                            .onSubmit {
                                
                            }
                        
                        
                        Text("Dawka")
                            .bold()
                        
                        
                        TextField("Dawka - ilość", text: $probioticDose)
                            .frame(width: 300,height: 40)
                            .autocorrectionDisabled()
                            .onSubmit {
                                
                            }
                        
                        Text("Odstęp od antybiotyku")
                        
                       
                        
                        
                        HStack{
                            Text("Ile godzin")
                            
                            Picker("godziny", selection: $probioticPeriod) {
                                ForEach(hourDelay, id: \.self) { hour in
                                    Text(String(hour)).tag(hour)
                                }
                            }
                            .accentColor(.pink)
                            
                            Picker("Typ", selection: $beforeAfterProbiotic) {
                                ForEach(["przed","po"], id: \.self) { unit in
                                    Text(unit).tag(unit)
                                }
                            }
                            .accentColor(.pink)
                        }
                        
                    }
                
                }
                .padding(.bottom)
                
                
                
                
                
                
            }
            .toolbar(.hidden, for: .navigationBar)
            
           
           
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, keyboardHeight)
        .edgesIgnoringSafeArea(.bottom)
        .background(K.BrandColors.Beige)
        .toolbar(.hidden, for: .navigationBar)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear {
            
            //podniesienie widoku by klawiatura nie nachodzila na pola tekstowe
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { notification in
                        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                            keyboardHeight = keyboardSize.height
                        }
                    }

                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        keyboardHeight = 0
                    }
                }
        
        
    }
}

#Preview {
    AddMedicineView(manager: UserManager())
}
