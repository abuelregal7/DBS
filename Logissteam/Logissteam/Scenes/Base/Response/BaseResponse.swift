//
//  BaseResponse.swift
//  Wala
//
//  Created by Ibrahim Nabil on 05/02/2024.
//

import Foundation

protocol BaseCodable: Codable {
    var status: Bool? { get }
    var code: Int? { get }
    var message: String? { get }
    var isSuccess: Bool { get }
}

extension BaseCodable {
    var isSuccess: Bool {
        return code == 200
    }
}

struct ContentString: BaseCodable {
    var status: Bool?
    var code: Int?
    var message: String?
    var content: String?
}

struct BaseDataModel<T: Codable>: BaseCodable {
    var status: Bool?
    var code: Int?
    var message: String?
    var content: T?
}
