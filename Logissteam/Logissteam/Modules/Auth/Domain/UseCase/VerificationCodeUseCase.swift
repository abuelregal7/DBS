//
//  VerificationCodeUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 01/09/2024.
//

import Foundation
import Combine

class VerificationCodeUseCase {
    
    private let repo: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(request: VerificationCodeRequest) -> AnyPublisher<VerificationCodeData, NetworkError> {
        return repo.verificationCode(body: request)
    }
}
