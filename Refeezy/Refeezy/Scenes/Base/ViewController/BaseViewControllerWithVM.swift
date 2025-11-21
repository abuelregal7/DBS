//
//  ViewController.swift
//  Wala
//
//  Created by Ibrahim Nabil on 05/02/2024.
//

import UIKit
import Combine

class BaseViewControllerWithVM<T:BaseViewModel>: BaseViewController {
    
    // MARK: - Properties
    var viewModel:T
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        super.bind()
        viewModel.isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.showIndictor() : self.hideIndictor()
                
                if isLoading {
                    
                    self.showIndictor()
                    
                }else {
                    
                    self.hideIndictor()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
                        guard let self = self else { return }
                        let swipeToPop = UIPanGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
                        self.view.addGestureRecognizer(swipeToPop)
                    }
                    
                }
                
            }
            .store(in: &cancellables)
                
        viewModel.errorPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] messsage in
                guard let self = self else { return }
                self.handleError(messsage)
            }
            .store(in: &cancellables)
        
        viewModel.errorUnAuthorizedPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] messsage in
                guard let self = self else { return }
                self.handleErrorWithClicked(messsage?.localized ?? "")
            }
            .store(in: &cancellables)
        
        viewModel.errorNotFoundPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] messsage in
                guard let self = self else { return }
                handleNotFoundErrorWithClicked(messsage ?? "")
            }
            .store(in: &cancellables)
        
    }
    
    func handleError(_ errorMessage: String) {
        self.showAlert(title: "Error".localized, message: errorMessage.localized)
    }
    
    func handleErrorWithClicked(_ errorMessage: String) {
        showAlert(title: "Error".localized, message: errorMessage.localized) { [weak self] action in
            guard let self = self else { return }
            UserDefaults.standard.removeObject(forKey: "AccessToken")
            UserDefaults.standard.removeObject(forKey: "user")
            let vc = AuthVCBuilder.login.viewController
            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    func handleNotFoundErrorWithClicked(_ errorMessage: String) {
        showAlert(title: "Error".localized, message: errorMessage) { [weak self] action in
            guard let self = self else { return }
            //UIApplication.setRoot(TabBarViewController(selectedIndex: 0, comeToVendorFrom: .FromTabbar), animated: true)
        }
    }
    
    func handleDebugSuccess(_ message: String) {
        #if DEBUG
//        self.showAlert(title: "Message".localized, message: message)
        #endif
    }
}
