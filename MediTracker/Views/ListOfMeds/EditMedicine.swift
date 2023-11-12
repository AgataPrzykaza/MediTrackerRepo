//
//  EditMedicine.swift
//  MediTracker
//
//  Created by Agata Przykaza on 11/11/2023.
//

import SwiftUI


struct Day: Identifiable {
    let id = UUID()
    let name: String
    var isCompleted: Bool
}

struct EditMedicine: View {
    
    //Czas do ustawienia
    @State private var wakeUp = Date.now
    @State private var days = [
        Day(name: "Poniedziałek", isCompleted: false),
        Day(name: "Wtorek", isCompleted: false),
        Day(name: "Środa", isCompleted: false),
        Day(name: "Czwartek", isCompleted: false),
        Day(name: "Piątek", isCompleted: false),
        Day(name: "Sobota", isCompleted: false),
        Day(name: "Niedziela", isCompleted: false)
    ]
    
    @State private var dose = 8.0
    //Włacznik przypomnien
    @State private var isToggleOn = true
    
    //Częstość przpominania
    @State private var selectedFrequency = 1
    let frequencyOptions = [1, 2, 3, 4, 5]
    
    //Co ile godzin przypomnienia
    @State private var selecetedTimeFrequency = 4
    let timeFrequency = [12,11,10,9,8,7,6,5,4,3,2,1]
    //Dni przyjmowania
    @State private var selectedOption = "każdego dnia"
    let takeDays = ["każdego dnia", "wybrane dni"]
    
   //Instrukcje przyjmowania
    @State private var selectedInstruction = "Brak"
    let instructions = ["Przed jedzeniem","Po jedzeniu","Na czczo","W trakcie jedzenia","Brak"]
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            ScrollView{
                
                //MARK: - Nagłówek widoku
                //-----------------------------------------------------------------
                HStack(alignment: .top,spacing: 60){
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                            .frame(alignment: .top)
                    }
                    .padding(.bottom)
                    
                    Text("Edytuj lek ")
                        .font(.system(size: 25))
                        .padding(.bottom)
                    
                    Button(action: {
                        
                    }) {
                        Text("Zapisz")
                            .font(.system(size: 20))
                            .foregroundStyle(K.BrandColors.darkPink1)
                    }
                    .padding(.bottom)
                    
                }
                .padding(.bottom,10)
                
                //-----------------------------------------------------------------
                //MARK: - Nazwa leku
                VStack{
                    
                    Text("Nazwa leku")
                        .bold()
                    
                    TextField("Lek", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .frame(width: 300,height: 40)
                        .autocorrectionDisabled()
                        .onSubmit {
                            
                        }
                    //-----------------------------------------------------------------
                    
    //MARK: - Dawka
                    VStack{
                        
                        Text("Dawka")
                        
                        Stepper("\(dose) hours", value: $dose)
                    }
                    //MARK: - Toggle Przypomnienia
                    HStack{
                        Text("Przypomnienie")
                            .frame(width: 200)
                        Toggle(isOn: $isToggleOn) {
                        }
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .tint(.pink)
                        
                        
                    }
                    .padding(.bottom,35)
                    
                    //jesli przypomnienia
                    if isToggleOn{
                        Text("Wybierz ilość razy dziennie:")
                        
                        HStack{
                            
                            
                            Picker("Picker", selection: $selectedFrequency) {
                                ForEach(frequencyOptions, id: \.self) { frequency in
                                    Text("\(frequency) razy dziennie")
                                        .tag(frequency)
                                    
                                }
                            }
                            
                            if selectedFrequency > 1 {
                                
                                
                                Picker("Picker", selection: $selecetedTimeFrequency) {
                                    ForEach(timeFrequency, id: \.self) { frequency in
                                        Text("co \(frequency) godziny")
                                            .tag(frequency)
                                        
                                    }
                                }
                               
                                
                            }
                        }
                        
                        HStack{
                            
                            Text("Pierwsze przypomnienie: ")
                            DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                            
                        }
                        
                    }
                    //bez przypomnien
                    else{
                        
                        Text("Brak przypomnien")
                    }
                }
                .padding(.bottom,30)
                //-------------------------------------------------------------------
                
                Divider()
                    .padding(.bottom,23)
                
                //MARK: - Harmonogram dzienny
                VStack{
                    
                    Text("Harmonogram")
                        .bold()
                        .padding(.bottom,23)
                    Text("Dni przyjmowania")
                    
                    Picker(selection: $selectedOption, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                        ForEach(takeDays, id: \.self){
                            day in
                            Text(day)
                                .tag(day)
                        }
                    }
                    
                    if !selectedOption.isEmpty{
                        if selectedOption == "każdego dnia"{
                            
                        }
                        else if selectedOption == "wybrane dni"{
                            
                            List($days) { $day in
                                DayCellView(day: $day)
                            }
                            .scaledToFit()
                        }
                    }
                    
                    
                }
                .padding(.bottom,10)
                
                Divider()
                    .padding(.bottom,12)
                
 //MARK: - Instrukcje przyjmowania
                VStack{
                    Text("Instrukcje przyjmowania")
                        .bold()
                    
                    Picker("Picker", selection: $selectedInstruction) {
                        ForEach(instructions, id: \.self) { instruction in
                            Text("\(instruction)")
                                .tag(instruction)
                            
                        }
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationBarBackButtonHidden()
        
    }
}

//MARK: - Komórka listy

struct DayCellView: View{
    
    @Binding var day: Day
    
    var body: some View{
        HStack{
            Image(systemName: day.isCompleted ? "checkmark.square": "square")
                .onTapGesture {
                    day.isCompleted.toggle()
                }
            Text(day.name)
        }
    }
}



#Preview {
    EditMedicine()
}
