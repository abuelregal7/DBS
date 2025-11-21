//
//  BaseViewModel.swift
//  Wala
//
//  Created by Ibrahim Nabil on 05/02/2024.
//

import Foundation
import Combine

protocol ViewModel {
    var cancellables: Set<AnyCancellable> { get }
    var isLoading: PassthroughSubject<Bool, Never> { get }
    var errorPublisher: PassthroughSubject<String?, Never> { get }
    var errorUnAuthorizedPublisher: PassthroughSubject<String?, Never> { get }
    var errorNotFoundPublisher: PassthroughSubject<String?, Never> { get }
}

class BaseViewModel {
    var cancellables: Set<AnyCancellable> = .init()
    var isLoading: PassthroughSubject<Bool, Never> = .init()
    var errorPublisher: PassthroughSubject<String, Never> = .init()
    var errorUnAuthorizedPublisher: PassthroughSubject<String?, Never> = .init()
    var errorNotFoundPublisher: PassthroughSubject<String?, Never> = .init()
    
    func handleError(_ error: Error) {
        print("❌ handleError called with error: \(error)")
        
        DispatchQueue.main.async {
            if let error = error as? NetworkError {
                print("Mapped NetworkError: \(error)")
                
                if error == .unauthorized {
                    self.errorUnAuthorizedPublisher.send(error.localizedErrorDescription)
                } else {
                    self.errorPublisher.send(error.localizedErrorDescription)
                }
            } else {
                print("Unknown error: \(error.localizedDescription)")
                self.errorPublisher.send(error.localizedDescription)
            }
        }
    }
    
}
