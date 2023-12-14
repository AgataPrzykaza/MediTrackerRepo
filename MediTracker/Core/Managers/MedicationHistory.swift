
import Foundation
import FirebaseFirestore


class MedicationHistoryManager {
   
    let db = Firestore.firestore()

    func addMedicationHistoryEntry(profileId: String, medicationId: UUID, scheduledTime: Date, actualTimeTaken: Date, completion: @escaping (Error?) -> Void) {
        let medicationHistoryData: [String: Any] = [
            "profileId": profileId,
            "medicationId": medicationId.uuidString,
            "scheduledTime": Timestamp(date: scheduledTime),
            "actualTimeTaken": Timestamp(date: actualTimeTaken)
        ]

        db.collection("medicationHistory").addDocument(data: medicationHistoryData) { error in
            if let error = error {
                print("Błąd podczas dodawania wpisu historii leków: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Wpis historii leków został pomyślnie utworzony w Firestore.")
                completion(nil)
            }
        }
    }

    func isMedicationTaken(profileId: String, medicationId: UUID, at scheduledTime: Date, completion: @escaping (Bool) -> Void) {
        db.collection("medicationHistory")
            .whereField("profileId", isEqualTo: profileId)
            .whereField("medicationId", isEqualTo: medicationId.uuidString)
            .whereField("scheduledTime", isEqualTo: Timestamp(date: scheduledTime))
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Błąd podczas pobierania danych: \(error.localizedDescription)")
                    completion(false)
                } else if let documents = snapshot?.documents, !documents.isEmpty {
                    completion(true)
                } else {
                    completion(false)
                }
            }
    }

    
}

