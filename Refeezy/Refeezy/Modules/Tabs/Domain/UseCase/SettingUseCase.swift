//
//  SettingUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 17/04/2025.
//

import Foundation
import Combine

class SettingUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute() -> AnyPublisher<[SettingData], NetworkError> {
        return repo.setting()
    }
}
