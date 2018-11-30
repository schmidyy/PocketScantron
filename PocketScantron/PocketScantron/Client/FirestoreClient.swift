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
    
    static func saveImage(url: String, numQuestions: Int, completion: @escaping(_ response: ResultResponse?) -> Void) {
        let url = "https://us-central1-pocketscantron.cloudfunctions.net/documentScore?url=\(url)&numQuestions=\(numQuestions)"
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data else {
                completion(nil)
                return
            }
            let json = JSON(data)
            completion(ResultResponse(withDictionary: json))
        }
    }
}
