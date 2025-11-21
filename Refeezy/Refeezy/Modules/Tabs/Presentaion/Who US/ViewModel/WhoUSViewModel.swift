//
//  WhoUSViewModel.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 16/04/2025.
//

import Foundation
import Combine

protocol WhoUSViewModelProtocol {
    // Inputs
    func viewDidLoad()
    
    var aboutUSData: AboutUSData? { get }
    var aboutUSDataPublisher: Published<AboutUSData?>.Publisher { get }
    
}

class WhoUSViewModel: BaseViewModel, WhoUSViewModelProtocol {
    
    @Published var aboutUSData : AboutUSData?
    var aboutUSDataPublisher   : Published<AboutUSData?>.Publisher{ $aboutUSData }
    
    // MARK: - Private
    private var aboutUSUseCase: AboutUsUseCase
    
    init(aboutUSUseCase: AboutUsUseCase) {
        self.aboutUSUseCase = aboutUSUseCase
        
    }
    
    func viewDidLoad() {
        aboutUS()
    }
    
    // MARK: - Private Methods
    
    private func aboutUS() {
        isLoading.send(true)
        
        aboutUSUseCase.execute() // Assuming this returns `AnyPublisher<AboutUSModel, NetworkError>`
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading.send(false)
                
                switch completion {
                case .finished:
                    print("About Us data fetch successful")
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] request in
                guard let self = self else { return }
                self.aboutUSData = request
            })
            .store(in: &cancellables) // Store the subscription to avoid memory leaks
    }

    
}
