//
//  DeleteAccountUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 24/01/2025.
//

import Foundation
import Combine

class DeleteAccountUseCase {
    
    private let repo: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute() -> AnyPublisher<DeleteAccountModel, NetworkError> {
        return repo.deleteAccount()
    }
}
