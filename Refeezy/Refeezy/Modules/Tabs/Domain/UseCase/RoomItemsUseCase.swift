//
//  RoomItemsUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation
import Combine

class RoomItemsUseCase {
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: RoomItemsRequest) -> AnyPublisher<RoomItemsData, NetworkError> {
        return repo.roomItems(body: body)
    }
}
