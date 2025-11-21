//
//  TabsEndPoints.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation
import Alamofire

enum TabsEndPoints: Endpoint {
    
    //MARK: Cases
    case homeSlider
    case homeRooms
    case homeGifts
    case homeCompletedRooms
    case allRoomes(allRoomesRequest: AllRoomesRequest)
    case myAddresses
    case addAddress(addAddressRequest: AddAddressRequest)
    case deleteAddress(deleteAddressRequest: DeleteAddressRequest)
    case makeAddressDefualt(makeAddressDefualtRequest: MakeAddressDefualtRequest)
    case profile
    case updateProfile(updateProfileRequest: UpdateProfileRequest)
    case logout
    case deleteAccount
    case contactUs(contactUsRequest: ContactUsRequest)
    case roomDetails(roomDetailsRequest: RoomDetailsRequest)
    case myOrderes(myOrderesRequest: MyOrderesRequest)
    case roomItems(roomItemsRequest: RoomItemsRequest)
    case myOrderDetails(showOrdereRequest: ShowOrdereRequest)
    case aboutUs
    case termsContidtions
    case setting
    case placeOrder(placeOrderRequest: PlaceOrderRequest)
    
    //MARK: Paths
    var path: String {
        switch self {
        case .homeSlider:
            return "client/home/sliders"
        case .homeRooms:
            return "client/home/rooms"
        case .homeGifts:
            return "client/home/gifts"
        case .homeCompletedRooms:
            return "client/home/complete_rooms"
        case .allRoomes:
            return "client/rooms"
        case .myAddresses:
            return "client/addresses"
        case .addAddress:
            return "client/addresses/store"
        case .deleteAddress:
            return "client/addresses/delete"
        case .makeAddressDefualt:
            return "client/addresses/make-default"
        case .profile:
            return "client/auth/profile"
        case .updateProfile:
            return "client/auth/profile/update"
        case .logout:
            return "client/auth/logout"
        case .deleteAccount:
            return "client/delete-account"
        case .contactUs:
            return "client/contact-us"
        case .roomDetails:
            return "client/rooms/details"
        case .myOrderes:
            return "client/orders/my-orders"
        case .roomItems:
            return "client/rooms/items"
        case .myOrderDetails(let showOrdereRequest):
            return "client/orders/show/\(showOrdereRequest.id ?? 0)"
        case .aboutUs:
            return "client/page/about"
        case .termsContidtions:
            return "client/page/terms"
        case .setting:
            return "client/settings"
        case .placeOrder:
            return "client/orders/place"
        }
    }
    
    //MARK: Method
    var method: HTTPMethod {
        switch self {
        case .homeSlider, .homeRooms, .homeGifts, .homeCompletedRooms, .allRoomes, .myAddresses, .profile, .logout, .deleteAccount, .roomDetails, .myOrderes, .roomItems, .myOrderDetails, .aboutUs, .termsContidtions, .setting:
            return .get
        case .addAddress, .makeAddressDefualt, .updateProfile, .contactUs, .placeOrder:
            return .post
        case .deleteAddress:
            return .delete
        }
    }
    
    //MARK: Params
    var parameters: Parameters? {
        switch self {
        case .allRoomes(let allRoomesRequest):
            return allRoomesRequest.asDictionary()
        case .addAddress(let addAddressRequest):
            return addAddressRequest.asDictionary()
        case .deleteAddress(let deleteAddressRequest):
            return deleteAddressRequest.asDictionary()
        case .makeAddressDefualt(let makeAddressDefualtRequest):
            return makeAddressDefualtRequest.asDictionary()
        case .updateProfile(let updateProfileRequest):
            return updateProfileRequest.asDictionary()
        case .contactUs(let contactUsRequest):
            return contactUsRequest.asDictionary()
        case .roomDetails(let roomDetailsRequest):
            return roomDetailsRequest.asDictionary()
        case .myOrderes(let myOrderesRequest):
            return myOrderesRequest.asDictionary()
        case .roomItems(let roomItemsRequest):
            return roomItemsRequest.asDictionary()
        case .placeOrder(let placeOrderRequest):
            return placeOrderRequest.asDictionary()
        default:
            return [:]
        }
    }
    
    //MARK: Encoding
    var encoding: ParameterEncoding {
        switch self {
        case .homeSlider, .homeRooms, .homeGifts, .homeCompletedRooms, .allRoomes, .myAddresses, .deleteAddress, .profile, .logout, .deleteAccount, .roomDetails, .myOrderes, .roomItems, .myOrderDetails, .aboutUs, .termsContidtions, .setting:
            return URLEncoding.default
        case .addAddress, .makeAddressDefualt, .updateProfile, .contactUs, .placeOrder:
            return JSONEncoding.default
        }
    }
}
