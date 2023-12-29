//
//  ModelTests.swift
//  MediTrackerTests
//
//  Created by Agata Przykaza on 27/12/2023.
//

import XCTest
@testable import MediTracker

class ProfileTests: XCTestCase {

    var profile: Profile!
    var medicine: Medicine!

    override func setUp() {
        super.setUp()
        profile = Profile(uid: "1", name: "John", surname: "Doe", pictureType: "Profile1")
        medicine = Medicine(name: "Aspirin", dosage: 500, unit: "mg", type: "Tablet", hourPeriod: 8, frequency: 3, startHour: Date(), dayPeriod: 1, onEmptyStomach: false, delayMeds: 0, instructions: "Take after meals", interactions: [], reminder: true, isAntibiotic: false)
        
                
    }

    override func tearDown() {
        profile = nil
        medicine = nil
        super.tearDown()
    }

    func testAddMedication() {
        profile.addMedication(medicine, delay: 0)
        XCTAssertFalse(profile.medicationSchedule.isEmpty)
    }

    func testUpdateMedication() {
        profile.addMedication(medicine, delay: 0)
        let updatedMedicine = Medicine(name: "Ibuprofen", dosage: 400, unit: "mg", type: "Capsule", hourPeriod: 12, frequency: 2, startHour: Date(), dayPeriod: 1, onEmptyStomach: false, delayMeds: 0, instructions: "Take with water", interactions: [], reminder: true, isAntibiotic: false)
        updatedMedicine.setUid(id: medicine.uid)
        let updatedEntry = MedicationEntry(medicine: updatedMedicine, times: [Date()])
        profile.updateMed(med: updatedEntry)

        XCTAssertEqual(profile.medicationSchedule.first?.medicine.name, "Ibuprofen")
    }

    func testRemoveMedicationEntry_ExistingEntry() {
        let medicationEntry = MedicationEntry(medicine: medicine, times: [Date()])
            profile.medicationSchedule.append(medicationEntry)
            let medicineUID = medicine.uid.uuidString
            XCTAssertNotNil(profile.medicationSchedule.first { $0.medicine.uid.uuidString == medicineUID })

            profile.removeMedicationEntry(medicineUID: medicineUID)
            XCTAssertNil(profile.medicationSchedule.first { $0.medicine.uid.uuidString == medicineUID })
        }
    
    func testGetMedsList() {
     
        XCTAssertTrue(profile.medicationSchedule.isEmpty)
        XCTAssertTrue(profile.getMedsList().isEmpty)

      
        let medicine1 = Medicine(name: "Med1",  dosage: 400, unit: "mg", type: "Capsule", hourPeriod: 12, frequency: 2, startHour: Date(), dayPeriod: 1, onEmptyStomach: false, delayMeds: 0, instructions: "Take with water", interactions: [], reminder: true, isAntibiotic: false)
        let medicine2 = Medicine(name: "Med2",  dosage: 400, unit: "mg", type: "Capsule", hourPeriod: 12, frequency: 2, startHour: Date(), dayPeriod: 1, onEmptyStomach: false, delayMeds: 0, instructions: "Take with water", interactions: [], reminder: true, isAntibiotic: false)
        profile.medicationSchedule.append(MedicationEntry(medicine: medicine1, times: [Date()]))
        profile.medicationSchedule.append(MedicationEntry(medicine: medicine2, times: [Date()]))

        let medsList = profile.getMedsList()
        XCTAssertEqual(medsList.count, 2)
        XCTAssertTrue(medsList.contains { $0.name == "Med1" })
        XCTAssertTrue(medsList.contains { $0.name == "Med2" })
    }
    
    
    func testSetDelayMedsForMatchingWeekdays() {
        let medicine1 = Medicine(name: "Med1",  dosage: 400, unit: "mg", type: "Tabletka", hourPeriod: 12, frequency: 2, startHour: Date(), dayPeriod: 1, onEmptyStomach: false, delayMeds: 0, instructions: "Take with water", interactions: [], reminder: true, isAntibiotic: false)
        let medicine2 = Medicine(name: "Med2",  dosage: 400, unit: "ml", type: "Syrop", hourPeriod: 12, frequency: 2, startHour: Date(), dayPeriod: 1, onEmptyStomach: false, delayMeds: 0, instructions: "Take with water", interactions: [], reminder: true, isAntibiotic: false)
        let startHour = Calendar.current.startOfDay(for: Date())
        let medicineEntry1 = MedicationEntry(medicine: medicine1, times: [startHour])
        let medicineEntry2 = MedicationEntry(medicine: medicine2, times: [Calendar.current.date(byAdding: .day, value: 1, to: startHour)!])

        profile.medicationSchedule.append(medicineEntry1)
        profile.medicationSchedule.append(medicineEntry2)

        
        let newMedicine = Medicine(name: "NewMed", dosage: 400, unit: "mg", type: "Capsule", hourPeriod: 12, frequency: 2, startHour: Date(), dayPeriod: 1, onEmptyStomach: false, delayMeds: 0, instructions: "Take with water", interactions: [], reminder: true, isAntibiotic: false)
        let newMedicineEntry = MedicationEntry(medicine: newMedicine, times: [startHour])

        profile.setDelayMedsForMatchingWeekdays(newDelayMeds: 2.0, newMedicationEntry: newMedicineEntry)

        XCTAssertEqual(medicine1.delayMeds, 2)
        XCTAssertEqual(medicine2.delayMeds, 0) 
    }


