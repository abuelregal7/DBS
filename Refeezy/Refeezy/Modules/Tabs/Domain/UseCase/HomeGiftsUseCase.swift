//
//  HomeGiftsUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation
import Combine

class HomeGiftsUseCase {
    
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    var errorPublisher: AnyPublisher<NetworkError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute() -> AnyPublisher<[HomeGiftsData], NetworkError> {
        return repo.homeGifts()
    }
}
