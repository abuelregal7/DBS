//
//  PaymentOptionsViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 22/04/2025.
//

import UIKit
import MoyasarSdk
import PassKit
import SwiftUI
import WebKit

enum PaymentType {
    case ApplePay
    case Online
    case CustomOnline
    case STC
}

protocol PaymentOptionsDelegate: AnyObject {
    func didCompletePayment(_ payment: ApiPayment)
    func didCompletePayment(_ message: String)
    func didFailPayment(_ message: String)
    func didCancelPayment()
    func didReceiveToken(_ token: ApiToken)
}

class PaymentOptionsViewController: BaseViewController, WKNavigationDelegate {
    
    let paymentService = PaymentService(apiKey: Constants.moyasarAPIKiy)
    
    var paymentType: PaymentType = .Online
    weak var delegate: PaymentOptionsDelegate?
    private var didHandleApplePay = false
    
    private var name: String?
    private var number: String?
    private var month: String?
    private var year: String?
    private var cvc: String?
    private var price: String?
    
    let metadata: [String: MetadataValue] = [
        "sdk": .stringValue("ios"),
        "order_id": .stringValue("ios_order_3214124"),
        "version": .floatValue(1.0),
        "isTest": .booleanValue(true),
        "language": .stringValue(Language.currentAppleLanguage())
    ]
    
    init(name: String?, number: String?, month: String?, year: String?, cvc: String?, price: String?) {
        self.name    =  name
        self.number  =  number
        self.month   =  month
        self.year    =  year
        self.cvc     =  cvc
        self.price   =  price
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if paymentType == .ApplePay {
            view.backgroundColor = .clear
        }else if paymentType == .CustomOnline {
            view.backgroundColor = .clear
        }else{
            view.backgroundColor = .white
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Dismiss first before presenting Apple Pay
        guard !didHandleApplePay else { return }
        
        if paymentType == .ApplePay {
            didHandleApplePay = true
            dismiss(animated: false) { [weak self] in
                guard let self = self else { return }
                let handler = ApplePayPaymentHandler(paymentRequest: self.createPaymentRequest(), price: price)
                handler.present()
            }
        }else if paymentType == .CustomOnline {
            didHandleApplePay = true
            let source = ApiCreditCardSource(
                name: name ?? "",
                number: number ?? "",
                month: month ?? "",
                year: year ?? "",
                cvc: cvc ?? "",
                manual: "false",
                saveCard: "false"
            )
            
            Task {
                showIndictor()
                do {
                    let paymentRequest = try ApiPaymentRequest(
                        paymentRequest: PaymentRequest(
                            apiKey: Constants.moyasarAPIKiy,
                            amount: price?.intValue ?? 0,
                            currency: "SAR",
                            description: "Flat White",
                            metadata: metadata
                        ),
                        callbackUrl: "https://sdk.moyasar.com/return",
                        source: ApiPaymentSource.creditCard(source)
                    )
                    
                    let payment = try await paymentService.createPayment(paymentRequest)
                    print(payment)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.startPaymentAuthProcessWithWebKit(payment)
                        //self.startPaymentAuthProcessWithHandlePayment(payment)
                        self.hideIndictor()
                    }
                } catch let error as MoyasarError {
                    hideIndictor()
                    print("Payment creation error: \(error)")

                    dismiss(animated: true) { [weak self] in
                        guard let self = self else { return }

                        if case let .apiError(apiError) = error {
                            switch apiError.errors {
                                
                            // Case 1: Multiple field-specific errors
                            case .multi(let dictOpt):
                                var messgae: [String] = []
                                if let dict = dictOpt {
                                    for (key, messagesOpt) in dict {
                                        if let messages = messagesOpt {
                                            for message in messages {
                                                let userFriendlyKey = self.mapFieldKeyToFriendlyName(key)
                                                let fullMessage = "\(userFriendlyKey): \(message)"
                                                messgae.append(fullMessage)
                                                print("❌ \(fullMessage)")
                                                //self.delegate?.didFailPayment(fullMessage)
                                            }
                                        }
                                    }
                                    self.delegate?.didFailPayment(messgae.joined(separator: ", "))
                                }

                            // Case 2: Single error message
                            case .single(let messageOpt):
                                if let message = messageOpt {
                                    print("❌ Error: \(message)")
                                    self.delegate?.didFailPayment(message)
                                }
                                
                            @unknown default:
                                self.delegate?.didFailPayment("An unknown error occurred.")
                            }
                        } else {
                            self.delegate?.didFailPayment("Unexpected error type.")
                        }
                    }
                } catch {
                    hideIndictor()
                    print("An unexpected error occurred: \(error)")
                    dismiss(animated: true) { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.didFailPayment(error.localizedDescription)
                    }
                    // Implement additional error handling as needed
                }
            }
            
        } else {
            showPaymentScreen()
        }
    }
    
