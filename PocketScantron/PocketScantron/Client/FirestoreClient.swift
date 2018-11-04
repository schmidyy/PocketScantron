//
//  FirestoreClient.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-10-22.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation

import FirebaseFirestore
import FirebaseStorage

import Alamofire
import SwiftyJSON

struct FirestoreClient {
    static let db = Firestore.firestore()
    
    static func saveExam(_ exam: Exam, completion: @escaping() -> Void) {
        let questionsFields = exam.questions.map { ["number": $0.number, "answer": $0.selectedAnswer.rawValue] }
        let examFields: [String: Any] = [
            "id": exam.id,
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
                    completion()
                })
            } else {
                // Set user's first exam
                documentReference.setData(["exams": [examFields]], completion: { setError in
                    guard setError == nil else { return }
                    completion()
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
                        id: exam["id"] as! String,
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
    
    static func uploadImage(_ image: UIImage, completion: @escaping (_ url: String?) -> Void) {
        let imageID = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("\(imageID).jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.8) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error ?? "error")
                    completion(nil)
                }
                
                storageRef.downloadURL(completion: { (url, err) in
                    completion(url?.absoluteString)
                })
            }
        }
    }
    
    static func saveImage(url: String, examID: String, completion: @escaping() -> Void) {
        let fields: [String: Any] = [
            "url": url,
            "id": examID
            // num question
            // user id
        ]
    
        Alamofire.request(url, method: .post, parameters: fields, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            guard let data = response.data else { return }
            let json = JSON(data)
            print(json)
        }
    }
}
