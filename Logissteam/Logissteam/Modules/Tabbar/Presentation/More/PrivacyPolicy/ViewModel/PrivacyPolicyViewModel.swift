//
//  PrivacyPolicyViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import Combine

protocol PrivacyPolicyViewModelProtocol {
    // Inputs
    func viewDidLoad()
    
    var privacyPolicyData: PrivacyPolicyData? { get }
    var privacyPolicyDataPublisher: Published<PrivacyPolicyData?>.Publisher { get }
    
}

class PrivacyPolicyViewModel: BaseViewModel, PrivacyPolicyViewModelProtocol {
    
    @Published var privacyPolicyData : PrivacyPolicyData?
    var privacyPolicyDataPublisher : Published<PrivacyPolicyData?>.Publisher{ $privacyPolicyData }
    
    // MARK: - Private
    private var privacyPolicyUseCase: PrivacyPolicyUseCase
    
    init(privacyPolicyUseCase: PrivacyPolicyUseCase) {
        self.privacyPolicyUseCase = privacyPolicyUseCase
        
    }
    
    func viewDidLoad() {
        privacyPolicy()
    }
    
    // MARK: - Private Methods
    
    private 
    func privacyPolicy() {
        isLoading.send(true)
        
        privacyPolicyUseCase.execute() // Assuming this returns `AnyPublisher<PrivacyPolicyModel, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Privacy Policy data fetch successful")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                self.privacyPolicyData = request
            })
            .store(in: &cancellables) // Store the subscription to avoid memory leaks
    }

    
}
