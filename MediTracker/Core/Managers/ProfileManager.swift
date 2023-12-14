//
//  ProfileManager.swift
//  MediTracker
//
//  Created by Agata Przykaza on 27/11/2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class ProfileManager{
    
   
    let db = Firestore.firestore()
    @Published var medHistoryManager = MedicationHistoryManager()
    
    
    
    func updateProfile(profile: Profile, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.async {
            let profileRef = self.db.collection("profiles").document(profile.uid)
            
            // Konwersja harmonogramu leków na format zrozumiały dla Firebase
            let medicationScheduleData = profile.medicationSchedule.map { entry -> [String: Any] in
                [
                    "medicine": [
                        "uid": entry.medicine.uid.uuidString,
                        "name": entry.medicine.name,
                        "dosage": entry.medicine.dosage,
                        "unit": entry.medicine.unit,
                        "type": entry.medicine.type,
                        "hourPeriod": entry.medicine.hourPeriod,
                        "frequency": entry.medicine.frequency,
                        "startHour": entry.medicine.startHour.timeIntervalSince1970,
                        "dayPeriod": entry.medicine.dayPeriod,
                        "onEmptyStomach": entry.medicine.onEmptyStomach,
                        "delayMeds": entry.medicine.delayMeds,
                        "instructions": entry.medicine.instructions,
                        "interactions": entry.medicine.interactions,
                        "reminder": entry.medicine.reminder,
                        "isAntibiotic": entry.medicine.isAntibiotic
                        
                    ],
                    "times": entry.times.map { $0.timeIntervalSince1970 } // Konwersja dat na timestamp
                ]
            }
            
            // Nowe dane profilu
            var updatedData: [String: Any] = [
                "name": profile.name,
                "surname": profile.surname,
                "pictureType": profile.pictureType,
                "medicationSchedule": medicationScheduleData
            ]
            
            // Aktualizacja danych profilu
            profileRef.setData(updatedData, merge: true) { error in
                if let error = error {
                    print("Błąd aktualizacji danych profilu: \(error.localizedDescription)")
                    completion(error)
                } else {
                    print("Dane profilu zaktualizowane pomyślnie!")
                    completion(nil)
                }
            }
        }
    }
    
    
   
    
    //MARK: - Pobranie danych profilów
    func fetchProfiles(profileRefs: [DocumentReference], completion: @escaping ([Profile]) -> Void) {
        var profiles: [Profile] = []
        let dispatchGroup = DispatchGroup()

        for profileRef in profileRefs {
            dispatchGroup.enter()
            profileRef.getDocument { (document, error) in
                defer { dispatchGroup.leave() }

                if let document = document, document.exists {
                    let data = document.data()
                    var profile = Profile(uid: "", name: "", surname: "", pictureType: "")
                    if let data = data {
                        profile.name = data["name"] as? String ?? ""
                        profile.surname = data["surname"] as? String ?? ""
                        profile.pictureType = data["pictureType"] as? String ?? ""
                        profile.uid = data["uid"] as? String ?? document.documentID

                        if let medicationScheduleData = data["medicationSchedule"] as? [[String: Any]] {
                            for entryData in medicationScheduleData {
                                if let medicineData = entryData["medicine"] as? [String: Any],
                                   let timesData = entryData["times"] as? [TimeInterval] {

                                    let medicine = Medicine(
                                        name: medicineData["name"] as? String ?? "",
                                        dosage: medicineData["dosage"] as? Double ?? 0.0,
                                        unit: medicineData["unit"] as? String ?? "",
                                        type: medicineData["type"] as? String ?? "",
                                        hourPeriod: medicineData["hourPeriod"] as? Int ?? 0,
                                        frequency: medicineData["frequency"] as? Int ?? 0,
                                        startHour: Date(timeIntervalSince1970: medicineData["startHour"] as? TimeInterval ?? 0),
                                        dayPeriod: medicineData["dayPeriod"]as? Int ?? 0,
                                        onEmptyStomach: medicineData["onEmptyStomach"] as? Bool ?? false,
                                        delayMeds: medicineData["delayMeds"] as? Int ?? 0,
                                        instructions: medicineData["instructions"] as? String ?? "",
                                        interactions: medicineData["interactions"] as? [String] ?? [],
                                        reminder: medicineData["reminder"] as? Bool ?? false,
                                        isAntibiotic: medicineData["isAntibiotic"] as? Bool ?? false
                                    )
                                    medicine.setUid(id: UUID(uuidString: medicineData["uid"] as? String ?? "") ?? UUID())
                                    let times = timesData.map { Date(timeIntervalSince1970: $0) }
                                    let entry = MedicationEntry(medicine: medicine, times: times)
                                    profile.medicationSchedule.append(entry)
                                }
                            }
                        }
                    }
                    profiles.append(profile)
                } else {
                    print("Błąd podczas odczytu profilu: \(error?.localizedDescription ?? "Nieznany błąd")")
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(profiles)
        }
    }


    //MARK: - Stworzenie profilu z danych
    func createProfile(name: String, surname: String, pictureType: String, completion: @escaping (Profile?, Error?) -> Void) {
        var ref: DocumentReference? = nil
        ref = db.collection("profiles").addDocument(data: [
            "name": name,
            "surname": surname,
            "pictureType": pictureType
        ]) { error in
            if let error = error {
                print("Błąd podczas tworzenia profilu: \(error.localizedDescription)")
                completion(nil, error)
            } else {
                print("Profil został utworzony pomyślnie w Firestore.")
                // Utworzenie nowego profilu z wygenerowanym ID
                let newProfile = Profile(uid: ref!.documentID, name: name, surname: surname, pictureType: pictureType)
                completion(newProfile, nil)
            }
        }
    }
    
    
  
    
    func deleteProfile(){
        
    }
    func updateProfile(){
        
    }
    
}
