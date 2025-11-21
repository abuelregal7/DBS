//
//  DealsPaymentsUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation
import Combine

class DealsPaymentsUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: DealsPaymentsRequest) -> AnyPublisher<DealsPaymentsData, NetworkError> {
        return repo.dealsPayments(body: body)
    }
}
