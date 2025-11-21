//
//  PrivacyPolicyUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 02/09/2024.
//

import Foundation
import Combine

class PrivacyPolicyUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute() -> AnyPublisher<PrivacyPolicyData, NetworkError> {
        return repo.privacyPolicy()
    }
}