    func testAdjustTimesForMatchingMedicationsAndWeekdays() {
        // Przygotowanie danych testowych
        let medicine1 = Medicine(name: "Med1",dosage: 400, unit: "mg", type: "Capsule", hourPeriod: 12, frequency: 2, startHour: Date(), dayPeriod: 1, onEmptyStomach: false, delayMeds: 0, instructions: "Take with water", interactions: [], reminder: true, isAntibiotic: false)
        let medicine2 = Medicine(name: "Med2", dosage: 400, unit: "mg", type: "Capsule", hourPeriod: 12, frequency: 2, startHour: Date(), dayPeriod: 1, onEmptyStomach: false, delayMeds: 0, instructions: "Take with water", interactions: [], reminder: true, isAntibiotic: false)
        let startHour = Calendar.current.startOfDay(for: Date())
        let medicineEntry1 = MedicationEntry(medicine: medicine1, times: [startHour])
        let medicineEntry2 = MedicationEntry(medicine: medicine2, times: [startHour])
        profile.medicationSchedule.append(medicineEntry1)
        profile.medicationSchedule.append(medicineEntry2)

        // Nowy lek z interakcją
        let newMedicine = Medicine(name: "NewMed", dosage: 400, unit: "mg", type: "Capsule", hourPeriod: 12, frequency: 2, startHour: Date(), dayPeriod: 1, onEmptyStomach: false, delayMeds: 0, instructions: "Take with water", interactions: ["Med1"], reminder: true, isAntibiotic: false)
        let newMedicationEntry = MedicationEntry(medicine: newMedicine, times: [startHour])
        

        profile.adjustTimesForMatchingMedicationsAndWeekdays(interactions: newMedicationEntry.medicine.interactions, delay: 2.0, newMedicationEntry: newMedicationEntry)

        // Testowanie, czy czasy medicine1 zostały dostosowane
        XCTAssertNotEqual(profile.medicationSchedule.first { $0.medicine.name == "Med1" }?.times, [startHour])
        
        // Testowanie, czy czasy medicine2 nie zostały zmienione
        XCTAssertEqual(profile.medicationSchedule.first { $0.medicine.name == "Med2" }?.times, [startHour])
    }

}


class MedicineTests: XCTestCase {

    var medicine: Medicine!

    override func setUp() {
        super.setUp()
        medicine = Medicine(name: "Aspirin", dosage: 500, unit: "mg", type: "Tablet", hourPeriod: 8, frequency: 3, startHour: Date(), dayPeriod: 1, onEmptyStomach: false, delayMeds: 0, instructions: "Take after meals", interactions: [], reminder: true, isAntibiotic: false)
    }

    override func tearDown() {
        medicine = nil
        super.tearDown()
    }

    func testCalculateNextDoses() {
        let doses = medicine.calculateNextDoses()
        XCTAssertFalse(doses.isEmpty)
    }

    func testIsOneWeekApart() {
        let date1 = Date()
        let date2 = Calendar.current.date(byAdding: .day, value: 8, to: date1)!
        XCTAssertTrue(medicine.isOneWeekApart(date1, date2))
    }

    
}


class UserTests: XCTestCase {

    var user: User!

    override func setUp() {
        super.setUp()
        user = User(uid: "1", username: "JohnDoe", email: "johndoe@example.com", surname: "Doe", gender: "Male")
    }

    override func tearDown() {
        user = nil
        super.tearDown()
    }

    func testUpdateName() {
        user.updateName("Jane")
        XCTAssertEqual(user.name, "Jane")
    }

    func testUpdateSurname() {
        user.updateSurname("Doe")
        XCTAssertEqual(user.surname, "Doe")
    }

    
}