    private func showPaymentScreen() {
        switch paymentType {
        case .ApplePay:
            // not called anymore
            break
            
        case .Online:
            let vc = CreditCardViewController(price: price)
            vc.delegate = delegate
            navigateTo(vc)
            
        case .CustomOnline:
            // not called anymore
            break
            
        case .STC:
            let vc = STCPaymentViewController(price: price)
            vc.delegate = delegate
            navigateTo(vc)
            
        }
    }
    
    private func navigateTo(_ vc: UIViewController) {
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vc.view)
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: view.topAnchor),
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        vc.didMove(toParent: self)
    }
    
    private func createPaymentRequest() -> PaymentRequest {
        
        try! PaymentRequest(
            apiKey: Constants.moyasarAPIKiy,
            amount: price?.intValue ?? 0,
            currency: "SAR",
            description: "Payment",
            metadata: metadata
        )
    }
    
    func startPaymentAuthProcessWithWebKit(_ payment: ApiPayment) {
        guard payment.isInitiated() else {
            // Handle case
            // Payment status could be paid, failed, authorized, etc...
            return
        }
            
        guard case let .creditCard(source) = payment.source else {
            // Handle error
            return
        }
            
        guard let transactionUrl = source.transactionUrl, let url = URL(string: transactionUrl) else {
            // Handle error
            return
        }
          
        showWebView(url)
        
    }
    
    func startPaymentAuthProcessWithHandlePayment(_ payment: ApiPayment) {
        let result = PaymentResult.completed(payment)  // Assuming payment object is the successful result
        handlePaymentResult(result)
        
    }
    
    private func handlePaymentResult(_ result: PaymentResult) {
        switch result {
        case .completed(let payment):
            // Process completed payment
            delegate?.didCompletePayment(payment)
        case .saveOnlyToken(let token):
            // Handle saved token only (maybe for later use)
            delegate?.didReceiveToken(token)
        case .failed(let error):
            // Handle failed payment
            delegate?.didFailPayment(error.localizedDescription)
        case .canceled:
            // Handle canceled payment
            delegate?.didCancelPayment()
        @unknown default:
            // Handle unknown result case
            delegate?.didFailPayment("Unknown result")
        }
    }
    
    func showWebView(_ url: URL) {
        print("WebView is about to be shown with URL: \(url)")
        // Create and configure the WKWebView
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        // Set constraints to make the web view fill the parent view
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        webView.layoutIfNeeded()
        
        // Load the transaction URL
        let request = URLRequest(url: url)
        webView.load(request)
        
        // Set the navigation delegate to handle events
        webView.navigationDelegate = self
        
        print("WebView should now be visible.")
    }
    
    func dismissWebView(callBacks: (() -> Void)?) {
        dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            callBacks?()
        }
    }
    
    // MARK: - Payment Error Handling

    func handleApiError(_ error: MoyasarSdk.ApiError) {
        switch error.errors {
        case .multi(let dictionaryOpt):
            if let dictionary = dictionaryOpt {
                for (key, messagesOpt) in dictionary {
                    if let messages = messagesOpt {
                        for message in messages {
                            let userFriendlyKey = mapFieldKeyToFriendlyName(key)
                            print("❌ \(userFriendlyKey): \(message)")
                        }
                    }
                }
            }
            
        case .single(let error):
            mapFieldKeyToFriendlyName(error ?? "")
        @unknown default:
            break
        }

        // Also show the general error message if available
        if let generalMessage = error.message {
            print("💬 General Error Message: \(generalMessage)")
        }
    }

    func mapFieldKeyToFriendlyName(_ field: String) -> String {
        switch field {
        case "source.number":
            return "Card Number"
        case "source.month":
            return "Expiry Month"
        case "source.year":
            return "Expiry Year"
        case "source.cvc":
            return "CVV"
        case "source.name":
            return "Cardholder Name"
        default:
            return field
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(webView.url?.absoluteString)
        print("Web page started loading")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url?.absoluteString)
        print("Web page loaded successfully")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(webView.url?.absoluteString)
        print("Failed to load web page with error: \(error.localizedDescription)")
        dismissWebView { [weak self] in
            guard let self = self else { return }
            self.delegate?.didFailPayment(error.localizedDescription)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            print("🌐 Navigating to: \(url.absoluteString)")
            
            if url.absoluteString.contains("status=paid") || url.absoluteString.contains("status=failed") {
                // Do your status parsing and dismiss logic here
                handlePaymentResult(from: url)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    func handlePaymentResult(from url: URL) {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems,
           let status = queryItems.first(where: { $0.name == "status" })?.value {
            
            switch status.lowercased() {
            case "paid":
                print("✅ Payment was successful!")
                dismissWebView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didCompletePayment("✅ Payment was successful!")
                }
            case "failed":
                let message = queryItems.first(where: { $0.name == "message" })?.value ?? "Payment failed."
                print("❌ Payment failed: \(message)")
                let decodedMessage = message.removingPercentEncoding ?? message
                
                // Replace + with spaces to make it more readable
                let puttyMessage = decodedMessage.replacingOccurrences(of: "+", with: " ")
                dismissWebView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailPayment("❌ \(puttyMessage)")
                }
            default:
                print("ℹ️ Payment status: \(status)")
            }
        }
    }
    
}
