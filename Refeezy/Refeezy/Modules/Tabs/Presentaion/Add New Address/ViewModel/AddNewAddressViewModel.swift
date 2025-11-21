//
//  AddNewAddressViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation
import Combine

protocol AddNewAddressViewModelProtocol {
    // Inputs
    var input: AddNewAddressViewModel.Input { get }
    
    // Outputs
    var output: AddNewAddressViewModel.Output { get }
    
    var textAddressSubject: CurrentValueSubject<String?, Never> { get }
    var textCitySubject: CurrentValueSubject<String?, Never> { get }
    var textEmailSubject: CurrentValueSubject<String, Never> { get }
    var textPhoneNumberSubject: CurrentValueSubject<String, Never> { get }
    
    // Outputs
    var navigatoToMyAddresses: PassthroughSubject<Void, Never> { get }
    
}

class AddNewAddressViewModel: BaseViewModel, AddNewAddressViewModelProtocol {
    
    // MARK: - Input/Output Structure
    
    struct Input {
        let viewDidLoad: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let navigatoToMyAddresses: AnyPublisher<Void, Never>
    }
    
    // Inputs
    let input: Input
    
    // Outputs
    let output: Output
    
    private let navigatoToMyAddressesSubject = PassthroughSubject<Void, Never>()
    
    var textAddressSubject: CurrentValueSubject<String?, Never> = CurrentValueSubject<String?,Never>(nil)
    var textCitySubject: CurrentValueSubject<String?, Never> = CurrentValueSubject<String?,Never>(nil)
    var textEmailSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textPhoneNumberSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    // MARK: - Private
    private var addAddressUseCase: AddAddressUseCase
    private var addAddressRequest: AddAddressRequest = .init()
    
    private var address: String?
    private var city: String?
    private var lat: String?
    private var long: String?
    
    init(addAddressUseCase: AddAddressUseCase, address: String?, city: String?, lat: String?, long: String?) {
        self.addAddressUseCase = addAddressUseCase
        self.address = address
        self.city = city
        self.lat = lat
        self.long = long
        
        // Initialize Inputs
        input = Input(
            viewDidLoad: PassthroughSubject()
        )
        
        // Initialize Outputs
        output = Output(
            navigatoToMyAddresses: navigatoToMyAddressesSubject.eraseToAnyPublisher()
        )
        
        super.init()
        
        bindInputs()
        
    }
    
    // MARK: - Outputs
    var navigatoToMyAddresses: PassthroughSubject<Void, Never> = .init()
    
    func getAddress() -> String? {
        return address
    }
    
    func getCity() -> String? {
        return city
    }
    
    func getLat() -> String? {
        return lat
    }
    
    func getLong() -> String? {
        return long
    }
    
    // MARK: - Input Binding
    private func bindInputs() {
        // Handle viewDidLoad
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }
                addAddressRequest.address = textAddressSubject.value
                addAddressRequest.city = textCitySubject.value
                //addAddressRequest.email = textEmailSubject.value
                addAddressRequest.phone = textPhoneNumberSubject.value.replacedArabicDigitsWithEnglish
                
                self.addNewAddress(body: addAddressRequest)
            }
            .store(in: &cancellables)
    }
    
    func checkPhoneValidPublisher()-> AnyPublisher<Bool, Never> {
        return textPhoneNumberSubject.map { value in
            let newValue = value.replacedArabicDigitsWithEnglish
            return newValue.isValidPhone
        }.eraseToAnyPublisher()
    }
    
    private
    func addNewAddress(body: AddAddressRequest) {
        isLoading.send(true)
        addAddressUseCase.execute(body: body)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Finished loading home data")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                
                // Handle the data
                navigatoToMyAddressesSubject.send()
            })
            .store(in: &cancellables)
    }
    
}
