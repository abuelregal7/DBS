//
//  TransferOwnershipUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 05/10/2024.
//

import Foundation
import Combine

class TransferOwnershipUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(request: TransferOwnershipRequest) -> AnyPublisher<TransferOwnershipModel, NetworkError> {
        return repo.transferOwnership(body: request)
    }
}
