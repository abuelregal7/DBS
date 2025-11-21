//
//  UpdateProfileUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 08/04/2025.
//

import Foundation
import Combine

class UpdateProfileUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(request: UpdateProfileRequest) -> AnyPublisher<UpdateProfileModel, NetworkError> {
        return repo.updateProfile(body: request)
    }
}
