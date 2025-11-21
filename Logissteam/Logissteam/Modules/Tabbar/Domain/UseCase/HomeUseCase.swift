//
//  HomeUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import Combine

class HomeUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: HomeDealsRequest) -> AnyPublisher<HomeData, NetworkError> {
        return repo.home(body: body)
    }
}
