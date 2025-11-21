//
//  TabsEndPoint.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Alamofire

enum TabsEndPoint: Endpoint {
    
    //MARK: Cases
    case home(homeRequest: HomeDealsRequest)
    case search(categorySearchRequest: CategorySearchRequest)
    case contactUs(contactUsRequest: ContactUsRequest)
    case profile
    case updateProfile(updateProfileRequest: UpdateProfileRequest)
    case aboutUs
    case termsContidtions
    case privacyPolicy
    case dealDetails(dealDetailsRequest: DealDetailsRequest)
    case myDeals(myDealsRequest: MyDealsRequest)
    case buyPlans(buyPlansRequest: BuyPlansRequest)
    case dealsPayments(dealsPaymentsRequest: DealsPaymentsRequest)
    case dealsContracts(dealsContractsRequest: DealsContractsRequest)
    case transferOwnership(transferOwnershipRequest: TransferOwnershipRequest)
    case dealsReservation(dealsReservationRequest: DealsReservationRequest)
    
    //MARK: Paths
    var path: String {
        switch self {
        case .home:
            return "client/home"
        case .search:
            return "client/home/search"
        case .contactUs:
            return "client/app/contact-us"
        case .profile:
            return "client/auth/profile"
        case .updateProfile:
            return "client/auth/profile/update"
        case .aboutUs:
            return "client/app/pages/about"
        case .termsContidtions:
            return "client/app/pages/terms"
        case .privacyPolicy:
            return "client/app/pages/privacy"
        case .dealDetails:
            return "client/deals/details"
        case .myDeals:
            return "client/deals/my"
        case .buyPlans:
            return "client/deals/buy_plans"
        case .dealsPayments:
            return "client/deals/my/payments"
        case .dealsContracts:
            return "client/deals/my/contracts"
        case .transferOwnership:
            return "client/deals/owner-transfer"
        case .dealsReservation:
            return "client/deals/reservation"
        }
    }
    
    //MARK: Method
    var method: HTTPMethod {
        switch self {
        case .contactUs, .updateProfile, .transferOwnership, .dealsReservation:
            return .post
        case .home, .search, .profile, .aboutUs, .termsContidtions, .privacyPolicy, .dealDetails, .myDeals, .buyPlans, .dealsPayments, .dealsContracts:
            return .get
        }
    }
    
    //MARK: Params
    var parameters: Parameters? {
        switch self {
        case .contactUs(let contactUsRequest):
            return contactUsRequest.asDictionary()
        case .updateProfile(let updateProfileRequest):
            return updateProfileRequest.asDictionary()
        case .home(let homeRequest):
            return homeRequest.asDictionary()
        case .search(let categorySearchRequest):
            return categorySearchRequest.asDictionary()
        case .dealDetails(let dealDetailsRequest):
            return dealDetailsRequest.asDictionary()
        case .myDeals(let myDealsRequest):
            return myDealsRequest.asDictionary()
        case .buyPlans(let buyPlansRequest):
            return buyPlansRequest.asDictionary()
        case .dealsPayments(let dealsPaymentsRequest):
            return dealsPaymentsRequest.asDictionary()
        case .dealsContracts(let dealsContractsRequest):
            return dealsContractsRequest.asDictionary()
        case .transferOwnership(let transferOwnershipRequest):
            return transferOwnershipRequest.asDictionary()
        case .dealsReservation(let dealsReservationRequest):
            return dealsReservationRequest.asDictionary()
        default:
            return [:]
        }
    }
    
    //MARK: Encoding
    var encoding: ParameterEncoding {
        switch self {
        case .contactUs, .updateProfile, .transferOwnership, .dealsReservation:
            return JSONEncoding.default
        case .home, .search, .profile, .aboutUs, .termsContidtions, .privacyPolicy, .dealDetails, .myDeals, .buyPlans, .dealsPayments, .dealsContracts:
            return URLEncoding.default
        }
    }
}
