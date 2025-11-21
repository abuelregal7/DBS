//
//  AddAddressUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation
import Combine

class AddAddressUseCase {
    
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    var errorPublisher: AnyPublisher<NetworkError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: AddAddressRequest) -> AnyPublisher<AddAddressModel, NetworkError> {
        return repo.addAddress(body: body)
    }
}
