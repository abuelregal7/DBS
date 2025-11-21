//
//  MyDealsUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 25/09/2024.
//

import Foundation
import Combine

class MyDealsUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: MyDealsRequest) -> AnyPublisher<MyDealsData, NetworkError> {
        return repo.myDeals(body: body)
    }
}
