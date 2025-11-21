//
//  MoreViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 03/04/2025.
//

import UIKit

class MoreViewController: BaseViewControllerWithVM<MoreViewModel> {
    
    @IBOutlet weak var myAccountView: UIView!
    @IBOutlet weak var requestsView: UIView!
    @IBOutlet weak var myAddressesView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var contactUsView: UIView!
    @IBOutlet weak var whoUsView: UIView!
    @IBOutlet weak var termsConditionsView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var deleteAccountView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UD.accessToken == nil {
            myAccountView.isHidden = true
            requestsView.isHidden = true
            myAddressesView.isHidden = true
            logoutView.isHidden = true
            deleteAccountView.isHidden = true
            loginButton.isHidden = false
        }else {
            myAccountView.isHidden = false
            requestsView.isHidden = false
            myAddressesView.isHidden = false
            logoutView.isHidden = false
            deleteAccountView.isHidden = false
            loginButton.isHidden = true
        }
    }
    
    override func bind() {
        super.bind()
        
        viewModel.navigatoToLogin
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.clearCach()
                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: AuthVCBuilder.login.viewController)
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }.store(in: &cancellables)
        
        viewModel.navigaAfterDeleteAccount
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.clearCach()
                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: AuthVCBuilder.login.viewController)
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }.store(in: &cancellables)
        
        myAccountView.addTapGesture { [weak self] in
            guard let self =  self else { return }
            navigationController?.pushViewController(TabsVCBuilder.myAccount.viewController, animated: true)
        }
        
        requestsView.addTapGesture { [weak self] in
            guard let self =  self else { return }
            navigationController?.pushViewController(TabsVCBuilder.myOrderes.viewController, animated: true)
        }
        
        myAddressesView.addTapGesture { [weak self] in
            guard let self =  self else { return }
            navigationController?.pushViewController(TabsVCBuilder.myAddresses.viewController, animated: true)
        }
        
        languageView.addTapGesture { [weak self] in
            guard let self =  self else { return }
            navigationController?.pushViewController(ChangeLanguageViewController(), animated: true)
        }
        
        contactUsView.addTapGesture { [weak self] in
            guard let self =  self else { return }
            navigationController?.pushViewController(TabsVCBuilder.contactUS.viewController, animated: true)
        }
        
        whoUsView.addTapGesture { [weak self] in
            guard let self =  self else { return }
            navigationController?.pushViewController(TabsVCBuilder.aboutUS.viewController, animated: true)
        }
        
        termsConditionsView.addTapGesture { [weak self] in
            guard let self =  self else { return }
            navigationController?.pushViewController(TabsVCBuilder.terms.viewController, animated: true)
        }
        
        logoutView.addTapGesture { [weak self] in
            guard let self =  self else { return }
            let alert = UIAlertController(title: "Logout".localized, message: "Are you sure, want to logout ?".localized, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized, style: .default) { [weak self] (action) in
                guard let self = self else { return }
                self.viewModel.didTapOnLogoutButton()
            }
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
        
        deleteAccountView.addTapGesture { [weak self] in
            guard let self =  self else { return }
            if UD.accessToken == nil {
                let alert = UIAlertController(title: "Login".localized, message: "".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized, style: .default) { [weak self] (action) in
                    guard let self = self else { return }
                    self.set(AuthVCBuilder.login.viewController)
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            }else {
                let alert = UIAlertController(title: "Delete Account".localized, message: "Are you sure, want to delete account ?".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized, style: .default) { [weak self] (action) in
                    guard let self = self else { return }
                    self.viewModel.didTapOnDeleteAccountButton()
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            }
        }
        
        loginButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.set(AuthVCBuilder.login.viewController)
            }
            .store(in: &cancellables)
        
    }
    
    func clearCach() {
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "AccessToken")
        UserDefaults.standard.removeObject(forKey: "user")
    }
    
}
