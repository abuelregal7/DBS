//
//  DealsReservationUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 05/10/2024.
//

import Foundation
import Combine

class DealsReservationUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(request: DealsReservationRequest) -> AnyPublisher<DealsReservationModel, NetworkError> {
        return repo.dealsReservation(body: request)
    }
}
