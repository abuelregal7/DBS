//
//  MoreViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation
import Combine

protocol MoreViewModelProtocol {
    // Inputs
    func didTapOnLogoutButton()
    
    // Outputs
    var navigatoToLogin: PassthroughSubject<Void, Never> { get }
    
}

class MoreViewModel: BaseViewModel, MoreViewModelProtocol {
    
    var navigatoToLogin: PassthroughSubject<Void, Never> = .init()
    
    var navigaAfterDeleteAccount: PassthroughSubject<Void, Never> = .init()
    
    // MARK: - Private
    private var logoutUseCase: LogoutUseCase
    private var deleteAccountUseCase: DeleteAccountUseCase
    
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
