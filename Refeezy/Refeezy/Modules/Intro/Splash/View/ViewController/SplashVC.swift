//
//  SplashVC.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 06/03/2025.
//

import UIKit

class SplashVC: BaseViewController {
    
    @IBOutlet weak var parentStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            var vc: UIViewController
            if UD.accessToken != nil {
                vc = TabBarViewController()
                self.set(vc)
            } else {
                vc = TabBarViewController()
                self.set(vc)
                //vc = AuthVCBuilder.login.viewController
                //self.set(vc)
            }
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
            self.parentStackView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
    
}
