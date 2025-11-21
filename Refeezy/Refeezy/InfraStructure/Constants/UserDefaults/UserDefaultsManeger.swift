//
//  UserDefaultsManeger.swift
//  BaseProgect
//
//  Created by Restart Technology on 14/09/2022.
//

import Foundation

// MARK: - ...  Defaults properties
var UD: Defaults {
    if Defaults.Static.instance == nil {
        Defaults.Static.instance = Defaults()
    }
    return Defaults.Static.instance!
}

// MARK: - ...  Defaults properties
internal class Defaults {
    
    struct Static {
        static var instance: Defaults?
    }
    
    @StoredDefaults("AccessToken")
    var accessToken: String?
    
    @StoredDefaults("user")
    var user: VerificationCodeUserData?
    
    @StoredDefaults("address")
    var address: MyAddressesData?
    
    @StoredDefaults("FCM")
    var FCMToken: String?
    
}
