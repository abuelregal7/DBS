//
//  CategorySearchUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 08/09/2024.
//

import Foundation
import Combine

class CategorySearchUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: CategorySearchRequest) -> AnyPublisher<CategorySearchData, NetworkError> {
        return repo.search(body: body)
    }
}
