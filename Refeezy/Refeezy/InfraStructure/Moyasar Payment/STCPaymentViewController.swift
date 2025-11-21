//
//  STCPaymentViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 22/04/2025.
//

import UIKit
import MoyasarSdk
import PassKit
import SwiftUI

class STCPaymentViewController: UIViewController {
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
        presentSTCPayView()
    }
    
    private func presentSTCPayView() {
        let stcPayView = STCPayView(paymentRequest: createSTCPaymentRequest()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let payment):
                switch payment.status {
                case .initiated:
                    // Handle initiated status
                    print("Payment initiated. Awaiting further action.")
                    dismissSTCCardView { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.didCompletePayment("Payment initiated. Awaiting further action.")
                    }
                case .paid:
                    // Handle paid status
                    print("Payment successful. Amount: \(payment.amountFormat)")
                    dismissSTCCardView { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.didCompletePayment("✅ Payment was successful!")
                    }
                case .authorized:
                    // Handle authorized status
                    print("Payment authorized. Awaiting capture.")
                    dismissSTCCardView { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.didCompletePayment("Payment authorized. Awaiting capture.")
                    }
                case .failed:
                    // Handle failed status
                    print("===========================================")
                    print(payment.source)
                    if let creditCardSource = payment.source as? ApiSTCPaySource {
                        if let message = creditCardSource.message {
                            print("❌ Payment failed: \(message)")
                        } else {
                            print("❌ Payment failed with no message.")
                        }
                    }
                    dismissSTCCardView { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.didFailPayment("❌ Payment failed.")
                    }
                case .refunded:
                    // Handle refunded status
                    print("Payment refunded. Amount: \(payment.refundedFormat ?? "")")
                    dismissSTCCardView { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.didCompletePayment("Payment refunded. Amount: \(payment.refundedFormat ?? "")")
                    }
                case .captured:
                    // Handle captured status
                    print("Payment captured. Amount: \(payment.capturedFormat ?? "")")
                    dismissSTCCardView { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.didCompletePayment("Payment captured. Amount: \(payment.capturedFormat ?? "")")
                    }
                case .voided:
                    // Handle voided status
                    print("Payment voided.")
                    dismissSTCCardView { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.didCompletePayment("Payment voided.")
                    }
                case .verified:
                    // Handle verified status
                    print("Payment verified.")
                    dismissSTCCardView { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.didCompletePayment("Payment verified.")
                    }
                @unknown default:
                    print("ℹ️ Payment status: \(payment.status)")
                    dismissSTCCardView { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.didCompletePayment("ℹ️ Payment status: \(payment.status)")
                    }
                }
                
            case .failure(let error):
                dismissSTCCardView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailPayment(error.localizedDescription)
                }
            }
        }
        
        let hostingVC = UIHostingController(rootView: stcPayView)
        addChild(hostingVC)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hostingVC.view)
        
        NSLayoutConstraint.activate([
            hostingVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingVC.didMove(toParent: self)
    }
    
    private func createSTCPaymentRequest() -> PaymentRequest {
        try! PaymentRequest(
            apiKey: Constants.moyasarAPIKiy,
            amount: price?.intValue ?? 0,
            currency: "SAR",
            description: "STC Pay",
            metadata: metadata
        )
    }
    
    func dismissSTCCardView(callBacks: (() -> Void)?) {
        dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            callBacks?()
        }
    }
    
}
