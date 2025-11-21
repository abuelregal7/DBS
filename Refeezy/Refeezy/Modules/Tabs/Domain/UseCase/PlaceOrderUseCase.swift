//
//  PlaceOrderUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 20/04/2025.
//

import Foundation
import Combine

class PlaceOrderUseCase {
    
    private let repo: TabsRepositoryProtocol
    
    init(repository: TabsRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: PlaceOrderRequest) -> AnyPublisher<PlaceOrderData, NetworkError> {
        return repo.placeOrder(body: body)
    }
}
