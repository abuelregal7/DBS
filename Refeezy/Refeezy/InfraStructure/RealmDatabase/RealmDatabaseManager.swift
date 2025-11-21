//
//  RealmDatabaseManager.swift
//  New-MVVM-Demo
//
//  Created by Ahmed Abo Al-Regal on 05/03/2025.
//

//import Foundation
//import RealmSwift
//import Combine
//
//class RealmDatabaseManager {
//    
//    /// Save object to Realm
//    func save<T: Object>(_ object: T) -> AnyPublisher<Void, NetworkError> {
//        return Future<Void, NetworkError> { promise in
//            DispatchQueue.global(qos: .background).async {
//                do {
//                    let realm = try Realm()
//                    try realm.write {
//                        realm.add(object, update: .all)
//                    }
//                    DispatchQueue.main.async {
//                        promise(.success(()))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        promise(.failure(.general("Failed to save data: \(error.localizedDescription)")))
//                    }
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    /// Fetch objects from Realm
//    func fetch<T: Object>(_ objectType: T.Type, predicate: NSPredicate? = nil) -> AnyPublisher<[T], NetworkError> {
//        return Future<[T], NetworkError> { promise in
//            DispatchQueue.global(qos: .background).async {
//                do {
//                    let realm = try Realm()
//                    var results = realm.objects(objectType)
//                    if let predicate = predicate {
//                        results = results.filter(predicate)
//                    }
//                    let safeResults = Array(results) // Convert to an array before switching threads
//                    DispatchQueue.main.async {
//                        promise(.success(safeResults))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        promise(.failure(.general("Failed to fetch data: \(error.localizedDescription)")))
//                    }
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    /// Delete object from Realm
//    func delete<T: Object>(_ object: T) -> AnyPublisher<Void, NetworkError> {
//        return Future<Void, NetworkError> { promise in
//            DispatchQueue.global(qos: .background).async {
//                do {
//                    let realm = try Realm()
//                    try realm.write {
//                        realm.delete(object)
//                    }
//                    DispatchQueue.main.async {
//                        promise(.success(()))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        promise(.failure(.general("Failed to delete data: \(error.localizedDescription)")))
//                    }
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    /// Delete all objects of a type
//    func deleteAll<T: Object>(_ objectType: T.Type) -> AnyPublisher<Void, NetworkError> {
//        return Future<Void, NetworkError> { promise in
//            DispatchQueue.global(qos: .background).async {
//                do {
//                    let realm = try Realm()
//                    let objects = realm.objects(objectType)
//                    try realm.write {
//                        realm.delete(objects)
//                    }
//                    DispatchQueue.main.async {
//                        promise(.success(()))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        promise(.failure(.general("Failed to delete all data: \(error.localizedDescription)")))
//                    }
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//}

