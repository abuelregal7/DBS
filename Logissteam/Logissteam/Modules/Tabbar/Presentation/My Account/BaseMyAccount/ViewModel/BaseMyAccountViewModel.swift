//
//  BaseMyAccountViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 01/09/2024.
//

import Foundation
import Combine

protocol BaseMyAccountViewModelProtocol {
    // Inputs
    func didTapOnLogoutButton()
    
    // Outputs
    var navigatoToLogin: PassthroughSubject<Void, Never> { get }
    
}

class BaseMyAccountViewModel: BaseViewModel, BaseMyAccountViewModelProtocol {
    
    var navigatoToLogin: PassthroughSubject<Void, Never> = .init()
    
    var navigaAfterDeleteAccount: PassthroughSubject<Void, Never> = .init()
    
    // MARK: - Private
    private var logoutUseCase: LogoutUseCase
    private var deleteAccountUseCase: DeleteAccountUseCase
    
    private var settingData = [BaseMyAccountModel]()
    
    init(logoutUseCase: LogoutUseCase, deleteAccountUseCase: DeleteAccountUseCase) {
        self.logoutUseCase = logoutUseCase
        self.deleteAccountUseCase = deleteAccountUseCase
        
    }
    
    func didTapOnLogoutButton() {
        logout()
    }
    
    func didTapOnDeleteAccountButton() {
        deleteAccount()
    }
    
    func getSettingDataCount() -> Int {
        return settingData.count
    }
    
    func getSettingData(index: Int) -> BaseMyAccountModel {
        return settingData[index]
    }
    
    func setSettingData() {
        if UD.accessToken != nil {
            settingData.append(contentsOf: [
                BaseMyAccountModel(title: "My Account".localized, icon: "aboutus"),
                BaseMyAccountModel(title: "App Language".localized, icon: "language"),
                BaseMyAccountModel(title: "Logout".localized, icon: "logout")
            ])
        }else {
            settingData.append(contentsOf: [
                BaseMyAccountModel(title: "My Account".localized, icon: "aboutus"),
                BaseMyAccountModel(title: "App Language".localized, icon: "language")
            ])
        }
    }
    
    // MARK: - Private Methods
    
    private 
    func logout() {
        isLoading.send(true)
        
        logoutUseCase.execute() // Assuming this returns `AnyPublisher<Void, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Logout successful")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.navigatoToLogin.send() // Navigate to login screen on success
            })
            .store(in: &cancellables) // Store the subscription to avoid memory leaks
    }
    
    private
    func deleteAccount() {
        isLoading.send(true)
        
        deleteAccountUseCase.execute() // Assuming this returns `AnyPublisher<Void, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Logout successful")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.navigaAfterDeleteAccount.send() // Navigate to login screen on success
            })
            .store(in: &cancellables) // Store the subscription to avoid memory leaks
    }
    
}
