//
//  AllRoomesUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 07/04/2025.
//

import Foundation
import Combine

class AllRoomesUseCase {
    
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    var errorPublisher: AnyPublisher<NetworkError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: AllRoomesRequest) -> AnyPublisher<AllRoomesData, NetworkError> {
        return repo.allRoomes(body: body)
    }
}
