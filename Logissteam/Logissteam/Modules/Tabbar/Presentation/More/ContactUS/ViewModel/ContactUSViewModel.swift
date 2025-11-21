//
//  ContactUSViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import Combine

protocol ContactUSViewModelProtocol {
    // Inputs
    func didTapOnSendButton()
    
    var textFirstNameSubject: CurrentValueSubject<String, Never> { get }
    var textLastNameSubject: CurrentValueSubject<String, Never> { get }
    var textEmailSubject: CurrentValueSubject<String, Never> { get }
    var textMessageSubject: CurrentValueSubject<String, Never> { get }
    
    // Outputs
    var makePop: PassthroughSubject<String, Never> { get }
}

class ContactUSViewModel: BaseViewModel, ContactUSViewModelProtocol {
    
    var textFirstNameSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textLastNameSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textEmailSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textMessageSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    var makePop: PassthroughSubject<String, Never> = .init()
    
    // MARK: - Private
    private var contactUSUseCase: ContactUsUseCase
    private var contactUSUseRequest: ContactUsRequest = .init()
    
    init(contactUSUseCase: ContactUsUseCase) {
        self.contactUSUseCase = contactUSUseCase
        
    }
    
    func didTapOnSendButton() {
        contactUSUseRequest.first_name = textFirstNameSubject.value
        contactUSUseRequest.last_name = textLastNameSubject.value
        contactUSUseRequest.email = textEmailSubject.value
        contactUSUseRequest.message = textMessageSubject.value
        contactUS()
    }
    
    // MARK: - Private Methods
    
    private 
    func contactUS() {
        isLoading.send(true)
        
        contactUSUseCase.execute(request: contactUSUseRequest) // Assuming this returns `AnyPublisher<ContactResponseModel, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Contact Us request successful")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                self.makePop.send(request.message ?? "")
            })
            .store(in: &cancellables) // Store the subscription to manage memory
    }

    
}
