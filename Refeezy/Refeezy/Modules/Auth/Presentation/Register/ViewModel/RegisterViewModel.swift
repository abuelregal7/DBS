//
//  RegisterViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation
import Combine

protocol RegisterViewModelProtocol {
    // Inputs
    func viewDidLoad()
    func didTapOnRegisterButton()

    var textPhoneSubject: CurrentValueSubject<String, Never> { get }
    var textNameSubject: CurrentValueSubject<String, Never> { get }
    var textEmailSubject: CurrentValueSubject<String, Never> { get }
    
    // Outputs
    var navigatoToVerificationCode: PassthroughSubject<Void, Never> { get }
    
}

class RegisterViewModel: BaseViewModel, RegisterViewModelProtocol {
    
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textNameSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textEmailSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    // MARK: - Private
    private var registerUseCase: RegisterUseCase
    private var registerRequest: RegisterRequest = .init()
    
    init(registerUseCase: RegisterUseCase) {
        self.registerUseCase = registerUseCase
        
    }
    
    // MARK: - Outputs
    var navigatoToVerificationCode: PassthroughSubject<Void, Never> = .init()
    
    // MARK: - Inputs
    func viewDidLoad() {
        
    }
    
    func didTapOnRegisterButton() {
        registerRequest.name = textNameSubject.value
        registerRequest.phone = textPhoneSubject.value.replacedArabicDigitsWithEnglish
        registerRequest.email = textEmailSubject.value
        register(body: registerRequest)
    }
    
    private func register(body: RegisterRequest) {
        // Start loading state
        isLoading.send(true)
        
        // Execute the register use case and handle the Combine pipeline
        registerUseCase.execute(body: body)
            .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                // Stop loading state
                self.isLoading.send(false)
                
                // Handle completion
                switch completion {
                case .finished:
                    print("Registration finished successfully")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] _ in
                // Navigate to verification code screen upon successful registration
                guard let self = self else { return }
                self.navigatoToVerificationCode.send()
            })
            .store(in: &cancellables) // Store the subscription
    }
    
}
