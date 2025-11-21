//
//  TermsConditionsUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 02/09/2024.
//

import Foundation
import Combine

class TermsConditionsUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute() -> AnyPublisher<TermsData, NetworkError> {
        return repo.temsConditions()
    }
}
