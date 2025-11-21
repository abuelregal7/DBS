//
//  MyOrderesUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 12/04/2025.
//

import Foundation
import Combine

class MyOrderesUseCase {
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: MyOrderesRequest) -> AnyPublisher<MyOrderesData, NetworkError> {
        return repo.myOrderes(body: body)
    }
}
