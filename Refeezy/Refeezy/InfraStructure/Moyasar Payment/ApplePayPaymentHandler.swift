//
//  ApplePayPaymentHandler.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 22/04/2025.
//

import Foundation
import UIKit
import MoyasarSdk
import PassKit
import SwiftUI

class ApplePayPaymentHandler: NSObject, PKPaymentAuthorizationControllerDelegate {
    var applePayService: ApplePayService?
    var controller: PKPaymentAuthorizationController?
    var items = [PKPaymentSummaryItem]()
    var networks: [PKPaymentNetwork] = [
        .amex,
        .mada,
        .masterCard,
        .visa
    ]
    let paymentRequest: PaymentRequest
    
    private var price: String?
    
    init(paymentRequest: PaymentRequest, price: String?) {
        self.paymentRequest = paymentRequest
        self.price   =  price
        do {
            applePayService = try ApplePayService(apiKey: Constants.moyasarAPIKiy)
        } catch {
            print("Failed to initialize ApplePayService: \(error)")
        }
    }
    
    func present() {
        let floatAmount: Float = price?.floatValue ?? 0.0
        let amountString = String(format: "%.2f", floatAmount)
        let amountDecimal = NSDecimalNumber(string: amountString)
        
        items = [
            PKPaymentSummaryItem(label: "Moyasar", amount: amountDecimal, type: .final)
        ]
        
        let request = PKPaymentRequest()
        
        request.paymentSummaryItems = items
        request.merchantIdentifier = Constants.merchantIdentifier
        request.countryCode = "SA"
        request.currencyCode = "SAR"
        request.supportedNetworks = networks
        request.merchantCapabilities = [
            .threeDSecure,
            .credit,
            .debit
        ]
        
        controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller?.delegate = self
        controller?.present(completion: { (p: Bool) in
            print("Presented: " + (p ? "Yes" : "No"))
        })
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        Task {
            do {
                if let applePayService = applePayService {
                    let paymentResult = try await applePayService.authorizePayment(request: paymentRequest, token: payment.token)
                    // Handle the success case
                    print("Got payment")
                    print(paymentResult.status)
                    print(paymentResult.id)
                    completion(.success)
                } else {
                    // Handle the case where applePayService is nil
                    print("ApplePayService is not initialized")
                    completion(.failure)
                }
            } catch {
                // Handle the error case
                print(error)
                completion(.failure)
            }
        }
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        print("Apple Pay sheet finished")
        // Explicitly dismiss the Apple Pay sheet in case it hasn't been dismissed
        controller.dismiss(completion: {
            print("Apple Pay sheet dismissed")
        })
    }
    
}
