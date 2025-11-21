//
//  UpdateProfileUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 02/09/2024.
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
