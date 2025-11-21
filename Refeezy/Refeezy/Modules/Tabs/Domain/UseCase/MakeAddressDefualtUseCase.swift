//
//  MakeAddressDefualtUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation
import Combine

class MakeAddressDefualtUseCase {
    
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    var errorPublisher: AnyPublisher<NetworkError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: MakeAddressDefualtRequest) -> AnyPublisher<MakeAddressDefualtModel, NetworkError> {
        return repo.makeAddressDefualt(body: body)
    }
}
