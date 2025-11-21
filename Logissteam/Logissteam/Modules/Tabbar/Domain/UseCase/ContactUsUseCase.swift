//
//  ContactUsUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 01/09/2024.
//

import Foundation
import Combine

class ContactUsUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(request: ContactUsRequest) -> AnyPublisher<ContactUsModel, NetworkError> {
        return repo.contactUs(body: request)
    }
}
