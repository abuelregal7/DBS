//
//  DealDetailsUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation
import Combine

class DealDetailsUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: DealDetailsRequest) -> AnyPublisher<DealDetailsData, NetworkError> {
        return repo.dealDetails(body: body)
    }
}
