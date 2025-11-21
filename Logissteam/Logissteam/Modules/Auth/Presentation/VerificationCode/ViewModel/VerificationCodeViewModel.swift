//
//  VerificationCodeViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import Combine

class VerificationCodeViewModel: BaseViewModel {
    
    var textCode1Subject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textCode2Subject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textCode3Subject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textCode4Subject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    var enabledConfirmButtonPublisher: PassthroughSubject<Bool, Never> = .init()
    var lengthCode1Publisher: PassthroughSubject<String, Never> = .init()
    var lengthCode2Publisher: PassthroughSubject<String, Never> = .init()
    var lengthCode3Publisher: PassthroughSubject<String, Never> = .init()
    var lengthCode4Publisher: PassthroughSubject<String, Never> = .init()
    
    var navigatoToSucess: PassthroughSubject<Void, Never> = .init()
    var showTimerAfterResend: PassthroughSubject<Void, Never> = .init()
    
    private var lengthCode1: Bool? = false
    private var lengthCode2: Bool? = false
    private var lengthCode3: Bool? = false
    private var lengthCode4: Bool? = false
    
    private var otp: String?
    private var phoneNumber: String?
    
    private let verificationCodeUseCase: VerificationCodeUseCase
    
    private var verificationCodeRequest: VerificationCodeRequest = .init()
    
    init(verificationCodeUseCase: VerificationCodeUseCase, phoneNumber: String?) {
        self.verificationCodeUseCase = verificationCodeUseCase
        self.phoneNumber = phoneNumber
    }
    
    func getPhoneNumber() -> String? {
        return phoneNumber
    }
    
    func maskPhoneNumber() -> String {
        // Ensure the phone number has at least 4 digits
        guard phoneNumber?.count ?? 0 >= 4 else { return phoneNumber ?? "" }
        
        // Get the last 4 digits
        guard let lastFour = phoneNumber?.suffix(4) else { return "" }
        
        // Replace all but the last 4 digits with asterisks
        let maskedPart = String(repeating: "*", count: (phoneNumber?.count ?? 0) - 4)
        
        return maskedPart + lastFour
    }
    
    func validateCode1(code: String) {
        lengthCode1Publisher.send(validateLengthCode1(code: code))
    }
    
    func validateCode2(code: String) {
        lengthCode2Publisher.send(validateLengthCode2(code: code))
    }
    
    func validateCode3(code: String) {
        lengthCode3Publisher.send(validateLengthCode3(code: code))
    }
    
    func validateCode4(code: String) {
        lengthCode4Publisher.send(validateLengthCode4(code: code))
    }
    
    func isCodeValid() -> Bool {
        if lengthCode1 == true && lengthCode2 == true && lengthCode3 == true && lengthCode4 == true {
            return true
        }else {
            return false
        }
    }
    
    private func validateLengthCode1(code: String) -> String {
        // Implement logic for length validation
        // Return an empty string if the condition is met, otherwise return an error message
        
        if code.count == 1 {
            lengthCode1 = true
            enabledConfirmButtonPublisher.send(isCodeValid())
            return "2F8B8B"
        }else {
            lengthCode1 = false
            enabledConfirmButtonPublisher.send(isCodeValid())
            return "DC3545"
        }
    }
    
    private func validateLengthCode2(code: String) -> String {
        // Implement logic for length validation
        // Return an empty string if the condition is met, otherwise return an error message
        
        if code.count == 1 {
            lengthCode2 = true
            enabledConfirmButtonPublisher.send(isCodeValid())
            return "2F8B8B"
        }else {
            lengthCode2 = false
            enabledConfirmButtonPublisher.send(isCodeValid())
            return "DC3545"
        }
    }
    
    private func validateLengthCode3(code: String) -> String {
        // Implement logic for length validation
        // Return an empty string if the condition is met, otherwise return an error message
        
        if code.count == 1 {
            lengthCode3 = true
            enabledConfirmButtonPublisher.send(isCodeValid())
            return "2F8B8B"
        }else {
            lengthCode3 = false
            enabledConfirmButtonPublisher.send(isCodeValid())
            return "DC3545"
        }
    }
    
    private func validateLengthCode4(code: String) -> String {
        // Implement logic for length validation
        // Return an empty string if the condition is met, otherwise return an error message
        
        if code.count == 1 {
            lengthCode4 = true
            enabledConfirmButtonPublisher.send(isCodeValid())
            return "2F8B8B"
        }else {
            lengthCode4 = false
            enabledConfirmButtonPublisher.send(isCodeValid())
            return "DC3545"
        }
    }
    
    func didTapOnConfirm() {
        
        verificationCodeRequest.phone = phoneNumber?.replacedArabicDigitsWithEnglish
        otp = textCode1Subject.value.replacedArabicDigitsWithEnglish + textCode2Subject.value.replacedArabicDigitsWithEnglish + textCode3Subject.value.replacedArabicDigitsWithEnglish + textCode4Subject.value.replacedArabicDigitsWithEnglish
        verificationCodeRequest.token = otp
        
        postVerificationCode()
        
    }
    
    func postVerificationCode() {
        // Start loading state
        isLoading.send(true)
        
        // Execute the verification code use case and handle the Combine pipeline
        verificationCodeUseCase.execute(request: verificationCodeRequest)
            .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                // Stop loading state
                self.isLoading.send(false)
                
                // Handle completion
                switch completion {
                case .finished:
                    print("Verification code processed successfully")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] _ in
                // Navigate to success screen upon successful verification
                guard let self = self else { return }
                self.navigatoToSucess.send()
            })
            .store(in: &cancellables) // Store the subscription
    }
    
}
