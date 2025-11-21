//
//  ContactUsUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
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
