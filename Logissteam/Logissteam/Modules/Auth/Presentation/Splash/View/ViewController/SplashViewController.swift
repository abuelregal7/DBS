//
//  SplashViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 19/08/2024.
//

import UIKit

class SplashViewController: BaseViewController {
    
    @IBOutlet weak var logissteamLogoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            var vc: UIViewController
            //if UD.accessToken != nil {
            //    vc = TabBarViewController() // go to home
            //} else {
            //    vc = AuthVCBuilder.login.viewController // go to login
            //}
            vc = TabBarViewController()
            self.set(vc)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scaleAnimation()
    }
    
    func scaleAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat], animations: { [weak self] in
            guard let self = self else { return }
            // Set the scale transform
            self.logissteamLogoImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
    
}
