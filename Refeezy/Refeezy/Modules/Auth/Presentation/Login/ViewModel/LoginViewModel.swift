//
//  LoginViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 04/04/2025.
//

import Foundation
import Combine

protocol LoginViewModelProtocol {
    // Inputs
    func viewDidLoad() async
    func didTapOnLoginButton()
    
    var textPhoneSubject: CurrentValueSubject<String, Never> { get }
    
    // Outputs
    var navigatoToVerificationCode: PassthroughSubject<Void, Never> { get }
    
}

class LoginViewModel: BaseViewModel, LoginViewModelProtocol {
    
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    // MARK: - Private
    private var loginUseCase: LoginUseCase
    private var loginRequest: LoginRequest = .init()
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
        
    }
    
    // MARK: - Outputs
    var navigatoToVerificationCode: PassthroughSubject<Void, Never> = .init()
    
    // MARK: - Inputs
    func viewDidLoad() async {
        // Update phone number in the login request by replacing Arabic digits with English
        loginRequest.phone = textPhoneSubject.value.replacedArabicDigitsWithEnglish
        
        do {
            // Call the login function using async/await
            let loginData = try await login(body: loginRequest)
            
            // Handle the login data if needed
            print("Login successful with data: \(loginData)")
        } catch {
            // Handle the error appropriately
            handleError(error) // Call your existing error handling logic
        }
    }
    
    func checkPhoneValidPublisher()-> AnyPublisher<Bool, Never> {
        return textPhoneSubject.map { value in
            let newValue = value.replacedArabicDigitsWithEnglish
            return newValue.isValidPhone
        }.eraseToAnyPublisher()
    }
    
    func didTapOnLoginButton() {
        Task {
            await viewDidLoad()
        }
    }
    
    // MARK: - Private Methods
    private func login(body: LoginRequest) async throws -> LoginData {
        // Start loading state
        isLoading.send(true)
        
        // Use a continuation to wrap the Combine publisher
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<LoginData, Error>) in
            loginUseCase.execute(body: body)
                .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
                .sink(receiveCompletion: { [weak self] completion in
                    // Ensure self is still alive to prevent memory leaks
                    guard let self = self else { return }
                    
                    // Stop loading state regardless of success or failure
                    self.isLoading.send(false)
                    
                    switch completion {
                    case .finished:
                        print("Login finished successfully")
                    case .failure(let error):
                        // Handle the error and resume with throwing the error
                        self.handleError(error) // Call your error handling logic
                        continuation.resume(throwing: error) // Resume with the error
                    }
                }, receiveValue: { [weak self] loginData in
                    // Ensure self is still alive
                    guard let self = self else { return }
                    
                    // Navigate to verification code screen upon successful login
                    self.navigatoToVerificationCode.send()
                    continuation.resume(returning: loginData) // Resume with loginData
                })
                .store(in: &cancellables) // Keep the subscription alive
        }
    }
    
}
