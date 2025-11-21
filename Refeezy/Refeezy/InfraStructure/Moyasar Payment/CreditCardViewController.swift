//
//  CreditCardViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 22/04/2025.
//

import UIKit
import MoyasarSdk
import PassKit
import SwiftUI

class CreditCardViewController: UIViewController {
    
    weak var delegate: PaymentOptionsDelegate?
    private var price: String?
    
    let metadata: [String: MetadataValue] = [
        "sdk": .stringValue("ios"),
        "order_id": .stringValue("ios_order_3214124"),
        "version": .floatValue(1.0),
        "isTest": .booleanValue(true),
        "language": .stringValue(Language.currentAppleLanguage())
    ]
    
    init(price: String?) {
        self.price   =  price
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCardPayment()
    }
    
    private func setupCardPayment() {
        let cardView = CreditCardView(request: createPaymentRequest(), callback: handlePaymentResult)
        let hostingController = UIHostingController(rootView: cardView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
    
    private func createPaymentRequest() -> PaymentRequest {
        try! PaymentRequest(
            apiKey: Constants.moyasarAPIKiy,
            amount: price?.intValue ?? 0,
            currency: "SAR",
            description: "Credit Card Payment",
            metadata: metadata
        )
    }
    
    private func handlePaymentResult(_ result: PaymentResult) {
        switch result {
        case .completed(let payment):
            print(payment)
            switch payment.status {
            case .initiated:
                // Handle initiated status
                print("Payment initiated. Awaiting further action.")
                dismissCardView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didCompletePayment("Payment initiated. Awaiting further action.")
                }
            case .paid:
                // Handle paid status
                print("Payment successful. Amount: \(payment.amountFormat)")
                dismissCardView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didCompletePayment("✅ Payment was successful!")
                }
            case .authorized:
                // Handle authorized status
                print("Payment authorized. Awaiting capture.")
                dismissCardView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didCompletePayment("Payment authorized. Awaiting capture.")
                }
            case .failed:
                // Handle failed status
                print("===========================================")
                print(payment.source)
                if let creditCardSource = payment.source as? ApiCreditCardSource {
                    if let message = creditCardSource.message {
                        print("❌ Payment failed: \(message)")
                    } else {
                        print("❌ Payment failed with no message.")
                    }
                }
                dismissCardView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailPayment("❌ Payment failed.")
                }
            case .refunded:
                // Handle refunded status
                print("Payment refunded. Amount: \(payment.refundedFormat ?? "")")
                dismissCardView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didCompletePayment("Payment refunded. Amount: \(payment.refundedFormat ?? "")")
                }
            case .captured:
                // Handle captured status
                print("Payment captured. Amount: \(payment.capturedFormat ?? "")")
                dismissCardView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didCompletePayment("Payment captured. Amount: \(payment.capturedFormat ?? "")")
                }
            case .voided:
                // Handle voided status
                print("Payment voided.")
                dismissCardView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didCompletePayment("Payment voided.")
                }
            case .verified:
                // Handle verified status
                print("Payment verified.")
                dismissCardView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didCompletePayment("Payment verified.")
                }
            @unknown default:
                print("ℹ️ Payment status: \(payment.status)")
                dismissCardView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didCompletePayment("ℹ️ Payment status: \(payment.status)")
                }
            }
        case .saveOnlyToken(let token):
            dismissCardView { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveToken(token)
            }
        case .failed(let error):
            dismissCardView { [weak self] in
                guard let self = self else { return }
                self.delegate?.didFailPayment(error.localizedDescription)
            }
        case .canceled:
            dismissCardView { [weak self] in
                guard let self = self else { return }
                self.delegate?.didCancelPayment()
            }
        @unknown default:
            dismissCardView { [weak self] in
                guard let self = self else { return }
                self.delegate?.didFailPayment("Unknown result")
            }
        }
    }
    
    func dismissCardView(callBacks: (() -> Void)?) {
        dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            callBacks?()
        }
    }
    
}
