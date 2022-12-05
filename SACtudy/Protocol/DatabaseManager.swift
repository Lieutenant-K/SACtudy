//
//  RealmManager.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/02.
//

import Foundation
import RealmSwift

protocol DatabaseManager {
    
    associatedtype Data: Object
        
    func fetchData(key: String) -> Data?
    func saveData(data: Data) -> Data
    
}

extension DatabaseManager {
    
    var realmPath: String {
        realm.configuration.fileURL!.path
    }
    
    private var realm: Realm {
        try! Realm()
    }
    
    func fetchData(key: String) -> Data? {
        return realm.object(ofType: Data.self, forPrimaryKey: key)
    }
    
    @discardableResult
    func saveData(data: Data) -> Data {
        do {
            try realm.write({
                realm.add(data, update: .modified)
            })
        } catch {
            print(error)
        }
        return data
    }
    
    func updateData(completion: @escaping () -> ()){
        do {
            try realm.write({
                completion()
            })
        } catch {
            print(error)
        }
    }

}
