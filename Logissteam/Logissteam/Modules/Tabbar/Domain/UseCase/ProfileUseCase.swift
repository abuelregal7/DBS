//
//  ProfileUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 01/09/2024.
//

import Foundation
import Combine

class ProfileUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute() -> AnyPublisher<ProfileData, NetworkError> {
        return repo.profile()
    }
}
