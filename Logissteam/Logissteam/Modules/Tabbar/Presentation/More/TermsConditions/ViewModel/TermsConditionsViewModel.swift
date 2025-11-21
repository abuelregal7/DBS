//
//  TermsConditionsViewModel.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import Combine

protocol TermsConditionsViewModelProtocol {
    // Inputs
    func viewDidLoad()
    
    var termsConditionsData: TermsData? { get }
    var termsConditionsDataPublisher: Published<TermsData?>.Publisher { get }
    
}

class TermsConditionsViewModel: BaseViewModel, TermsConditionsViewModelProtocol {
    
    @Published var termsConditionsData : TermsData?
    var termsConditionsDataPublisher : Published<TermsData?>.Publisher{ $termsConditionsData }
    
    // MARK: - Private
    private var termsConditionsUseCase: TermsConditionsUseCase
    
    init(termsConditionsUseCase: TermsConditionsUseCase) {
        self.termsConditionsUseCase = termsConditionsUseCase
        
    }
    
    func viewDidLoad() {
        termsConditions()
    }
    
    // MARK: - Private Methods
    
    private 
    func termsConditions() {
        isLoading.send(true)
        
        termsConditionsUseCase.execute() // Assuming this returns `AnyPublisher<TermsConditionsModel, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("Terms and Conditions data fetch successful")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                self.termsConditionsData = request
            })
            .store(in: &cancellables) // Store the subscription to avoid memory leaks
    }
    
}
