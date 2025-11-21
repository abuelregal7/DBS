//
//  MyOrderDetailsUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation
import Combine

class MyOrderDetailsUseCase {
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: ShowOrdereRequest) -> AnyPublisher<ShowOrdereData, NetworkError> {
        return repo.myOrderDetails(body: body)
    }
}
