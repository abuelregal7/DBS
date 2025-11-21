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
        
    }
    
    func handleError(_ errorMessage: String) {
        self.showAlert(title: "Error".localized, message: errorMessage.localized)
    }
    
    func handleErrorWithClicked(_ errorMessage: String) {
        showAlert(title: "Error".localized, message: errorMessage.localized) { action in
            UserDefaults.standard.removeObject(forKey: "AccessToken")
            UserDefaults.standard.removeObject(forKey: "user")
            
            UIApplication.setRoot(AuthVCBuilder.login.viewController, animated: false)
        }
    }
    
    func handleDebugSuccess(_ message: String) {
        #if DEBUG
//        self.showAlert(title: "Message".localized, message: message)
        #endif
    }
}
