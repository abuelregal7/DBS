//
//  DealsContractsUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation
import Combine

class DealsContractsUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: DealsContractsRequest) -> AnyPublisher<DealsContractsData, NetworkError> {
        return repo.dealsContracts(body: body)
    }
}
