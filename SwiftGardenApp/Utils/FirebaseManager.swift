//
//  FirebaseManager.swift
//  SwiftGardenApp
//
//  Created by Yugo Sugiyama on 2023/08/02.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftGardenSecrets
import SwiftGardenCore
import FirebaseStorage

struct FirebaseManager {
    static let db = Firestore.firestore()
    
    static func fetchList(date: Date = Date()) async throws -> [FirestoreDataModel] {
        //        return FirestoreDataModel.mocks
        let field = "timestamp"
        return try await db.collection(Secrets.Firebase.Firestore.collectionId)
            .whereField(field, from: date)
            .order(by: field, descending: false)
            .getDocuments().documents
            .compactMap { try $0.data(as: FirestoreDataModel.self) }
    }
    
    static func fetchList(fromDate: Date, endDate: Date) async throws -> [FirestoreDataModel] {
        //        return FirestoreDataModel.mocks
        let field = "timestamp"
        return try await db.collection(Secrets.Firebase.Firestore.collectionId)
            .whereField(field, from: fromDate, end: endDate)
            .order(by: field, descending: false)
            .getDocuments().documents
            .compactMap { try $0.data(as: FirestoreDataModel.self) }
    }
    
    static func getImageURL(pathName: String) async throws -> URL {
        //        return FirestoreDataModel.mock.imageURL
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let starsRef = storageRef.child(pathName)
        return try await starsRef.downloadURL()
    }
}

// Ref: https://medium.com/@karsonbraaten/swift-and-firestore-query-for-fields-with-todays-date-d07bea56c79d
extension CollectionReference {
    func whereField(_ field: String, from date: Date) -> Query {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        guard let start = calendar.date(from: DateComponents(
            year: components.year,
            month: components.month,
            day: components.day,
            hour: 0,
            minute: 0,
            second: 0
        )),
              let end = calendar.date(from: DateComponents(
                year: components.year,
                month: components.month,
                day: (components.day ?? 0) + 1,
                hour: 0,
                minute: 0,
                second: 0
              )) else {
            fatalError("Could not find start date or calculate end date.")
        }
        return whereField(field, isGreaterThan: start).whereField(field, isLessThan: end)
    }
    
    func whereField(_ field: String, from fromDate: Date, end endDate: Date) -> Query {
        let calendar = Calendar(identifier: .gregorian)
        let fromComponents = calendar.dateComponents([.year, .month, .day], from: fromDate)
        let endComponents = calendar.dateComponents([.year, .month, .day], from: endDate)
        
        guard let start = calendar.date(from: DateComponents(
            year: fromComponents.year,
            month: fromComponents.month,
            day: fromComponents.day,
            hour: 0,
            minute: 0,
            second: 0
        )),
              let end = calendar.date(from: DateComponents(
                year: endComponents.year,
                month: endComponents.month,
                day: (endComponents.day ?? 0) + 1,
                hour: 0,
                minute: 0,
                second: 0
              )) else {
            fatalError("Could not find start date or calculate end date.")
        }
        
        return whereField(field, isGreaterThan: start).whereField(field, isLessThan: end)
    }
}
