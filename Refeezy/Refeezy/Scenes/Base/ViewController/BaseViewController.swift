//
//  BaseViewController.swift
//  Wala
//
//  Created by Ibrahim Nabil on 05/02/2024.
//

import Foundation
import UIKit
import Combine
import NVActivityIndicatorView
import SwiftMessages
import Alamofire
import PDFKit

class BaseViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: UIColor().colorWithHexString(hexString: "49D6D6") , padding: 0)
    
    private let notificationCenter = NotificationCenter.default
    let notificationCenterForeground = NotificationCenter.default
    
    lazy var containerOfLoading: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.1)
        return view
        
    }()
    
    // showIndictor
    func showIndictor() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.addLoaderToView(mainView: self.view, containerOfLoading: containerOfLoading, loading: loading)
        }
    }
    
    // hideIndictor
    func hideIndictor() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.removeLoader(containerOfLoading: containerOfLoading, loading: loading)
        }
    }
    
//    func formatDateWithArabicMonth(date: Date, localeIdentifier: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "d MMMM yyyy" // Day, full month name, year
//        dateFormatter.locale = Locale(identifier: localeIdentifier) // Set the locale for month names
//        
//        let formattedDate = dateFormatter.string(from: date)
//        
//        // Ensure numbers remain in English
//        let numberFormatter = NumberFormatter()
//        numberFormatter.locale = Locale(identifier: "en") // Ensure numbers stay in English
//        
//        let englishFormattedDate = formattedDate
//            .components(separatedBy: " ")
//            .map { component in
//                if let number = Int(component) {
//                    return numberFormatter.string(from: NSNumber(value: number)) ?? component
//                }
//                return component
//            }
//            .joined(separator: " ")
//        
//        return englishFormattedDate
//    }
    
    func convertDate(backEndDate: String?)-> String {
        
        let isoDateString = backEndDate ?? ""
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoDateFormatter.date(from: isoDateString) {
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMMM"
            let currentLanguage = Language.currentAppleLanguage()

            
            if currentLanguage.starts(with: "ar") {
                monthFormatter.locale = Locale(identifier: "ar")
            } else {
                monthFormatter.locale = Locale(identifier: "en")
            }
            
            let translatedMonth = monthFormatter.string(from: date)
            
            let dayYearFormatter = DateFormatter()
            dayYearFormatter.dateFormat = "d yyyy"
            dayYearFormatter.locale = Locale(identifier: "en")
            dayYearFormatter.calendar = Calendar(identifier: .gregorian)
            let dayYear = dayYearFormatter.string(from: date) // "1 2025"

            let formattedDate = "\(dayYear.components(separatedBy: " ")[0]) \(translatedMonth) \(dayYear.components(separatedBy: " ")[1])"
            return formattedDate
//            createdAtLabel.text = formattedDate
        } else {
            print("Invalid date format")
            return ""
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
//            guard let self = self else { return }
//            let swipeToPop = UIPanGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
//            self.view.addGestureRecognizer(swipeToPop)
//        }
        
        bind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        notificationCenter
            .addObserver(self,
                         selector:#selector(listenToHandleNotificationTap(_:)),
                         name: NSNotification.Name("handleRateOfferPopup"),
                         object: nil)
        
        notificationCenterForeground
            .addObserver(self,
                         selector: #selector(handleForegroundTapNotification(_:)), name: NSNotification.Name("handleNotificationCenterForegroundTap"),
                         object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notificationCenterForeground
            .removeObserver(self,
                            name: NSNotification.Name("handleNotificationCenterForegroundTap") ,
                            object: nil)
        
        notificationCenter
            .removeObserver(self,
                            name: NSNotification.Name("handleRateOfferPopup") ,
                            object: nil)
        
    }
    
    func bind() {}
    
//    func showAlert(title: String, message: String, buttonTitle: String = "OK".localized, action: (() -> Void)? = nil) {
//        let alertVC = AlertViewController(messageTitle: title, message: message, buttonTitle: buttonTitle, action: action)
//        self.present(alertVC, animated: true)
//    }
    
    @objc func dismissViewController() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        // Check the horizontal swipe direction
        if gesture.state == .ended {
            
            if Language.currentAppleLanguage() == "en" {
                if translation.x > 0 {
                    // Swiped from left to right (optional: handle different direction)
                    navigationController?.popViewController(animated: true)
                }
            }else {
                if translation.x < 0 {
                    // Swiped from right to left (pop gesture)
                    // Check if the swipe is significant enough to trigger a pop
                    if abs(translation.x) > view.bounds.width * 0.3 {
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @objc func handleForegroundTapNotification(_ notification: Notification) {
//        // Check if the notification contains userInfo
//        if let userInfo = notification.userInfo {
//            // Access the values from userInfo dictionary
//            guard let navigationStatus = userInfo["Navigation"] as? String else {
//                print("Navigation status not found")
//                return
//            }
//            print(navigationStatus)
//            
//            guard let mobilePage = userInfo["mobilePage"] as? String else {
//                print("Mobile page value not found")
//                return
//            }
//            print(mobilePage)
//            
//            guard let referenceToken = userInfo["referenceToken"] as? String else {
//                print("Reference token value not found")
//                return
//            }
//            print(referenceToken)
//            
//            switch mobilePage {
//            case "offer":
//                navigationController?.pushViewController(OfferFactory.offerDetails(id: referenceToken).viewController, animated: true)
//            case "vendor":
//                navigationController?.pushViewController(VendorFactory.vendorDetails(vendorId: referenceToken, sort: "newest_to_oldest", CateIDs: [], discountTypes: []).viewController, animated: true)
//                
//            case "offer_rate":
//                present(OfferFactory.redeemDetails(id: referenceToken, rate: "").viewController, animated: true)
//                
//            case "survey":
//                if UD.userType == "family" {
//                    print("don't navigate to any screen in case family member")
//                }else {
//                    checkQuestionnaires(id: referenceToken)
//                }
//                
//            case "employee_request":
//                navigationController?.pushViewController(AttendanceAndLeaveFactory.myHRRequestDetails(CallBacks: { [weak self] in
//                    guard let self = self else  { return }
//                    //self.viewModel.orderBySubject.send(viewModel.getFilterSortMyRequests())
//                    //self.viewModel.statusSubject.send(selectState)
//                    //self.viewModel.reloadWithFilter(filter: .initial)
//                }, myRequestID: referenceToken, typeID: nil).viewController, animated: true)
//                
//            case "hr_request":
//                navigationController?.pushViewController(AttendanceAndLeaveFactory.departmentRequestsDetails(CallBacks: { [weak self] in
//                    guard let self = self else { return }
//                    //self.viewModel.orderBySubject.send(viewModel.getFilterSortMyRequests())
//                    //self.viewModel.statusSubject.send(selectState)
//                    //self.viewModel.reloadWithFilterDeptManager(filter: .initial)
//                }, myRequestID: referenceToken, typeID: nil).viewController, animated: true)
//                
//            default:
//                print("not clickable")
//            }
//        }
    }
    
    //MARK: - Receive User Details
    @objc func listenToHandleNotificationTap(_ notification: Notification) {
        print(notification)
//        
//        // Check if the notification contains userInfo
//        if let userInfo = notification.userInfo {
//            // Access the values from userInfo dictionary
//            guard let navigationStatus = userInfo["Navigation"] as? String else {
//                print("Navigation status not found")
//                return
//            }
//            print(navigationStatus)
//            
//            guard let offerId = userInfo["offerId"] as? String else {
//                print("offerId value not found")
//                return
//            }
//            print(offerId)
//            
//            present(OfferFactory.rateOffer(id: offerId, rate: "").viewController, animated: true)
//            
//        }
        
    }
    
    func convertPriceWithSeprator(_ price: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: price as NSNumber)!
    }
    
    func showNotificationBannerAlert(_ message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureContent(title: "", body: message)
        view.button?.isHidden = true // Hide the close button
        view.configureDropShadow()
        
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        config.duration = .seconds(seconds: 3)
        
        // Show the notification banner
        SwiftMessages.show(config: config, view: view)
    }
    
    func showAlert(title: String, message: String, completion : ((UIAlertAction) -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: completion)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showAlert(title : String, message: String = "", cancelTitle : String = "Cancel".localized , okTitle : String = "OK".localized, completion :  ((UIAlertAction) -> Void)?)  {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: completion)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true)
    }
    
    func openLink(_ link: String) {
        if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func deleteView(ofTag tag: Int) {
        if let viewWithTag = self.view.viewWithTag(tag) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func set(_ controller: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.1
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.setViewControllers([controller], animated: false)
    }
    
    func push(_ controller: UIViewController) {
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pop()  {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addPlure(toView view: UIView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.9
        view.addSubview(blurEffectView)
    }
    
    func determineDateStatus(_ dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            
            if calendar.isDateInToday(date) {
                return "(Today)".localized
            } else if calendar.isDateInYesterday(date) {
                return "(Yesterday)".localized
            } else {
                return ""
                //let formatter = DateFormatter()
                //formatter.dateFormat = "yyyy-MM-dd"
                //return formatter.string(from: date)
            }
        } else {
            return "Invalid Date Format"
        }
    }
    
    deinit {
//        notificationCenter
//            .removeObserver(self,
//                            name: NSNotification.Name("handleNotificationTap") ,
//                            object: nil)
        print("Deinit: " + String(describing: self))
    }
}

class BasePresntingViewController: BaseViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIViewController {

    func addLoaderToView(mainView: UIView, containerOfLoading: UIView, loading: NVActivityIndicatorView) {

        DispatchQueue.main.async {
            loading.isUserInteractionEnabled = false
            loading.translatesAutoresizingMaskIntoConstraints = false
            
            containerOfLoading.translatesAutoresizingMaskIntoConstraints = false
            

            self.view.addSubview(containerOfLoading)
            containerOfLoading.addSubview(loading)

            NSLayoutConstraint.activate([

                containerOfLoading.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
                containerOfLoading.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
                containerOfLoading.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
                containerOfLoading.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),

                loading.widthAnchor.constraint(equalToConstant: 50),
                loading.heightAnchor.constraint(equalToConstant: 50),
                loading.centerYAnchor.constraint(equalTo: containerOfLoading.centerYAnchor, constant: 0),
                loading.centerXAnchor.constraint(equalTo: containerOfLoading.centerXAnchor, constant: 0)

            ])

            loading.startAnimating()
        }

    }

    func removeLoader(containerOfLoading: UIView, loading: NVActivityIndicatorView)  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {

            containerOfLoading.removeFromSuperview()

            loading.stopAnimating()

        }
    }
    
    func setImageFromFirstletter(name: String) -> UIImage {
        
        let lblNameInitialize = UILabel()
        lblNameInitialize.frame.size = CGSize(width: 100.0, height: 100.0)
        lblNameInitialize.textColor = UIColor.black
        lblNameInitialize.text = String(name.prefix(1) )
        lblNameInitialize.font = .appFont(ofSize: 30, weight: .bold)
        lblNameInitialize.textAlignment = NSTextAlignment.center
        lblNameInitialize.backgroundColor = UIColor().colorWithHexString(hexString: "#F4F4F6")
        lblNameInitialize.layer.cornerRadius = 50.0
        
        UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
        lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
    
    func setDefaultImageletters(name: String, color: String) -> UIImage {
        
        let lblNameInitialize = UILabel()
        lblNameInitialize.frame.size = CGSize(width: 100.0, height: 100.0)
        lblNameInitialize.textColor = UIColor.black
        lblNameInitialize.text = String(name.prefix(1) )
        lblNameInitialize.font = .appFont(ofSize: 30, weight: .bold)
        lblNameInitialize.textAlignment = NSTextAlignment.center
        lblNameInitialize.backgroundColor = UIColor().colorWithHexString(hexString: "#F4F4F6")
        lblNameInitialize.layer.cornerRadius = 50.0
        
        UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
        lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
    
    func randomColorExcludingWhite() -> UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        repeat {
            red = CGFloat.random(in: 0...1)
            green = CGFloat.random(in: 0...1)
            blue = CGFloat.random(in: 0...1)
        } while (red + green + blue >= 2.9)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func randomColorExcludingWhiteWithString() -> String {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        repeat {
            red = CGFloat.random(in: 0...1)
            green = CGFloat.random(in: 0...1)
            blue = CGFloat.random(in: 0...1)
        } while (red + green + blue >= 2.9)
        
        let redInt = Int(red * 255)
        let greenInt = Int(green * 255)
        let blueInt = Int(blue * 255)
        
        let hexString = String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
        return hexString
    }
    
}
