//
//  UIViewController_Extensions.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

extension UIViewController {
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func generateQRCode(from number: String) -> UIImage? {
        let data = number.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                let qrCodeImage = UIImage(ciImage: output)
                return qrCodeImage
            }
        }
        
        return nil
    }
    
}
extension UIViewController {
    func dismissAllViewControllers(animated: Bool = false, completion: (() -> Void)? = nil) {
        var viewControllerToDismiss: UIViewController? = presentingViewController
        while viewControllerToDismiss != nil {
            let nextViewControllerToDismiss = viewControllerToDismiss?.presentingViewController
            viewControllerToDismiss?.dismiss(animated: animated, completion: completion)
            viewControllerToDismiss = nextViewControllerToDismiss
        }
    }
}

extension UIViewController {
    
    func contecWithWhatsAPP(phoneNumber: String){
            let appURL = URL(string: "https://wa.me/\(phoneNumber)")!
            if UIApplication.shared.canOpenURL(appURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            }
        }
    
}
