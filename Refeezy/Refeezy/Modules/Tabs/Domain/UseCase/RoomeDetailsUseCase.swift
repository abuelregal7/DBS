//
//  RoomeDetailsUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation
import Combine

class RoomeDetailsUseCase {
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: RoomDetailsRequest) -> AnyPublisher<RoomDetailsData, NetworkError> {
        return repo.roomeDetails(body: body)
    }
}
