//
//  ContactUSViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation
import Combine

protocol ContactUSViewModelProtocol {
    
    // Inputs
    var input: ContactUSViewModel.Input { get }
    
    // Outputs
    var output: ContactUSViewModel.Output { get }
    
    // Inputs
    func didTapOnSendButton()
    
    var textNameSubject: CurrentValueSubject<String, Never> { get }
    var textPhoneSubject: CurrentValueSubject<String, Never> { get }
    var textEmailSubject: CurrentValueSubject<String, Never> { get }
    var textMessageSubject: CurrentValueSubject<String, Never> { get }
    
    // Outputs
    var makePop: PassthroughSubject<String, Never> { get }
    var addressData: PassthroughSubject<String, Never> { get }
    var phoneData: PassthroughSubject<String, Never> { get }
    var emailData: PassthroughSubject<String, Never> { get }
}

class ContactUSViewModel: BaseViewModel, ContactUSViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let reloadMyAddressesCollections: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    var textNameSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textEmailSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textMessageSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    var makePop: PassthroughSubject<String, Never> = .init()
    var addressData: PassthroughSubject<String, Never> = .init()
    var phoneData: PassthroughSubject<String, Never> = .init()
    var emailData: PassthroughSubject<String, Never> = .init()
    private let reloadMyAddressesCollectionsSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Private
    private var settingUseCase: SettingUseCase
    private var contactUSUseCase: ContactUsUseCase
    private var contactUSUseRequest: ContactUsRequest = .init()
    
    init(settingUseCase: SettingUseCase, contactUSUseCase: ContactUsUseCase) {
        self.settingUseCase = settingUseCase
        self.contactUSUseCase = contactUSUseCase
        
        // Initialize Inputs
        input = Input(
            viewDidLoad: PassthroughSubject()
        )
        
        // Initialize Outputs
        output = Output(
            reloadMyAddressesCollections: reloadMyAddressesCollectionsSubject.eraseToAnyPublisher()
        )
        
        super.init()
        
        bindInputs()
        
    }
    
    // MARK: - Input Binding
    private func bindInputs() {
        // Handle viewDidLoad
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }
                self.getSettingData()
            }
            .store(in: &cancellables)
    }
    
    func didTapOnSendButton() {
        contactUSUseRequest.name = textNameSubject.value
        contactUSUseRequest.phone = textPhoneSubject.value
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
    
    private
    func getSettingData() {
        isLoading.send(true)
        
        settingUseCase.execute() // Assuming this returns `AnyPublisher<ContactResponseModel, NetworkError>`
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
                for item in 0...(request.count) - 1 {
                    if Language.isRTL {
                        if request[item].key == "address_ar" {
                            self.addressData.send(request[item].value ?? "")
                        }
                    }else {
                        if request[item].key == "address_en" {
                            self.addressData.send(request[item].value ?? "")
                        }
                    }
                    if request[item].key == "phone" {
                        self.phoneData.send(request[item].value ?? "")
                    }else if request[item].key == "email" {
                        self.emailData.send(request[item].value ?? "")
                    }
                }
            })
            .store(in: &cancellables) // Store the subscription to manage memory
    }

    
}
