//
//  AddAddressRequest.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation

struct AddAddressRequest: Codable {
    var address: String?
    var city: String?
    var postal_code: String? = "12121"
    var phone: String?
    var lat: String? = "12.21212"
    var lng: String? = "13.32323"
}
