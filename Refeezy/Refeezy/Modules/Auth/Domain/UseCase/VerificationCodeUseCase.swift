//
//  VerificationCodeUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation
import Combine

class VerificationCodeUseCase {
    
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    var errorPublisher: AnyPublisher<NetworkError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    private let repo: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: VerificationCodeRequest) -> AnyPublisher<VerificationCodeData, NetworkError> {
        return repo.verificationCode(body: body)
    }
}
