//
//  RegisterViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import Combine

protocol RegisterViewModelProtocol {
    // Inputs
    func viewDidLoad()
    func didTapOnRegisterButton(iban_image: Data?)

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
    
    func didTapOnRegisterButton(iban_image: Data? = nil) {
        registerRequest.name = textNameSubject.value
        registerRequest.phone = textPhoneSubject.value.replacedArabicDigitsWithEnglish
        registerRequest.email = textEmailSubject.value
        registerRequest.iban_image = iban_image
        register(body: registerRequest)
    }
    
    private func register(body: RegisterRequest) {
        // Start loading state
        isLoading.send(true)
        
        // Execute the register use case and handle the Combine pipeline
        registerUseCase.execute(request: body)
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
