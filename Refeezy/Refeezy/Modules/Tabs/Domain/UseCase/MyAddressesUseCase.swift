//
//  MyAddressesUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation
import Combine

class MyAddressesUseCase {
    
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    var errorPublisher: AnyPublisher<NetworkError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute() -> AnyPublisher<[MyAddressesData], NetworkError> {
        return repo.myAddresses()
    }
}
