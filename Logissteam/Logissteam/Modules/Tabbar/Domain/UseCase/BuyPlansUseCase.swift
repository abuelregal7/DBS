//
//  BuyPlansUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation
import Combine

class BuyPlansUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: BuyPlansRequest) -> AnyPublisher<[BuyPlansModelData], NetworkError> {
        return repo.buyPlans(body: body)
    }
}
