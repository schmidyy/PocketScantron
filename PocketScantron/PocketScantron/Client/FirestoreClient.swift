//
//  FirestoreClient.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-10-22.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FirestoreClient {
    static let db = Firestore.firestore()
    
    static func saveExam(_ exam: Exam) {
        let questionsFields = exam.questions.map { ["number": $0.number, "answer": $0.selectedAnswer.rawValue] }
        let examFields: [String: Any] = [
            "id": NSUUID().uuidString,
            "name": exam.name,
            "answersPerQuestion": exam.answersPerQuestion,
            "questions": questionsFields
        ]
        
        let documentReference = db.collection("users").document(deviceID)
        documentReference.getDocument { documentSnapshot, error in
            guard error == nil else { return }
            if let document = documentSnapshot, document.exists {
                // Update existing user's exams
                documentReference.updateData(["exams": FieldValue.arrayUnion([examFields])], completion: { updateError in
                    guard updateError == nil else { return }
                    //TODO: Handle update completion
                })
            } else {
                // Set user's first exam
                documentReference.setData(["exams": [examFields]], completion: { setError in
                    guard setError == nil else { return }
                    //TODOL Handle set completion
                })
            }
        }
    }
    
    static func savedExams(completion: @escaping(_ coins: [Exam]?) -> Void) {
        let documentReference = db.collection("users").document(deviceID)
        
        documentReference.getDocument { documentSnapshot, error in
            guard let document = documentSnapshot, document.exists, error == nil else {
                completion(nil)
                return
            }
            if let examData = document.data()?["exams"] as? [[String: Any]] {
                var fetchedExams: [Exam] = []
                for exam in examData {
                    let questions = (exam["questions"] as! [[String: Any]]).map { question in
                        Question(
                            number: question["number"] as! Int,
                            selectedAnswer: Answer(rawValue: question["answer"] as! String)!
                        )
                        
                    }
                    let newExam = Exam(
                        name: exam["name"] as! String,
                        questions: questions,
                        answersPerQuestion: exam["answersPerQuestion"] as! Int
                    )
                    fetchedExams.append(newExam)
                }
                completion(fetchedExams)
            }
        }
    }
}
